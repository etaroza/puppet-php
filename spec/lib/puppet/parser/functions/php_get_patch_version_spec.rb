require 'spec_helper'

describe "the php_get_patch_version function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  it "should exist" do
    Puppet::Parser::Functions.function("php_get_patch_version").should == "function_php_get_patch_version"
  end

  it "should return 5.6.9 when passed 5" do
    result = scope.function_php_get_patch_version(['5'])
    result.should(eq('5.6.9'))
  end

  it "should return 5.6.9 when passed 5.6" do
    result = scope.function_php_get_patch_version(['5.6'])
    result.should(eq('5.6.9'))
  end

  it "should return 5.5.25 when passed 5.5" do
    result = scope.function_php_get_patch_version(['5.5'])
    result.should(eq('5.5.25'))
  end

  it "should return 5.4.41 when passed 5.4" do
    result = scope.function_php_get_patch_version(['5.4'])
    result.should(eq('5.4.41'))
  end

  it "should return 5.6.15 when passed 5.6.15" do
    result = scope.function_php_get_patch_version(['5.6.15'])
    result.should(eq('5.6.15'))
  end

  it "should return 'system' when passed 'system'" do
    result = scope.function_php_get_patch_version(['system'])
    result.should(eq('system'))
  end
end
