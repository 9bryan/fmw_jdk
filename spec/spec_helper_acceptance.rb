require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

UNSUPPORTED_PLATFORMS = [ 'Windows', 'AIX' ]

RSpec.configure do |c|
  project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    puppet_module_install(:source => project_root, :module_name => 'fmw_jdk')
    hosts.each do |host|
      if host['platform'] =~ /solaris/
        puppet_module_install(:source => "#{project_root}/../stdlib", :module_name => 'stdlib')
        on(default, 'mkdir -p /usr/jdk')
      else
        on host, puppet('module', 'install', 'puppetlabs-stdlib', '--force', '--version', '3.2.0'), :acceptable_exit_codes => [0, 1]
      end
      on(default, 'mkdir /software')
      scp_to(default, "#{ENV['SOFTWARE_FOLDER']}/jdk-8u40-linux-x64.tar.gz", '/software')
      scp_to(default, "#{ENV['SOFTWARE_FOLDER']}/jdk-7u75-linux-x64.tar.gz", '/software')
      scp_to(default, "#{ENV['SOFTWARE_FOLDER']}/jdk-8u45-linux-x64.rpm", '/software')
      scp_to(default, "#{ENV['SOFTWARE_FOLDER']}/jdk-7u75-solaris-i586.tar.gz", '/software')
      scp_to(default, "#{ENV['SOFTWARE_FOLDER']}/jdk-7u75-solaris-x64.tar.gz", '/software')
      scp_to(default, "#{ENV['SOFTWARE_FOLDER']}/jdk-8u40-solaris-x64.tar.gz", '/software')
    end
  end
end
