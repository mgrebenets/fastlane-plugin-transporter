require 'fastlane/action'
require_relative '../helper/transporter_helper'
require_relative '../../transporter'

module Fastlane
  module Actions
    class ConfigureTransporterAction < Action
      def self.run(params)
        Transporter.add_root_ca(install_path: params[:install_path], root_ca: params[:root_ca]) if params[:root_ca]
        Transporter.enable_basic_auth(install_path: params[:install_path]) if params[:enable_basic_auth]
      end

      def self.description
        "Configure Apple iTMSTransporter installation"
      end

      def self.authors
        ["Maksym Grebenets"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        [
          "- Add self-signed root Certificate Authority certificate to Transporter keystore",
          "- Enable basic authentication"
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :install_path,
                                  env_name: "CONFIGURE_TRANSPORTER_INSTALL_PATH",
                               description: "Transporter install path",
                             default_value: Transporter::DEFAULT_TRANSPORTER_INSTALL_PATH,
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :root_ca,
                                  env_name: "CONFIGURE_TRANSPORTER_ROOT_CA",
                               description: "Add specified root CA to Transporter's keystore",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :enable_basic_auth,
                                  env_name: "CONFIGURE_TRANSPORTER_ENABLE_BASIC_AUTH",
                               description: "Enable basic authentication in Transporter configuration",
                             default_value: false,
                                  optional: true,
                                      type: Boolean)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
