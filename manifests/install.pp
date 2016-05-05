#
# fmw_jdk::install
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_jdk::install(
  $java_home_dir   = undef,
  $source_file     = undef,
  $source_x64_file = undef,
) {
  unless $::kernel in ['windows', 'Linux', 'SunOS'] {
    fail('Not supported Operation System, please use it on windows, linux or solaris host')
  }
  if ( $java_home_dir == undef or is_string($java_home_dir) == false ) {
    fail('java_home_dir parameter cannot be empty')
  }
  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }
  if ( $source_x64_file != undef and $::kernel != 'SunOS' ) {
    fail('source_x64_file is only used in solaris for installing JDK x64 extension')
  }

  if $::kernel == 'Linux' {
    if 'rpm' in $source_file {
      unless $::osfamily in ['RedHat'] {
        fail('please use the rpm source_file on rhel linux family OS')
      }
      fmw_jdk_linux_rpm{ $java_home_dir:
        ensure        => 'present',
        java_home_dir => $java_home_dir,
        source_file   => $source_file,
      }
    } elsif 'tar.gz' in $source_file {
      class{'fmw_jdk::internal::jdk_linux':
        java_home_dir => $java_home_dir,
        source_file   => $source_file,
      }
      contain fmw_jdk::internal::jdk_linux
    } else {
      fail('Unknown source_file extension for linux, please use a rpm or tar.gz file')
    }
  } elsif $::kernel == 'SunOS' {
    if 'tar.Z' in $source_file {
      class{'fmw_jdk::internal::jdk_solaris_z':
        java_home_dir   => $java_home_dir,
        source_file     => $source_file,
        source_x64_file => $source_x64_file,
      }
      contain fmw_jdk::internal::jdk_solaris_z
    } elsif 'tar.gz' in $source_file {
      class{'fmw_jdk::internal::jdk_solaris':
        java_home_dir   => $java_home_dir,
        source_file     => $source_file,
        source_x64_file => $source_x64_file,
      }
      contain fmw_jdk::internal::jdk_solaris
    } else {
      fail('Unknown source_file extension for solaris, please use a tar.gz or tar.Z SVR4 file')
    }
  } elsif $::kernel == 'windows' {
    if 'exe' in $source_file {
      class{'fmw_jdk::internal::jdk_windows':
        java_home_dir => $java_home_dir,
        source_file   => $source_file,
      }
      contain fmw_jdk::internal::jdk_windows
    } else {
      fail('Unknown source_file extension for windows, please use a exe file')
    }
  }
}