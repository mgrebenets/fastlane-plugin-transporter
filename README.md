# transporter plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-transporter)
[![version](https://img.shields.io/github/tag/mgrebenets/fastlane-plugin-transporter.svg?color=green&label=version)](https://github.com/mgrebenets/fastlane-plugin-transporter)
[![CircleCI](https://circleci.com/gh/mgrebenets/fastlane-plugin-transporter.svg?style=svg)](https://circleci.com/gh/mgrebenets/fastlane-plugin-transporter)
[![Travis CI](https://img.shields.io/travis/mgrebenets/fastlane-plugin-transporter.svg?label=%20&logo=travis)](https://travis-ci.org/mgrebenets/fastlane-plugin-transporter)
[![Coverage Status](https://coveralls.io/repos/github/mgrebenets/fastlane-plugin-transporter/badge.svg)](https://coveralls.io/github/mgrebenets/fastlane-plugin-transporter)


## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-transporter`, add it to your project by running:

```shell
fastlane add_plugin transporter
```

## About transporter

Adds actions to manage Apple iTMSTransporter installation.

Apart from installing Transporter, this plugin allows you to configure Transporter installation.
This is very useful in enterprise environment, where you need to work with self-signed root CA and/or company proxy.

⚠️ Only Mac OS X is supported at the moment.

### install_transporter

The `install_transporter` action downloads and unpacks Transporter package and installs it to specified path.

Instead of downloading Transporter package from remote source a path to local copy of tarball can be specified or even a path to already unpacked Transporter directory.

### configure_transporter

The `configure_transporter` action allows configuring Transporter after installation.

If you need to use Transporter in enterprise setup with self-signed root CA used to encrypt all your network traffic, you need to add this root CA certificate to Transporter's keystore using `root_ca` parameter. This parameter can be either a path to the certificate or certificate Common Name.

To enable Basic authentication for Transporter network calls, set `enable_basic_auth` to `true`.

### update_transporter_path

This action updates `FASTLANE_ITUNES_TRANSPORTER_PATH` with the specified install path. This environment variable is used by Fastlane to run actions like `deliver` or `pilot`.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

The example lane installs Transporter to `~/itms`, then adds Apple iPhone Certification Authority certificate to Transporter keystore and finally sets the `FASTLANE_ITUNES_TRANSPORTER_PATH` environment variable so that Fastlane can use this custom installation.

## Run tests for this plugin

To run both the tests, and code style validation, run

```shell
rake
```

To automatically fix many of the styling issues, use

```shell
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

### Linux and Windows Support

Transporter package for Linux and Windows is different from the OS X version. The java binaries like `java/bin/java` and `java/bin/keytool` are actual executables compiled for target platform.

To support Linux and Windows a different package would have to be downloaded and installed.
The installation script is different from just unpack-and-copy version of Mac OS X.
For example, [this is the Linux installation script](https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/resources/download/Transporter__linux/bin/).

### Remove or Overwrite Root CA Certificates

Q: Why is there no way to remove or overwrite existing root CA entry in Transporter's keystore?

This is a valid option but root CA certs don't expire that often.
There's always a workaround of just reinstalling Transporter.
If such option becomes very important, it can be added in the future.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
