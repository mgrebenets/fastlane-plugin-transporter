require 'fastlane/action'
require_relative '../helper/transporter_helper'
require_relative '../../transporter'

module Fastlane
  module Actions
    # Action to update iTMSTransporter path in environment variable.
    class UpdateTransporterPathAction < Action
      def self.run(params)
        Transporter.update_path(path: params[:path])
      end

      def self.description
        "Configure Fastlane to use custom Transporter installation"
      end

      def self.authors
        ["Maksym Grebenets"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Sets the FASTLANE_ITUNES_TRANSPORTER_PATH environment variable"
      end

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

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
