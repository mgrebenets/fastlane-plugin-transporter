describe Fastlane::Actions::ConfigureTransporterAction do
  describe '#run' do
    let(:unpacked_transporter_path) { unpack_transporter }
    let(:root_ca) { fixture_path("fixtures/root_ca.pem") }

    it 'raises an error if transporter is not installed' do
      expect do
        configure_transporter_lane(install_path: "nosuchpath", enable_basic_auth: true)
      end.to raise_error(/No Transporter installation found at path/)
    end

    context 'root ca' do
      if FastlaneCore::Helper.mac?
        it 'adds root ca certificate to keystore by path' do
          expect(FastlaneCore::UI).to receive(:success)
          expect(FastlaneCore::UI).to receive(:success).with(/Added root CA certificate to keystore/)

          install_path = make_install_path("add-root-ca")
          Fastlane::Transporter.install(source: unpacked_transporter_path, install_path: install_path)
          configure_transporter_lane(install_path: install_path, root_ca: root_ca)
        end

        it 'returns early if ca certificate already exists in keystore' do
          expect(FastlaneCore::UI).to receive(:success)
          expect(FastlaneCore::UI).to receive(:success).with(/Added root CA certificate to keystore/)
          expect(FastlaneCore::UI).to receive(:success)
          expect(FastlaneCore::UI).to receive(:message).with(/Transporter is already configured for this root CA/)

          install_path = make_install_path("add-same-root-ca")
          Fastlane::Transporter.install(source: unpacked_transporter_path, install_path: install_path)
          configure_transporter_lane(install_path: install_path, root_ca: root_ca)
          configure_transporter_lane(install_path: install_path, root_ca: root_ca)
        end
      end
      # Only supported for Mac at the moment.
    end

    it 'enables basic authentication' do
      expect(FastlaneCore::UI).to receive(:success)
      expect(FastlaneCore::UI).to receive(:success).with(/Basic authentication is enabled/)

      install_path = make_install_path("enable-basic-auth")
      Fastlane::Transporter.install(source: unpacked_transporter_path, install_path: install_path)
      configure_transporter_lane(install_path: install_path, enable_basic_auth: true)
      properties_file = File.join(install_path, "java/lib/net.properties")
      expect(File.read(properties_file)).not_to(include("=Basic"))
    end

    if FastlaneCore::Helper.mac?
      it 'raises error when fails to find certificate by name' do
        install_path = make_install_path("add-root-ca-by-name-fail")
        Fastlane::Transporter.install(source: unpacked_transporter_path, install_path: install_path)
        expect do
          configure_transporter_lane(install_path: install_path, root_ca: "NoSuchName")
        end.to raise_error(/Could not find certificate:/)
      end

      it 'adds root ca certificate to keystore by name' do
        setup_test_keychain
        install_path = make_install_path("add-root-ca-by-name")
        Fastlane::Transporter.install(source: unpacked_transporter_path, install_path: install_path)
        configure_transporter_lane(install_path: install_path, root_ca: "Apple iPhone Certification Authority")
      end
    else
      it 'fails when trying to find certificate by name on non Mac platform' do
        install_path = make_install_path("root-ca-by-name-non-os-x")
        Fastlane::Transporter.install(source: unpacked_transporter_path, install_path: install_path)
        expect do
          configure_transporter_lane(install_path: install_path, root_ca: "NoSuchName")
        end.to raise_error(/Certificate lookup is not supported on OS other than Mac yet/)
      end
    end
  end
end
