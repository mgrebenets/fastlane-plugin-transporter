describe Fastlane::Actions::ConfigureTransporterAction do
  describe '#run' do
    let(:unpacked_transporter_path) { unpack_transporter }

    it 'raises an error if transporter is not installed' do
      expect do
        configure_transporter_lane(install_path: "nosuchpath", enable_basic_auth: true)
      end.to raise_error(/No Transporter installation found at path/)
    end

    it 'adds root ca certificate to keystore by path' do
      # TODO:
    end

    it 'returns early if ca certificate already exists in keystore' do
      # TODO:
    end

    it 'enables basic authentication' do
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
