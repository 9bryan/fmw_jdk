require 'spec_helper'

describe 'fmw_jdk::internal::jdk_linux', :type => :class do

  describe 'With attributes, tar.gz on CentOS platform' do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                  :source_file         => '/software/jdk-7u75-linux-x64.tar.gz',
                }}
    it  { should contain_file('/usr/java').with( ensure: 'directory' ) }
    it  {
         should contain_exec('Unpack JDK').with(
            command: 'tar xzvf /software/jdk-7u75-linux-x64.tar.gz --directory /usr/java',
            creates: '/usr/java/jdk1.7.0_XX',
          ).that_requires('File[/usr/java]')
        }
    it  { should contain_file('/usr/java/jdk1.7.0_XX').with( ensure: 'directory' ) }
    it  {
         should contain_exec('chown -R root:root /usr/java/jdk1.7.0_XX').with(
            unless: "ls -al /usr/java/jdk1.7.0_XX/bin/java | awk ' { print \$3 }' |  grep  root"
          ).that_requires('File[/usr/java/jdk1.7.0_XX]').that_requires('Exec[Unpack JDK]')
        }
    it  { should contain_fmw_jdk__utils__alternatives('java', 'javac', 'javaws', 'keytool') }
  end
end
