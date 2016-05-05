require 'spec_helper'

describe 'fmw_jdk::utils::links', :type => :define do

  describe "Java RedHat" do
    let(:params){{:java_home_dir  => '/usr/java/jdk1.7.0_XX',
                }}
    let(:title) {'java'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}
    it  { should contain_file("/usr/bin/java").with(
                  target:   '/usr/java/jdk1.7.0_XX/bin/java'
                )
        }
  end

end
