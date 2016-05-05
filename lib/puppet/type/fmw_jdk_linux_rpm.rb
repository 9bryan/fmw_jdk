#
# fmw_jdk_linux_rpm
#
# Copyright 2015 Oracle. All Rights Reserved
#
# Puppet module
module Puppet
  newtype(:fmw_jdk_linux_rpm) do
    desc 'Installs an Oracle JDK 7 or 8 rpm on a Linux host'

    newparam(:name) do
      desc <<-EOT
        The title.
      EOT
      isnamevar
    end

    newproperty(:ensure) do
      desc 'Whether to do something.'

      newvalue(:present) do
        provider.install
      end

      def retrieve
        source_file   = resource[:source_file]

        Puppet.debug "rpm -qp --queryformat '%{NAME} %{VERSION}-%{RELEASE}' #{source_file}"
        output = Puppet::Util::Execution.execute "rpm -qp --queryformat '%{NAME} %{VERSION}-%{RELEASE}' #{source_file}"
        Puppet.debug "fmw_jdk_linux_rpm rpm query result: #{output}"
        output.each_line do |line|
          case line
          when /^([\w\d+_.-]+)\s([\w\d_.-]+)$/
            @package_name = $1
          end
        end
        Puppet.debug "rpm -q --queryformat '%{NAME} %{VERSION}-%{RELEASE}' #{@package_name}"
        rpm_status =  Puppet::Util::Execution.execute "rpm -q --queryformat '%{NAME} %{VERSION}-%{RELEASE}' #{@package_name}", :failonfail => false
        Puppet.info "fmw_jdk_linux_rpm rpm status result: #{rpm_status}"

        if rpm_status.include? "package #{@package_name} is not installed"
          :absent
        else
          :present
        end
      end
    end

    newparam(:java_home_dir) do
      desc <<-EOT
        Java home folder, this is the folder where the jdk will be installed.
      EOT
      validate do |value|
        fail ArgumentError, 'java_home_dir cannot be empty' if value.nil?
      end
    end

    newparam(:source_file) do
      desc <<-EOT
        Linux JDK source file, it should be a file with .rpm as extension.
      EOT
      validate do |value|
        fail ArgumentError, 'source_file cannot be empty' if value.nil?
      end
    end
  end
end
