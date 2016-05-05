require 'spec_helper'
describe 'fmw_jdk' do

  context 'with defaults for all parameters' do
    it { should contain_class('fmw_jdk') }
  end
end
