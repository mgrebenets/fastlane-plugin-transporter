require 'fastlane/action'
require_relative '../helper/transporter_helper'
require_relative '../../transporter'

module Fastlane
  module Actions
    class InstallTransporterAction < Action
      def self.run(params)
        Transporter.install(
          source: params[:source],
          install_path: params[:install_path],
          overwrite: params[:overwrite]
        )
      end

      def self.description
        "Install Apple iTMSTransporter"
      end

      def self.authors
        ["Maksym Grebenets"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
      end

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

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
