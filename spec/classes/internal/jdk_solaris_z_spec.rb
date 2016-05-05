require 'spec_helper'

describe 'fmw_jdk::internal::jdk_solaris_z', :type => :class do

  describe 'With attributes, tar.Z on Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11',
                   architecture:              'i86pc' }}
    let(:params){{
                  :java_home_dir       => '/usr/jdk/instances/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-solaris-i586.tar.Z',
                }}
    it  { should contain_file('/tmp/java').with(
            ensure: 'directory' ) }
    it  { should contain_file('/tmp/java/admin.rsp').with(
            source: 'puppet:///modules/fmw_jdk/solaris_admin.rsp' ).that_requires('File[/tmp/java]')
        }

    it  {
         should contain_exec('uncompress JDK SVR4 packages').with(
            command: 'zcat /software/jdk-7u75-solaris-i586.tar.Z|tar -xvpf -',
            creates: '/tmp/java/SUNWj7rt',
            cwd:     '/tmp/java'
          ).that_requires('File[/tmp/java]').that_requires('File[/tmp/java/admin.rsp]')
        }

    it  {
         should contain_exec('install JDK SVR4 packages').with(
            command: 'pkgadd -a /tmp/java/admin.rsp -d /tmp/java SUNWj7rt',
            creates: '/usr/jdk/instances/jdk1.7.0_XX'
          ).that_requires('Exec[uncompress JDK SVR4 packages]')
        }
  end

  describe 'With attributes, tar.Z 8 on Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11',
                   architecture:              'i86pc' }}
    let(:params){{
                  :java_home_dir       => '/usr/jdk/instances/jdk1.8.0_XX',
                  :source_file         => '/software/jdk-8u40-solaris-x64.tar.Z',
                }}
    it  { should contain_file('/tmp/java').with(
            ensure: 'directory' ) }
    it  { should contain_file('/tmp/java/admin.rsp').with(
            source: 'puppet:///modules/fmw_jdk/solaris_admin.rsp' ).that_requires('File[/tmp/java]')
        }

    it  {
         should contain_exec('uncompress JDK SVR4 packages').with(
            command: 'zcat /software/jdk-8u40-solaris-x64.tar.Z|tar -xvpf -',
            creates: '/tmp/java/SUNWj8rt',
            cwd:     '/tmp/java'
          ).that_requires('File[/tmp/java]').that_requires('File[/tmp/java/admin.rsp]')
        }

    it  {
         should contain_exec('install JDK SVR4 packages').with(
            command: 'pkgadd -a /tmp/java/admin.rsp -d /tmp/java SUNWj8rt',
            creates: '/usr/jdk/instances/jdk1.8.0_XX',
          ).that_requires('Exec[uncompress JDK SVR4 packages]')
        }

  end

  describe 'With attributes and extension, tar.Z on Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11',
                   architecture:              'i86pc' }}
    let(:params){{
                  :java_home_dir       => '/usr/jdk/instances/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-solaris-i586.tar.Z',
                  :source_x64_file     => '/software/jdk-7u75-solaris-x64.tar.Z'
                }}

    it  { should contain_file('/tmp/java').with(
            ensure: 'directory' ) }
    it  { should contain_file('/tmp/java/admin.rsp').with(
            source: 'puppet:///modules/fmw_jdk/solaris_admin.rsp' ).that_requires('File[/tmp/java]')
        }

    it  {
         should contain_exec('uncompress JDK SVR4 packages').with(
            command: 'zcat /software/jdk-7u75-solaris-i586.tar.Z|tar -xvpf -',
            creates: '/tmp/java/SUNWj7rt',
            cwd:     '/tmp/java'
          ).that_requires('File[/tmp/java]').that_requires('File[/tmp/java/admin.rsp]')
        }

    it  {
         should contain_exec('install JDK SVR4 packages').with(
            command: 'pkgadd -a /tmp/java/admin.rsp -d /tmp/java SUNWj7rt',
            creates: '/usr/jdk/instances/jdk1.7.0_XX'
          ).that_requires('Exec[uncompress JDK SVR4 packages]')
        }

    it  {
         should contain_exec('uncompress JDK x64 SVR4 packages').with(
            command: 'zcat /software/jdk-7u75-solaris-x64.tar.Z|tar -xvpf -',
            creates: '/tmp/java/SUNWj7rtx',
            cwd:     '/tmp/java'
          ).that_requires('Exec[install JDK SVR4 packages]')
        }

    it  {
         should contain_exec('install JDK x64 SVR4 packages').with(
            command: 'pkgadd -a /tmp/java/admin.rsp -d /tmp/java SUNWj7rtx',
            creates: '/usr/jdk/instances/jdk1.7.0_XX/bin/amd64'
          ).that_requires('Exec[uncompress JDK x64 SVR4 packages]')
        }

  end

end
