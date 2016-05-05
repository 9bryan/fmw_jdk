require 'spec_helper'

describe 'fmw_jdk::utils::alternatives', :type => :define do

  describe "Java RedHat" do
    let(:params){{:java_home_dir  => '/usr/java/jdk1.7.0_XX',
                  :priority       => 2,
                  :user           => 'root',
                  :group          => 'root',
                }}
    let(:title) {'java'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}
    it  { should contain_exec("java alternatives java").with(
                  command:   "alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_XX/bin/java 2",
                  unless:    "alternatives --display java | /bin/grep /usr/java/jdk1.7.0_XX | /bin/grep 'priority 2$'",
                  user:      'root',
                  group:     'root',
                )
        }
  end

  describe "Java Debian" do
    let(:params){{:java_home_dir  => '/usr/java/jdk1.7.0_XX',
                  :priority       => 2,
                  :user           => 'root',
                  :group          => 'root',
                }}
    let(:title) {'java'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'Debian',
                   :osfamily        => 'Debian' }}
    it  { should contain_exec("java alternatives java").with(
                  command:   "update-alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_XX/bin/java 2",
                  unless:    "update-alternatives --display java | /bin/grep /usr/java/jdk1.7.0_XX | /bin/grep 'priority 2$'",
                  user:      'root',
                  group:     'root',
                )
        }
  end


end
