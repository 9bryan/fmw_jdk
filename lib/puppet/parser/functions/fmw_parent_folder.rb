# Puppet parser functions
module Puppet::Parser::Functions
  newfunction(:fmw_parent_folder, :type => :rvalue) do |args|
    directory = args[0].strip
    # replace for C: when tested on windows
    File.expand_path('..', directory).gsub('C:', '')
  end
end
