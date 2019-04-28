describe Fastlane::Actions::InstallTransporterAction do
  describe '#run' do
    context 'failed installation' do
      it 'raises an error for invalid source URI' do
        # TODO:
      end

      it 'raises an error for missing source path' do
        # TODO:
      end

      it 'raises an error for corrupted tarball' do
        # TODO:
      end
    end
    context 'successful installation' do
      let(:tarball_path) { download_transporter }
      let(:unpacked_transporter_path) { unpack_transporter }

      it 'installs transporter from tarball source URI' do
        install_test(
          name: "from-tarball-uri",
          source: "file://" + File.expand_path(tarball_path)
        )
      end

      it 'installs transporter from tarball file path' do
        install_test(
          name: "from-tarball-path",
          source: tarball_path
        )
      end

      it 'installs transporter from directory path' do
        install_test(
          name: "from-directory-path",
          source: unpacked_transporter_path
        )
      end

      it 'requires overwrite option to replace existing installation' do
        expect(FastlaneCore::UI).to receive(:message).with(/Transporter is already installed at path:/)
        expect(FastlaneCore::UI).to receive(:message).with(/Use 'overwrite:true' option to overwrite/)

        install_path = make_install_path("require-overwrite")
        install_transporter_lane(source: unpacked_transporter_path, install_path: install_path)
        install_transporter_lane(source: unpacked_transporter_path, install_path: install_path)
      end

      it 'overwrites existing installation when overwrite option is set' do
        expect(FastlaneCore::UI).not_to(receive(:message).with(/Transporter is already installed at path:/))
        expect(FastlaneCore::UI).not_to(receive(:message).with(/Use 'overwrite:true' option to overwrite/))

        install_path = make_install_path("overwrite-existing")
        install_transporter_lane(source: unpacked_transporter_path, install_path: install_path)
        install_transporter_lane(source: unpacked_transporter_path, install_path: install_path, overwrite: true)
      end

      it 'does nothing when source and install paths are same' do
        expect(FastlaneCore::UI).to receive(:message).with(/Source and install path are the same/)
        install_transporter_lane(source: "same_path", install_path: "same_path")
      end

      it 'installs transporter to default path' do
        default_path = Fastlane::Transporter::DEFAULT_TRANSPORTER_INSTALL_PATH
        FileUtils.rm_rf(default_path)
        install_transporter_lane(source: unpacked_transporter_path)
        expect(File.exist?(default_path)).to be_truthy
      end
    end
  end
end
