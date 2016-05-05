# Puppet parser functions
module Puppet::Parser::Functions
  newfunction(:fmw_windows_folder, :type => :rvalue) do |args|
    directory = args[0].strip
    directory.gsub('/', '\\\\')
  end
end
