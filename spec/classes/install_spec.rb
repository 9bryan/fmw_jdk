require 'spec_helper'

describe 'fmw_jdk::install' , :type => :class do

  describe 'When all attributes are default, on an unspecified platform' do

    it do
      expect { should contain_package('xxx')
             }.to raise_error(Puppet::Error, /Not supported Operation System, please use it on windows, linux or solaris host/)
    end
  end

  describe 'With attributes, on an unspecified platform' do
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                  :source_file         => '/software/jdk-8u40-linux-x64.rpm',
                }}
    it do
      expect { should contain_package('xxx')
             }.to raise_error(Puppet::Error, /Not supported Operation System, please use it on windows, linux or solaris host/)
    end
  end

  describe 'With attributes and extra source_x64_file, on a linux platform' do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-solaris-i586.tar.gz',
                  :source_x64_file     => '/software/jdk-7u75-solaris-x64.tar.gz',
                }}
    it do
      expect { should contain_package('xxx')
             }.to raise_error(Puppet::Error, /source_x64_file is only used in solaris for installing JDK x64 extension/)
    end
  end

  describe 'With attributes, rpm on CentOS platform' do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                  :source_file         => '/software/jdk-8u40-linux-x64.rpm'
                }}
    it  { should contain_fmw_jdk_linux_rpm('/usr/java/jdk1.8.0_XX').with(
                       ensure:          'present',
                       java_home_dir:   '/usr/java/jdk1.8.0_XX',
                       source_file:     '/software/jdk-8u40-linux-x64.rpm'
                      )
        }
  end

  describe 'With default attributes, on CentOS platform'  do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    it do
      expect { should contain_package('xxx')
             }.to raise_error(Puppet::Error, /java_home_dir parameter cannot be empty/)
    end
  end

  describe 'With java_home_dir attribute, on CentOS platform'  do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.8.0_XX'
                }}
    it do
      expect { should contain_package('xxx')
             }.to raise_error(Puppet::Error, /source_file parameter cannot be empty/)
    end
  end

  describe 'With attributes, tar.gz on CentOS platform' do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-linux-x64.tar.gz',
                }}
    it  { should contain_class('fmw_jdk::internal::jdk_linux').with(
                  java_home_dir:   '/usr/java/jdk1.7.0_XX',
                  source_file:     '/software/jdk-7u75-linux-x64.tar.gz'
                 )
        }
  end

  describe 'With attributes, on Windows platform' do
    let(:facts) {{ kernel:                    'windows', }}
    let(:params){{
                  :java_home_dir       => 'C:/java/jdk1.7.0_XX',
                  :source_file         => 'C:/software/jdk-7u75-windows-x64.exe',
                }}
    it  { should contain_class('fmw_jdk::internal::jdk_windows').with(
                  java_home_dir:   'C:/java/jdk1.7.0_XX',
                  source_file:     'C:/software/jdk-7u75-windows-x64.exe'
                 )
        }
  end

  describe 'With attributes and extra source_x64_file, on a Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'SunOS',
                   operatingsystemmajrelease: '5.11' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-solaris-i586.tar.gz',
                  :source_x64_file     => '/software/jdk-7u75-solaris-x64.tar.gz'
                }}
    it  { should contain_class('fmw_jdk::internal::jdk_solaris').with(
                  java_home_dir:   '/usr/java/jdk1.7.0_XX',
                  source_file:     '/software/jdk-7u75-solaris-i586.tar.gz',
                  source_x64_file: '/software/jdk-7u75-solaris-x64.tar.gz'
                 )
        }
  end

  describe 'With attributes, tar.Z, on a Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'SunOS',
                   operatingsystemmajrelease: '5.11' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                  :source_file         => '/software/jdk-8u40-solaris-x64.tar.Z',
                }}
    it  { should contain_class('fmw_jdk::internal::jdk_solaris_z').with(
                  java_home_dir:   '/usr/java/jdk1.8.0_XX',
                  source_file:     '/software/jdk-8u40-solaris-x64.tar.Z',
                 )
        }
  end

end
