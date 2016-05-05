#
# fmw_jdk_linux_rpm
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_jdk_linux_rpm).provide(:fmw_jdk_linux_rpm) do
  def install
    name          = resource[:name]
    source_file   = resource[:source_file]

    Puppet.info "instal Java RPM for #{name}"
    rpm_status =  Puppet::Util::Execution.execute "rpm -i #{source_file}", :failonfail => true
    Puppet.info "fmw_jdk_linux_rpm rpm install result: #{rpm_status}"
  end
end
