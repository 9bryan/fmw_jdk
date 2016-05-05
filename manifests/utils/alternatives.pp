#
# fmw_jdk::utils::alternatives
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_jdk::utils::alternatives(
  $java_home_dir = undef,
  $priority      = undef,
  $user          = undef,
  $group         = undef,
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  case $::osfamily {
    'RedHat': {
      $alt_command = 'alternatives'
    }
    'Debian', 'Suse':{
      $alt_command = 'update-alternatives'
    }
    default: {
      fail("Unrecognized osfamily ${::osfamily}, please use it on a Linux host")
    }
  }

  exec { "java alternatives ${title}":
    command => "${alt_command} --install /usr/bin/${title} ${title} ${java_home_dir}/bin/${title} ${priority}",
    unless  => "${alt_command} --display ${title} | /bin/grep ${java_home_dir} | /bin/grep 'priority ${priority}$'",
    path    => $path,
    user    => $user,
    group   => $group,
  }
}
