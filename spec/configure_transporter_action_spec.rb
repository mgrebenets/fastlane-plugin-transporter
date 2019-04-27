describe Fastlane::Actions::ConfigureTransporterAction do
  describe '#run' do
    # TODO:
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The transporter plugin is working!")

      Fastlane::Actions::ConfigureTransporterAction.run(nil)
    end
  end
end
