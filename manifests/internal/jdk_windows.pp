#
# fmw_jdk::internal::jdk_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::internal::jdk_windows(
  $java_home_dir = undef,
  $source_file   = undef,
)
{
  $path = 'C:\\Windows\\system32;C:\\Windows'

  $java_home_parent_dir = fmw_parent_folder($java_home_dir)

  file { $java_home_parent_dir:
    ensure => directory,
  }

  $java_home_dir_windows = fmw_windows_folder($java_home_dir)

  exec { 'Install JDK':
    command => "C:\\Windows\\System32\\cmd.exe /c ${source_file}  /s ADDLOCAL=\"ToolsFeature\" INSTALLDIR=${java_home_dir_windows}",
    path    => $path,
    creates => $java_home_dir,
    require => File[$java_home_parent_dir],
  }

}