#
# fmw_jdk::internal::jdk_linux
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::internal::jdk_linux(
  $java_home_dir = undef,
  $source_file   = undef,
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  $java_home_parent_dir = fmw_parent_folder($java_home_dir)

  file { $java_home_parent_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }

  exec { 'Unpack JDK':
    command => "tar xzvf ${source_file} --directory ${java_home_parent_dir}",
    path    => $path,
    user    => 'root',
    creates => $java_home_dir,
    require => File[$java_home_parent_dir],
  }

  file { $java_home_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Exec['Unpack JDK'],
  }

  exec { "chown -R root:root ${java_home_dir}":
    unless  => "ls -al ${java_home_dir}/bin/java | awk ' { print \$3 }' |  grep  root",
    path    => $path,
    user    => 'root',
    group   => 'root',
    require => [Exec['Unpack JDK'],File[$java_home_dir]],
  }

  $alternatives = [ 'java', 'javac', 'javaws', 'keytool']

  fmw_jdk::utils::alternatives{ $alternatives:
    java_home_dir => $java_home_dir,
    priority      => 1,
    user          => 'root',
    group         => 'root',
    require       => [Exec['Unpack JDK'],File[$java_home_dir]],
  }
}