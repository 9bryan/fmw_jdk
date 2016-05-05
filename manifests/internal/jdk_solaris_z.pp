#
# fmw_jdk::internal::jdk_solaris_z
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::internal::jdk_solaris_z(
  $java_home_dir   = undef,
  $source_file     = undef,
  $source_x64_file = undef,
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  if 'jdk-8' in $source_file {
    $package_name     = 'SUNWj8rt'
    $package_x64_name = ''
  } else {
    $package_name     = 'SUNWj7rt'
    $package_x64_name = 'SUNWj7rtx'
  }

  if ( $::architecture == 'i86pc' ) {
    $ext = 'amd64'
  } else {
    $ext = 'sparcv9'
  }

  file {'/tmp/java':
    ensure => directory,
    mode   => '0775',
    owner  => 'root',
    group  => 'bin',
  }

  file { '/tmp/java/admin.rsp':
    ensure  => present,
    source  => 'puppet:///modules/fmw_jdk/solaris_admin.rsp',
    owner   => 'root',
    group   => 'bin',
    mode    => '0775',
    require => File['/tmp/java'],
  }

  exec { 'uncompress JDK SVR4 packages':
    command => "zcat ${source_file}|tar -xvpf -",
    path    => $path,
    user    => 'root',
    group   => 'bin',
    cwd     => '/tmp/java',
    creates => "/tmp/java/${package_name}",
    require => File['/tmp/java', '/tmp/java/admin.rsp'],
  }

  exec { 'install JDK SVR4 packages':
    command => "pkgadd -a /tmp/java/admin.rsp -d /tmp/java ${package_name}",
    path    => $path,
    user    => 'root',
    group   => 'bin',
    creates => $java_home_dir,
    require => Exec['uncompress JDK SVR4 packages'],
  }

  if ( $source_x64_file != undef ) {
    exec { 'uncompress JDK x64 SVR4 packages':
      command => "zcat ${source_x64_file}|tar -xvpf -",
      path    => $path,
      user    => 'root',
      creates => "/tmp/java/${package_x64_name}",
      cwd     => '/tmp/java',
      require => Exec['install JDK SVR4 packages'],
    }
    exec { 'install JDK x64 SVR4 packages':
      command => "pkgadd -a /tmp/java/admin.rsp -d /tmp/java ${package_x64_name}",
      path    => $path,
      user    => 'root',
      group   => 'bin',
      creates => "${java_home_dir}/bin/${ext}",
      require => Exec['uncompress JDK x64 SVR4 packages'],
    }
  }
}
