require 'spec_helper'

describe 'fmw_jdk::internal::rng_service_redhat', :type => :class do

  describe 'on RedHat 7 platform' do
    let(:facts) {{  osfamily:                  'RedHat',
                    operatingsystemmajrelease: '7' }}

    it  {
         should contain_exec('sed rngd.service').with(
           command: "sed -i -e's/ExecStart=\\/sbin\\/rngd -f/ExecStart=\\/sbin\\/rngd -r \\/dev\\/urandom -o \\/dev\\/random -f/g' /lib/systemd/system/rngd.service",
           unless:  "grep 'ExecStart=/sbin/rngd -r /dev/urandom -o /dev/random -f' /lib/systemd/system/rngd.service",
          )
        }
    it  {
         should contain_exec('systemctl-daemon-reload').with(
           command: '/bin/systemctl --system daemon-reload',
           refreshonly: true,
          ).that_notifies('Service[rngd]').that_subscribes_to('Exec[sed rngd.service]')
        }
    it  {
         should contain_service('rngd').with(
            ensure: 'running',
            enable: true,
          ).that_requires('Exec[systemctl-daemon-reload]')
        }
  end

  describe 'on RedHat platform' do
    let(:facts) {{  osfamily:                  'RedHat',
                    operatingsystemmajrelease: '6' }}

    it  {
         should contain_exec('sed rngd.service').with(
           command: "sed -i -e's/EXTRAOPTIONS=\"\"/EXTRAOPTIONS=\"-r \\/dev\\/urandom -o \\/dev\\/random -b\"/g' /etc/sysconfig/rngd",
           unless:  "grep '^EXTRAOPTIONS=\"-r /dev/urandom -o /dev/random -b\"' /etc/sysconfig/rngd",
          ).that_notifies('Service[rngd]')
        }
    it  {
         should contain_service('rngd').with(
            ensure: 'running',
            enable: true,
          ).that_requires('Exec[sed rngd.service]')
        }
    it  {
         should contain_exec('chkconfig rngd').with(
           command: 'chkconfig --add rngd',
           unless: "chkconfig | /bin/grep 'rngd'",
          ).that_requires('Service[rngd]')
        }
  end

end
