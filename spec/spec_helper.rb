$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'simplecov'

# SimpleCov.minimum_coverage 95
SimpleCov.start

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

require 'fastlane' # to import the Action super class
require 'fastlane/plugin/transporter' # import the actual plugin

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)

TRANSPORTER_DOWNLOAD_DIR = Dir.tmpdir
def download_transporter
  source = Fastlane::Transporter::DEFAULT_TRANSPORTER_SOURCE
  output_path = File.join(TRANSPORTER_DOWNLOAD_DIR, File.basename(source))
  return output_path if File.exist?(output_path)

  `curl --progress -L #{source} -o #{output_path}`
  output_path
end

def unpack_transporter
  tarball = download_transporter
  destination = File.join(File.dirname(tarball), "fixture-dir")
  return destination if File.exist?(destination)

  FileUtils.mkdir_p(destination)
  Fastlane::Actions.sh(`tar -xzf #{tarball} -C #{destination} --strip-components=1`, log: false)
end

def make_install_path(name)
  install_path = File.join(Dir.tmpdir, name)
  FileUtils.rm_rf(install_path)
  install_path
end

def stub_check_install_path(path)
  expect(Fastlane::Transporter).to receive(:check_install_path).with(install_path: path).and_return(nil)
end

def install_transporter_lane(source:, install_path: nil, overwrite: false)
  install_path_arg = install_path ? "install_path: '#{install_path}'," : ""
  Fastlane::FastFile.new.parse("lane :test do
    install_transporter(
      source: '#{source}',
      #{install_path_arg}
      overwrite: #{overwrite}
    )
  end").runner.execute(:test)
end

def update_transporter_path_lane(path: nil)
  path_arg = path ? "path: '#{path}'" : ""
  Fastlane::FastFile.new.parse("lane :test do
    update_transporter_path(#{path_arg})
  end").runner.execute(:test)
end

def configure_transporter_lane(install_path: nil, root_ca: nil, enable_basic_auth: nil)
  args = [
    install_path ? "install_path: '#{install_path}'" : nil,
    root_ca ? "root_ca: '#{root_ca}'" : nil,
    enable_basic_auth ? "root_ca: #{enable_basic_auth}" : nil
  ].compact.join(",")

  Fastlane::FastFile.new.parse("lane :test do
    configure_transporter(#{args})
  end").runner.execute(:test)
end

def failed_install_test(name:, source:, message: /Failed to unpack tarball/)
  expect(FastlaneCore::UI).to receive(:user_error!).with(message)
  install_path = make_install_path(name)
  install_transporter_lane(source: source, install_path: install_path)
end

def successful_install_test(name:, source:)
  install_path = make_install_path(name)
  expect(File.exist?(install_path)).to be_falsy
  install_transporter_lane(source: source, install_path: install_path)
  expect(File.exist?(install_path)).to be_truthy
end
