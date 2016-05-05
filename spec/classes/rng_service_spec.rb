require 'spec_helper'

describe 'fmw_jdk::rng_service' , :type => :class do

  describe "Windows" do
    let(:facts) {{ kernel: 'Windows',
                   operatingsystem: 'Windows'}}
    it do
      expect { should contain_package('rng-tools')
             }.to raise_error(Puppet::Error, /Unrecognized operating system, use this class on a Linux host/)
    end
  end

  describe "SunOS" do
    let(:facts) {{ kernel:          'SunOS',
                   operatingsystem: 'Solaris'}}
    it do
      expect { should contain_package('rng-tools')
             }.to raise_error(Puppet::Error, /Unrecognized operating system, use this class on a Linux host/)
    end
  end

  describe "CentOS" do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}

    describe "on operatingsystem CentOS" do
      it { should contain_package('rng-tools').with_ensure('present') }
      it do
        should contain_exec('sed rngd.service').with(
          path: '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
        ).that_requires('Package[rng-tools]').that_notifies('Service[rngd]')
      end
      it do
        should contain_service("rngd").with(
          ensure:   'running',
          enable:   true
        ).that_requires('Exec[sed rngd.service]')
      end
      it {
        should contain_exec("chkconfig rngd").with(
          command: "chkconfig --add rngd",
          unless: "chkconfig | /bin/grep 'rngd'",
          path: '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
        ).that_requires('Service[rngd]')
      }
    end

  end

  describe "CentOS 7" do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '7' }}

    describe "on operatingsystem CentOS" do
      it { should contain_package('rng-tools').with_ensure('present') }
      it {
        should contain_exec('sed rngd.service').with(
          path: '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
        ).that_requires('Package[rng-tools]')
      }
      it {
        should contain_exec('systemctl-daemon-reload').with(
          command: '/bin/systemctl --system daemon-reload',
          path: '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
          refreshonly: true,
        ).that_notifies('Service[rngd]').that_subscribes_to('Exec[sed rngd.service]')
      }
      it {
        should contain_service("rngd").with(
          ensure:   'running',
          enable:   true
        ).that_requires('Exec[systemctl-daemon-reload]')
      }

    end

  end

  ['Ubuntu','Debian'].each do |system|
    let(:facts) {{ operatingsystem: system,
                   kernel:          'Linux',
                   osfamily:        'Debian' }}
    describe "on operatingsystem #{system}" do
      it {
        should contain_exec('sed rng-tools').with(
          path: '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
        ).that_requires('Package[rng-tools]')
      }
      it {
        should contain_service("rng-tools").with(
          ensure:   'running',
          enable:   true
        ).that_requires('Exec[sed rng-tools]')
      }
    end
  end

end
