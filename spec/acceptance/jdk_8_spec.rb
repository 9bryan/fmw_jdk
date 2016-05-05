require 'spec_helper_acceptance'

describe 'jdk_8' do

  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'Should apply the manifest without error' do
    pp = <<-EOS
      if $::kernel == 'Linux' {
        class { 'fmw_jdk::install':
          java_home_dir => '/usr/java/jdk1.8.0_40',
          source_file   => '/software/jdk-8u40-linux-x64.tar.gz',
        }
      } elsif $::kernel == 'SunOS' {
        class { 'fmw_jdk::install':
          java_home_dir => '/usr/jdk/instances/jdk1.8.0_40',
          source_file   => '/software/jdk-8u40-solaris-x64.tar.gz',
        }
      }

    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    shell('sleep 15')
  end

  if ['debian', 'redhat'].include?(os[:family])

    describe file('/usr/java/jdk1.8.0_40') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end

    describe file('/usr/java/jdk1.8.0_40/bin/java') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_executable }
    end

    describe file('/usr/bin/java') do
      it { should be_symlink }
      it { should be_linked_to '/etc/alternatives/java' }
    end
  elsif ['solaris'].include?(os[:family])

    describe file('/usr/jdk/instances/jdk1.8.0_40') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end

    describe file('/usr/jdk/instances/jdk1.8.0_40/bin/java') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_executable }
    end

    describe file('/usr/bin/java') do
      it { should be_symlink }
      it { should be_linked_to '/usr/jdk/instances/jdk1.8.0_40/bin/java' }
    end

  end

end
