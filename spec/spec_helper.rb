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

def stub_check_install_path(path)
  expect(Fastlane::Transporter).to receive(:check_install_path).with(install_path: path).and_return(nil)
end

def update_transporter_path_lane(path: nil)
  path_arg = path ? "path: '#{path}'" : ""
  Fastlane::FastFile.new.parse("lane :test do
    update_transporter_path(#{path_arg})
  end").runner.execute(:test)
end
