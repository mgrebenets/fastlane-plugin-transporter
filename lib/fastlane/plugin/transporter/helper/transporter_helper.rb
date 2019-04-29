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

      # Check if string is a correct URI.
      def self.uri?(string)
        uri = URI.parse(string)
        %w[http https file].include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end

      # Fetch file from URI or return path if it's local.
      def self.fetch_file(path)
        return path if path.nil? || !uri?(path)

        UI.message("Downloading #{path}...")
        target_path = Tempfile.new(File.basename(path)).path
        cmd = "curl --progress-bar -L #{path.shellescape} -o #{target_path.shellescape}"
        `#{cmd}` # Won't get progress showing if using Action.sh here.

        File.expand_path(target_path)
      end

      # Find Root CA certificate with given name or path.
      def self.find_root_ca(name)
        expanded_name = File.expand_path(name)
        return expanded_name if File.exist?(expanded_name)

        root_ca_file = Tempfile.new("root_ca.pem").path
        if FastlaneCore::Helper.is_mac?
          Fastlane::Actions.sh("security find-certificate -c #{name} -p >#{root_ca_file}")
        else
          FastlaneCore::UI.user_error!("Certificate lookup is not supported on OS other that Mac yet")
        end

        root_ca_file
      end
    end
  end
end
