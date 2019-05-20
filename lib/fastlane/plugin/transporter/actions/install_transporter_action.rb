require 'fastlane/action'
require_relative '../helper/transporter_helper'
require_relative '../../transporter'

module Fastlane
  # Add new actions by extending Fastlane::Actions module.
  module Actions
    # Action class to install iTMSTransporter.
    class InstallTransporterAction < Action
      # Run action.
      # @param [Hash] params Action parameters.
      def self.run(params)
        Transporter.install(
          source: params[:source],
          install_path: params[:install_path],
          overwrite: params[:overwrite]
        )
      end

      # Plugin action description.
      def self.description
        "Install Apple iTMSTransporter"
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
      end

      # Plugin action available options.
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :source,
                                  env_name: "INSTALL_TRANSPORTER_SOURCE",
                               description: "A path or URI to Transporter tarball or directory",
                             default_value: Transporter::DEFAULT_TRANSPORTER_SOURCE,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :install_path,
                                  env_name: "INSTALL_TRANSPORTER_INSTALL_PATH",
                               description: "Transporter install path",
                             default_value: Transporter::DEFAULT_TRANSPORTER_INSTALL_PATH,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :overwrite,
                                  env_name: "INSTALL_TRANSPORTER_OVERWRITE",
                               description: "Overwrite existing installation",
                             default_value: false,
                                      type: Boolean)
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
