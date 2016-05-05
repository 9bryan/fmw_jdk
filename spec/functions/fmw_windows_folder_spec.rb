require 'spec_helper'

describe 'fmw_windows_folder', :type => :puppet_function do
  it { should run.with_params('C:/java/jdk').and_return('C:\\java\\jdk') }
end