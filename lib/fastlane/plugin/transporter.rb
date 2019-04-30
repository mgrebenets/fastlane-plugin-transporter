require 'fastlane/plugin/transporter/version'

module Fastlane
  module Transporter
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end

    # Default source URL.
    DEFAULT_TRANSPORTER_SOURCE = "https://github.com/mgrebenets/fastlane-plugin-transporter/releases/download/0.0.1/iTMSTransporter_1.13.0.tgz"

    # Default installation path.
    DEFAULT_TRANSPORTER_INSTALL_PATH = File.expand_path("~/itms")

    # Install transporter.
    # @param source [String] Transporter tarball URL or path; or path to existing Transporter directory.
    # @param install_path [String] Transporter install path.
    # @param overwrite [Boolean] Overwrite existing installation. Default is `false`.
    def self.install(
      source: DEFAULT_TRANSPORTER_SOURCE,
      install_path: DEFAULT_TRANSPORTER_INSTALL_PATH,
      overwrite: false
    )
      if install_path.eql?(source)
        FastlaneCore::UI.message("Source and install path are the same")
        return
      end

      if File.exist?(install_path) && !overwrite
        FastlaneCore::UI.message("Transporter is already installed at path: #{install_path.green}")
        FastlaneCore::UI.message("Use 'overwrite:true' option to overwrite")
        return
      end

      FileUtils.rm_rf(install_path)
      FileUtils.mkdir_p(install_path)

      if File.directory?(source)
        FileUtils.cp_r(File.join(source, '.'), install_path)
      else
        tar_path = Helper::TransporterHelper.fetch_file(source)
        result = system("tar --warning=no-unknown-keyword -xzf #{tar_path} -C #{install_path.shellescape} --strip-components=1")
        FastlaneCore::UI.user_error!("Failed to unpack tarball") unless result
      end
    end

    # Add root CA to Transporter installation.
    # @param install_path [String] Transporter install path.
    # @param root_ca [String] Name or file path of Internal Root CA certificate to add to Transporter's Java certificate keystore.
    def self.add_root_ca(
      install_path: DEFAULT_TRANSPORTER_INSTALL_PATH,
      root_ca:
    )
      check_install_path(install_path: install_path)

      root_ca_file = Helper::TransporterHelper.find_root_ca(root_ca)
      cert_alias = File.basename(root_ca_file)

      cmd = [
        "#{install_path}/java/bin/keytool",
        "-list",
        "-keystore #{install_path}/java/lib/security/cacerts",
        "-storepass changeit",
        "-alias #{cert_alias}"
      ].join(" ")
      cert_exists = system(cmd)
      if cert_exists
        FastlaneCore::UI.message("Transporter is already configured for this root CA.")
        return
      end

      # Patch the transporter with internal root CA.
      cmd = [
        "#{install_path}/java/bin/keytool",
        "-import",
        "-trustcacerts",
        "-alias #{cert_alias}",
        "-file #{root_ca_file}",
        "-keystore #{install_path}/java/lib/security/cacerts",
        "-storepass changeit",
        "-noprompt",
        "-v"
      ].join(" ")
      system(cmd)

      FastlaneCore::UI.success("Added root CA certificate to keystore")
    end

    # Enable basic authentication for Transporter installation.
    # @param install_path [String] Transporter install path.
    def self.enable_basic_auth(install_path: DEFAULT_TRANSPORTER_INSTALL_PATH)
      check_install_path(install_path: install_path)
      properties_file = "#{install_path}/java/lib/net.properties"
      content = File.read(properties_file).gsub("=Basic", "")
      File.open(properties_file, "w") { |f| f.puts(content) }
      FastlaneCore::UI.success("Basic authentication is enabled")
    end

    # Update Fastlane's Transporter path environment variable.
    # @param path [String] Transporter path.
    def self.update_path(path: DEFAULT_TRANSPORTER_INSTALL_PATH)
      check_install_path(install_path: path)
      ENV["FASTLANE_ITUNES_TRANSPORTER_PATH"] = path
    end

    # Check if Transporter is installed at given path.
    # @param install_path [String] Transporter install path.
    def self.check_install_path(install_path:)
      FastlaneCore::UI.user_error!("No Transporter installation found at path: #{install_path.red}") unless File.exist?(install_path)
    end
    private_class_method :check_install_path
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::Transporter.all_classes.each do |current|
  require current
end
