require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class TransporterHelper
      # class methods that you define here become available in your action
      # as `Helper::TransporterHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the transporter plugin helper!")
      end

      # Check if shell command exists.
      def self.command_exist?(cmd)
        `which #{cmd} 2>/dev/null`.chomp != ""
      end
    end
  end
end
