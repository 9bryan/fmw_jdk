require 'spec_helper'

describe 'fmw_parent_folder', :type => :puppet_function do
  it { should run.with_params('/usr/java/jdk').and_return('/usr/java') }
  it { should run.with_params('C:/java/jdk1.7.0_XX').and_return('/Java') }

end