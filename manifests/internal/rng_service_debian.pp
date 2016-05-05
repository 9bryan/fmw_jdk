#
# fmw_jdk::internal::rng_service_debian
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::internal::rng_service_debian() {
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
  if $::osfamily == 'Debian' {
    exec { 'sed rng-tools':
      command => "sed -i -e's/#HRNGDEVICE=\\/dev\\/null/HRNGDEVICE=\\/dev\\/urandom/g' /etc/default/rng-tools",
      unless  => "grep '^HRNGDEVICE=/dev/urandom' /etc/default/rng-tools",
      path    => $path,
      require => Package['rng-tools'],
      notify  => Service['rng-tools'],
    }

    service { 'rng-tools':
      ensure    => 'running',
      enable    => true,
      hasstatus => false,
      pattern   => '/usr/sbin/rngd',
      require   => Exec['sed rng-tools'],
    }
  }
}