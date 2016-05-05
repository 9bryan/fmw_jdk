#
# fmw_jdk::internal::rng_service_redhat
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::internal::rng_service_redhat() {
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
  if $::osfamily == 'RedHat' {
    if ( $::operatingsystemmajrelease == '7') {
      exec { 'sed rngd.service':
        command => "sed -i -e's/ExecStart=\\/sbin\\/rngd -f/ExecStart=\\/sbin\\/rngd -r \\/dev\\/urandom -o \\/dev\\/random -f/g' /lib/systemd/system/rngd.service",
        unless  => "grep 'ExecStart=/sbin/rngd -r /dev/urandom -o /dev/random -f' /lib/systemd/system/rngd.service",
        path    => $path,
        require => Package['rng-tools'],
      }

      exec { 'systemctl-daemon-reload':
        command     => '/bin/systemctl --system daemon-reload',
        path        => $path,
        subscribe   => Exec['sed rngd.service'],
        refreshonly => true,
        notify      => Service['rngd'],
      }

      service { 'rngd':
        ensure  => 'running',
        enable  => true,
        require => Exec['systemctl-daemon-reload'],
      }

    } else {
      exec { 'sed rngd.service':
        command => "sed -i -e's/EXTRAOPTIONS=\"\"/EXTRAOPTIONS=\"-r \\/dev\\/urandom -o \\/dev\\/random -b\"/g' /etc/sysconfig/rngd",
        unless  => "grep '^EXTRAOPTIONS=\"-r /dev/urandom -o /dev/random -b\"' /etc/sysconfig/rngd",
        path    => $path,
        require => Package['rng-tools'],
        notify  => Service['rngd'],
      }

      service { 'rngd':
        ensure  => 'running',
        enable  => true,
        require => Exec['sed rngd.service'],
      }

      exec { 'chkconfig rngd':
        command => 'chkconfig --add rngd',
        unless  => "chkconfig | /bin/grep 'rngd'",
        path    => $path,
        require => Service['rngd'],
      }
    }
  }
}