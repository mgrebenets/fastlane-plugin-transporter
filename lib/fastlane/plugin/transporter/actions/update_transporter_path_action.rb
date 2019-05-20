require 'fastlane/action'
require_relative '../helper/transporter_helper'
require_relative '../../transporter'

module Fastlane
  module Actions
    # Action to update iTMSTransporter path in environment variable.
    class UpdateTransporterPathAction < Action
      # Run action.
      # @param [Hash] params Action parameters.
      def self.run(params)
        Transporter.update_path(path: params[:path])
      end

      # Plugin action description.
      def self.description
        "Configure Fastlane to use custom Transporter installation"
      end

      # List of plugin action authors.
      def self.authors
        ["Maksym Grebenets"]
      end

      # Plugin action return value.
      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      # Plugin action details.
      def self.details
        "Sets the FASTLANE_ITUNES_TRANSPORTER_PATH environment variable"
      end

      # Plugin action available options.
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                  env_name: "UPDATE_TRANSPORTER_PATH",
                               description: "Transporter install path",
                             default_value: Transporter::DEFAULT_TRANSPORTER_INSTALL_PATH,
                                  optional: true,
                                      type: String)
        ]
      end

      # Check if action supports the platform.
      # @param [Symbol] platform Platform to check.
      # @return [Boolean] A Boolean indicating whether action supports the platform.
      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
