require 'spec_helper_acceptance'

describe 'rng_service' do

  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'Should apply the manifest without error' do
    pp = <<-EOS
      if $::kernel == 'Linux' {
        unless ( $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '5') {
          include fmw_jdk::rng_service
        }
      }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    shell('sleep 15')
  end

  if ['redhat'].include?(os[:family]) and os[:release] >= '6.0'

    describe service('rngd') do
      it { should be_enabled }
      it { should be_running }
    end

  elsif ['debian'].include?(os[:family])

    describe service('rng-tools') do
      it { should be_enabled }
    end

    describe service('rngd') do
      it { should be_running }
    end

  end

end
