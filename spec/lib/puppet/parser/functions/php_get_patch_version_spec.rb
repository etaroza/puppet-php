require 'spec_helper'

describe 'php_get_patch_version', :type => :puppet_function do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  it "should exist" do
    Puppet::Parser::Functions.function("php_get_patch_version").should == "function_php_get_patch_version"
  end

  it do
    should run.with_params('7').and_return('7.0.11')
    should run.with_params('7.0').and_return('7.0.11')
    should run.with_params('7.0.2').and_return('7.0.2')
    should run.with_params('5').and_return('5.6.26')
    should run.with_params('5.6').and_return('5.6.26')
    should run.with_params('5.5').and_return('5.5.38')
    should run.with_params('5.6.15').and_return('5.6.15')
    should run.with_params('system').and_return('system')
  end
end
