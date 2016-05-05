#
# fmw_jdk::internal::jdk_solaris
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::internal::jdk_solaris(
  $java_home_dir   = undef,
  $source_file     = undef,
  $source_x64_file = undef,
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  $java_home_parent_dir = fmw_parent_folder($java_home_dir)

  file { $java_home_parent_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'bin',
    mode   => '0775',
  }

  exec { 'uncompress JDK':
    command => "gzip -dc ${source_file} | tar xf -",
    path    => $path,
    user    => 'root',
    creates => $java_home_dir,
    cwd     => $java_home_parent_dir,
    require => File[$java_home_parent_dir],
  }

  if ( $::architecture == 'i86pc' ) {
    $ext = 'amd64'
  } else {
    $ext = 'sparcv9'
  }

  if ( $source_x64_file != undef ) {
    exec { 'uncompress JDK x64 extensions':
      command => "gzip -dc ${source_x64_file} | tar xf -",
      path    => $path,
      user    => 'root',
      creates => "${java_home_dir}/bin/${ext}",
      cwd     => $java_home_parent_dir,
      require => Exec['uncompress JDK'],
      before  => Exec["chown -R root:bin ${java_home_dir}"],
    }
  }

  exec { "chown -R root:bin ${java_home_dir}":
    unless  => "ls -al ${java_home_dir}/bin/java | awk ' { print \$3 }' |  grep  root",
    path    => $path,
    user    => 'root',
    group   => 'bin',
    require => Exec['uncompress JDK'],
  }

  fmw_jdk::utils::links{ [ 'java', 'javac', 'javaws', 'keytool']:
    java_home_dir => $java_home_dir,
    require       => Exec["chown -R root:bin ${java_home_dir}"],
  }
}
