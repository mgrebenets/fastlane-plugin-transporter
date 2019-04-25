describe Fastlane::Actions::TransporterAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The transporter plugin is working!")

      Fastlane::Actions::TransporterAction.run(nil)
    end
  end
end
