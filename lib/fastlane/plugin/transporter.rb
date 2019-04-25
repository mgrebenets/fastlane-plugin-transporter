require 'fastlane/plugin/transporter/version'

module Fastlane
  module Transporter
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end

    # Default installation path.
    DEFAULT_TRANSPORTER_PATH = File.expand_path("~/itms")

    # Install transporter.
    # @param source [String] Transporter tarball URL or path; or path to existing Transporter directory.
    # @param install_path [String] Transporter install path.
    # @param force [Boolean] Overwrite existing installation. Default is `false`.
    def self.install(
      source: "TODO/iTMSTransporter_1.13.0.tgz",
      install_path: DEFAULT_TRANSPORTER_PATH,
      force: false
    )
      if File.exist?(install_path) && !force
        FastlaneCore::UI.message("Transporter is already installed at path: #{install_path.green}")
        FastlaneCore::UI.message("Use #{'force'.green}:#{'true'.yellow} option to overwrite")
        return
      end

      return if install_path == source # Source is same as destination.
      # TODO: Just copy over if source is a directory.

      FileUtils.rm_rf(install_path)
      FileUtils.mkdir_p(install_path)

      tar_path = FileUtils.fetch_file(source)
      Fastlane::Actions.sh("tar -xzf #{tar_path} -C #{install_path.shellescape} --strip-components=1")
    end

    # Patch Transporter installation.
    # @param install_path [String] Transporter install path.
    # @param root_ca [String] Name of Internal Root CA certificate to add to Transporter's Java certificate keystore.
    def self.patch(
      install_path: DEFAULT_TRANSPORTER_PATH,
      root_ca:,
      allow_basic_auth: false
    )
      FastlaneCore::UI.user_error!("No Transporter installation found at path: #{install_path.red}") unless File.exist?(install_path)

      root_ca_file = Tempfile.new("root_ca.pem").path
      Fastlane::Actions.sh("security find-certificate -c #{root_ca} -p >#{root_ca_file}")

      cmd = [
        "#{install_path}/java/bin/keytool",
        "-list",
        "-keystore #{install_path}/java/lib/security/cacerts",
        "-storepass changeit",
        "-alias #{root_ca}"
      ].join(" ")
      cert_exists = system(cmd)
      if cert_exists
        FastlaneCore::UI.message("Transporter is already patched.")
        return
      end

      # Patch the transporter with internal root CA.
      cmd = [
        "#{install_path}/java/bin/keytool",
        "-import",
        "-trustcacerts",
        "-alias #{root_ca}",
        "-file #{root_ca_file}",
        "-keystore #{install_path}/java/lib/security/cacerts",
        "-storepass changeit",
        "-noprompt",
        "-v"
      ].join(" ")
      Fastlane::Actions.sh(cmd)

      # Allow basic auth.
      Fastlane::Actions.sh("sed -i '' 's/=Basic/=/g' #{install_path}/java/lib/net.properties") if allow_basic_auth
    end

    # Update Fastlane's Transporter path environment variable.
    def self.update_fastlane_path(path: DEFAULT_TRANSPORTER_PATH)
      ENV["FASTLANE_ITUNES_TRANSPORTER_PATH"] = path
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::Transporter.all_classes.each do |current|
  require current
end
