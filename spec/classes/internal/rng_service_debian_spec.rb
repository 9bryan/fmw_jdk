require 'spec_helper'

describe 'fmw_jdk::internal::rng_service_debian', :type => :class do

  describe 'on Debian platform' do
    let(:facts) {{  osfamily:                  'Debian' }}

    it  {
         should contain_exec('sed rng-tools').with(
            command: "sed -i -e's/#HRNGDEVICE=\\/dev\\/null/HRNGDEVICE=\\/dev\\/urandom/g' /etc/default/rng-tools",
            unless: "grep '^HRNGDEVICE=/dev/urandom' /etc/default/rng-tools",
          ).that_notifies('Service[rng-tools]')
        }
    it  {
         should contain_service('rng-tools').with(
            ensure: 'running',
            enable: true,
            hasstatus: false,
            pattern: '/usr/sbin/rngd',
          ).that_requires('Exec[sed rng-tools]')
        }
  end
end
