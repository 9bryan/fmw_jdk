# fmw_jdk

#### Table of Contents

1. [Overview - What is the fmw_jdk module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_jdk](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: install](#manifest-install)
        * [Manifest: rng_service](#manifest-rng_service)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_jdk module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_jdk module allows you to install and configure an Oracle JDK on a Windows, Linux or Solaris host. Also it can configure the rng service ( random number generator, urandom) on a linux node, this will fix the lack of Entropy on a linux VM.

## Module description

This modules allows you to install any JDK version 7 or 8 on any Windows, Linux or Solaris host or VM. Besides installing the JDK you will also be able to control which JDK will the default by setting all symbolic links for java, javac, keytool etc. For Linux hosts you are also be able to configure and start the rng service ( random number generator, urandom, Hardware RNG Entropy Gatherer Daemon) which solves the lack of Entropy (urandom)

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

This is an empty manifest and does not do anything

#### Manifest install

This will install the JDK on a host

rpm can only be used on a RedHat family platform

    class { 'fmw_jdk::install':
      java_home_dir => '/usr/java/jdk1.8.0_45',
      source_file   => '/software/jdk-8u45-linux-x64.rpm',
    }

All other linux distributions ( RedHat family included) can also use tar.gz source_file

    class { 'fmw_jdk::install':
      java_home_dir => '/usr/java/jdk1.8.0_40',
      source_file   => '/software/jdk-8u40-linux-x64.tar.gz',
    }

Windows

    class { 'fmw_jdk::install':
      java_home_dir => 'c:\\java\\jdk1.7.0_75',
      source_file   => 'c:\\software\\jdk-7u75-windows-x64.exe',
    }

Solaris ( tar.gz or tar.Z SVR4 package)

    class { 'fmw_jdk::install':
      java_home_dir => '/usr/jdk/instances/jdk1.8.0_40',
      source_file   => '/software/jdk-8u40-solaris-x64.tar.gz',
    }

    class { 'fmw_jdk::install':
      java_home_dir => '/usr/jdk/instances/jdk1.8.0',
      source_file   => '/software/jdk-8u40-solaris-x64.tar.Z',
    }

Solaris JDK 7 with x64 entensions

    class { 'fmw_jdk::install':
      java_home_dir   => '/usr/jdk/instances/jdk1.7.0_75',
      source_file     => '/software/jdk-7u75-solaris-i586.tar.gz',
      source_x64_file => '/software/jdk-7u75-solaris-x64.tar.gz',
    }

    class { 'fmw_jdk::install':
      java_home_dir   => '/usr/jdk/instances/jdk1.7.0',
      source_file     => '/software/jdk-7u75-solaris-i586.tar.Z',
      source_x64_file => '/software/jdk-7u75-solaris-x64.tar.Z',
    }

#### Manifest rng_service

This will install and configure the rng package on any RedHat or Debian family linux distributions. For windows or solaris platforms this is not necessary and this manifest will do just a return when this manifest is executed on one of those hosts.

    include fmw_jdk::rng_service

## Limitations

This should work on Windows, Solaris, Linux (Any RedHat or Debian platform family distribution)

## Development

### Contributing

Community contributions are essential for keeping them great. We want to keep it as easy as possible to contribute changes so that our cookbooks work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

### Running-tests

This project contains tests for puppet-lint, puppet-syntax, puppet-rspec, rubocop and beaker. For in-depth information please see their respective documentation.

Quickstart:

    yum install -y ruby-devel gcc zlib-devel libxml2 libxslt
    yum install -y libxml2-devel libxslt-devel
    gem install bundler --no-rdoc --no-ri
    bundle install --without development

    bundle exec rake syntax
    bundle exec rake lint
    # symbolic error under windows , https://github.com/mitchellh/vagrant/issues/713#issuecomment-13201507. start vagrant in admin cmd session
    bundle exec rake spec
    bundle exec rubocop

    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=centos-70-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=debian-78-x64 bundle exec rspec spec/acceptance

    # Ruby on Windows
    use only 32-bits, its more stable, http://rubyinstaller.org/downloads/

    Ruby 2.0.0-p598 to C:\Ruby\200_puppet
    Ruby Development kit to C:\Ruby\2_devkit, so you can optionally build your gems

    set PATH=%PATH%;C:\Ruby\200_puppet\bin
    C:\Ruby\2_devkit\devkitvars.bat
    ruby -v

    set SOFTWARE_FOLDER=c:/software
    set BEAKER_destroy=onpass
    set BEAKER_debug=true
    set BEAKER_set=centos-70-x64
    set BEAKER_set=debian-78-x64
    set BEAKER_set=oel-5.8-x64
    set BEAKER_set=solaris-10-x64
    set BEAKER_set=solaris-11.2-x64

    bundle exec rspec spec/acceptance

    bundle exec rake yard
