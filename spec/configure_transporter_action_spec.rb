describe Fastlane::Actions::ConfigureTransporterAction do
  describe '#run' do
    let(:unpacked_transporter_path) { unpack_transporter }
    let(:root_ca) { fixture_path("fixtures/root_ca.pem") }

    it 'raises an error if transporter is not installed' do
      expect do
        configure_transporter_lane(install_path: "nosuchpath", enable_basic_auth: true)
      end.to raise_error(/No Transporter installation found at path/)
    end

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
      it 'adds root ca certificate to keystore by name' do
        # TODO:
      end
    else
      it 'fails when trying to find certificate by name on non Mac platform' do
        # TODO:
      end
    end
  end
end
