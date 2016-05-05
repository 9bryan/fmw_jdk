#
# fmw_jdk::utils::links
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_jdk::utils::links(
  $java_home_dir = undef,
)
{
  file { "/usr/bin/${title}":
    ensure => 'link',
    target => "${java_home_dir}/bin/${title}",
    owner  => 'root',
    group  => 'bin',
    mode   => '0775',
  }
}
