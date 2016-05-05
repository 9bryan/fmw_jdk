#
# fmw_jdk::rng_service
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::rng_service() {

  unless $::kernel == 'Linux' {
    fail('Unrecognized operating system, use this class on a Linux host')
  }

  package { 'rng-tools':
    ensure => present,
  }

  case $::osfamily {
    'RedHat': {
      include fmw_jdk::internal::rng_service_redhat
    }
    'Debian' : {
      include fmw_jdk::internal::rng_service_debian
    }
    default: {
      fail("Unrecognized osfamily ${::osfamily}, please use it on a Debian, RedHat Family Linux host")
    }
  }
}