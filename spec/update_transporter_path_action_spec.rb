describe Fastlane::Actions::UpdateTransporterPathAction do
  describe '#run' do
    let(:install_path) { "fixture/path" }
    let(:default_path) { Fastlane::Transporter::DEFAULT_TRANSPORTER_INSTALL_PATH }

    it 'raises an error if transporter is not installed' do
      expect do
        update_transporter_path_lane(path: install_path)
      end.to raise_error(/No Transporter installation found at path/)
    end

    it 'sets the environment variable to custom value' do
      stub_check_install_path(install_path)
      update_transporter_path_lane(path: install_path)
      expect(ENV["FASTLANE_ITUNES_TRANSPORTER_PATH"]).to eq(install_path)
    end

    it 'sets the environment variable to default value' do
      stub_check_install_path(default_path)
      update_transporter_path_lane
      expect(ENV["FASTLANE_ITUNES_TRANSPORTER_PATH"]).to eq(default_path)
    end
  end
end
