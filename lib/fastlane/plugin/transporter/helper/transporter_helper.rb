require 'fastlane_core/ui/ui'

# Extend Fastlane module from Fastlane gem.
module Fastlane
  # Alias for displaying UI messages.
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  # Extend Fastlane::Helper module from Fastlane gem.
  module Helper
    # Transporter helper class.
    class TransporterHelper
      # class methods that you define here become available in your action
      # as `Helper::TransporterHelper.your_method`
      def self.show_message
        UI.message("Hello from the transporter plugin helper!")
      end

      # Check if shell command exists.
      # @param [String] cmd Shell command.
      # @return [Boolean] A Boolean indicating whether input is an existing shell command.
      def self.command_exist?(cmd)
        `which #{cmd} 2>/dev/null`.chomp != ""
      end

      # Check if string is a correct URI.
      # @param [String] string URI to check.
      # @return [Boolean] A Boolean indicating whether input is a valid URI.
      def self.uri?(string)
        uri = URI.parse(string)
        %w[http https file].include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end

      # Fetch file from URI or return path if it's local.
      # @param [String] path URI or path of the file to fetch.
      # @return [String] Path to fetched file.
      def self.fetch_file(path)
        return path if path.nil? || !uri?(path)

        UI.message("Downloading #{path}...")
        target_path = Tempfile.new(File.basename(path)).path
        cmd = "curl --progress-bar -L #{path.shellescape} -o #{target_path.shellescape}"
        result = system(cmd) # Won't get progress showing if using Action.sh here.
        UI.user_error!("Failed to fetch file: #{path}") unless result

        File.expand_path(target_path)
      end

      # Find Root CA certificate with given name or path.
      # @param [String] name Name of root CA or path to certificate file.
      # @return [String] Path to root CA certificate.
      def self.find_root_ca(name)
        expanded_name = File.expand_path(name)
        return expanded_name if File.exist?(expanded_name)

        root_ca_file = Tempfile.new("root_ca.pem").path
        if FastlaneCore::Helper.is_mac?
          result = system("security find-certificate -c #{name.shellescape} -p >#{root_ca_file}")
          UI.user_error!("Could not find certificate: #{name}") unless result
        else
          UI.user_error!("Certificate lookup is not supported on OS other than Mac yet")
        end

        root_ca_file
      end

      # Extract tarball to destination.
      # @param [String] tarball Path to tarball.
      # @param [String] destination Destination path.
      def self.extract_tarball(tarball, destination)
        warning_args = "--warning=no-unknown-keyword" unless FastlaneCore::Helper.is_mac?
        system("tar #{warning_args} -xzf #{tarball} -C #{destination} --strip-components=1")
      end
    end
  end
end
