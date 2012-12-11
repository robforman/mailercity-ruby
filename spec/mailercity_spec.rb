require "spec_helper"
require_relative "../lib/mailercity"

Mailercity.api_base = "http://testhost"
Mailercity.api_key = "testkey"

describe Mailercity do
  def stub_post(url, params, options={})
    status = options.fetch(:status, 200)
    api_key = options.fetch(:api_key, Mailercity.api_key)
    stub_request(:post, url).with(:body => params, :headers => {'X-Api-Key' => api_key}).to_return(:status => status, :body => "", :headers => {})
  end

  it "can create dynamic mailer classes and template methods while passing appropriate parameters" do
    mail = Mailercity::MyTestMailer.my_test_template(:user_email => "rob@robforman.com")
    mail.should be_kind_of Mailercity::Message
  end

  describe ".deliver" do
    context "without http error" do
      it "should post and return true" do
        stub = stub_post("http://testhost/my_test_mailer/my_test_template", {"user_email"=>"rob@robforman.com"})
        Mailercity::MyTestMailer.my_test_template(:user_email => "rob@robforman.com").deliver.should == true
      end
    end

    context "with http error" do
      it "should fail to post and return false" do
        stub = stub_post("http://testhost/my_test_mailer/my_test_template", {"user_email"=>"rob@robforman.com"}, :status => 403)
        Mailercity::MyTestMailer.my_test_template(:user_email => "rob@robforman.com").deliver.should == false
      end
    end
  end
end