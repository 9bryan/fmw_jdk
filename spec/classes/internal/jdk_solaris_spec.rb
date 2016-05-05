require 'spec_helper'

describe 'fmw_jdk::internal::jdk_solaris', :type => :class do

  describe 'With attributes, tar.gz on Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11' }}
    let(:params){{
                  :java_home_dir       => '/usr/jdk/instances/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-solaris-i586.tar.gz',
                }}
    it  { should contain_file('/usr/jdk/instances').with( ensure: 'directory' ) }

    it  {
         should contain_exec('uncompress JDK').with(
            command: 'gzip -dc /software/jdk-7u75-solaris-i586.tar.gz | tar xf -',
            creates: '/usr/jdk/instances/jdk1.7.0_XX',
            cwd:     '/usr/jdk/instances'
          ).that_requires('File[/usr/jdk/instances]')
        }

    it  {
          should contain_exec('chown -R root:bin /usr/jdk/instances/jdk1.7.0_XX').that_requires('Exec[uncompress JDK]').with(
            unless: "ls -al /usr/jdk/instances/jdk1.7.0_XX/bin/java | awk ' { print \$3 }' |  grep  root"
          )
        }

    it  { should contain_fmw_jdk__utils__links('java', 'javac', 'javaws', 'keytool').that_requires('Exec[chown -R root:bin /usr/jdk/instances/jdk1.7.0_XX]') 
        }
  end

  describe 'With attributes and extension, tar.gz on Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11',
                   architecture:              'i86pc' }}
    let(:params){{
                  :java_home_dir       => '/usr/jdk/instances/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-solaris-i586.tar.gz',
                  :source_x64_file     => '/software/jdk-7u75-solaris-x64.tar.gz'
                }}
    it  { should contain_file('/usr/jdk/instances').with( ensure: 'directory' ) }

    it  {
         should contain_exec('uncompress JDK').with(
            command: 'gzip -dc /software/jdk-7u75-solaris-i586.tar.gz | tar xf -',
            creates: '/usr/jdk/instances/jdk1.7.0_XX',
            cwd:     '/usr/jdk/instances'
          ).that_requires('File[/usr/jdk/instances]')
        }

    it  {
         should contain_exec('uncompress JDK x64 extensions').with(
            command: 'gzip -dc /software/jdk-7u75-solaris-x64.tar.gz | tar xf -',
            creates: '/usr/jdk/instances/jdk1.7.0_XX/bin/amd64',
            cwd:     '/usr/jdk/instances'
          ).that_requires('Exec[uncompress JDK]').that_comes_before('Exec[chown -R root:bin /usr/jdk/instances/jdk1.7.0_XX]')
        }

    it  {
          should contain_exec('chown -R root:bin /usr/jdk/instances/jdk1.7.0_XX').that_requires('Exec[uncompress JDK]').with(
            unless: "ls -al /usr/jdk/instances/jdk1.7.0_XX/bin/java | awk ' { print \$3 }' |  grep  root"
          )
        }

    it  { should contain_fmw_jdk__utils__links('java', 'javac', 'javaws', 'keytool').that_requires('Exec[chown -R root:bin /usr/jdk/instances/jdk1.7.0_XX]') 
        }
  end

end
