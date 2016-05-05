require 'spec_helper'

describe 'fmw_jdk::internal::jdk_windows', :type => :class do

  describe 'With attributes, tar.gz on CentOS platform' do
    let(:facts) {{ operatingsystem:           'windows',
                   kernel:                    'windows',
                   osfamily:                  'windows'}}
    let(:params){{
                  :java_home_dir       => 'C:/java/jdk1.7.0_XX',
                  :source_file         => 'C:/software/jdk-7u75-windows-x64.exe',
                }}

    it  { should contain_file('/Java').with( ensure: 'directory' ) }
    it  {
         should contain_exec('Install JDK').with(
            command: "C:\\Windows\\System32\\cmd.exe /c C:/software/jdk-7u75-windows-x64.exe  /s ADDLOCAL=\"ToolsFeature\" INSTALLDIR=C:\\java\\jdk1.7.0_XX",
            creates: 'C:/java/jdk1.7.0_XX',
          ).that_requires('File[/Java]')
        }

  end
end
