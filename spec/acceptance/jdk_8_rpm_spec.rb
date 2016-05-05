require 'spec_helper_acceptance'

describe 'jdk_8_rpm' do

  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'Should apply the manifest without error' do

    pp = <<-EOS

      if $::osfamily in ['RedHat'] {
        class { 'fmw_jdk::install':
          java_home_dir => '/usr/java/jdk1.8.0_45',
          source_file   => '/software/jdk-8u45-linux-x64.rpm',
        }
      }

    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    shell('sleep 15')
  end

  if ['redhat'].include?(os[:family])

    describe file('/usr/java/jdk1.8.0_45') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end

    describe file('/usr/java/jdk1.8.0_45/bin/java') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_executable }
    end

    describe file('/usr/bin/java') do
      it { should be_symlink }
      it { should be_linked_to '/etc/alternatives/java' }
    end
  end

end
