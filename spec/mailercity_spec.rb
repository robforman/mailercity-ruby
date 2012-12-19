require "spec_helper"
require_relative "../lib/mailercity"

Mailercity.api_base = "http://testhost"
Mailercity.api_key = "testkey"

describe Mailercity do
  def stub_post(url, status, *args)
    payload = {:args => args}
    body = payload.to_json
    api_key = Mailercity.api_key
    stub_request(:post, url).
      with(:body => body, :headers => {'X-Api-Key' => api_key, 'Content-Type' => 'application/json'}).
      to_return(:status => status, :body => "", :headers => {})
  end

  let(:user) { {"id"=>1, "email"=>"rob@robforman.com", "first_name"=>"Rob", "last_name"=>"Forman"} }
  let(:account) { {"id"=>1, "name"=>"Awesometown"} }

  before(:each) do
    Mailercity.perform_deliveries = true
  end

  it "can create dynamic mailer classes and template methods while passing appropriate parameters" do
    mail = Mailercity::MyTestMailer.my_test_template(user)
    mail.should be_kind_of Mailercity::Message
  end

  describe ".deliver" do
    context "without http error" do
      it "should post and return true" do
        stub = stub_post("http://testhost/my_test_mailer/my_test_template", 201, user)
        Mailercity::MyTestMailer.my_test_template(user).deliver.should == true
      end

      it "should send values in order" do
        stub = stub_post("http://testhost/my_test_mailer/my_test_template", 201, user, account)
        Mailercity::MyTestMailer.my_test_template(user, account).deliver.should == true
      end
    end

    context "with http error" do
      it "should fail to post and return false" do
        stub = stub_post("http://testhost/my_test_mailer/my_test_template", 403, user)
        Mailercity::MyTestMailer.my_test_template(user).deliver.should == false
      end
    end

    context "with deliveries disabled" do
      it "should not even try to send a request but just return true" do
        Mailercity.perform_deliveries = false
        Mailercity::MyTestMailer.my_test_template(user).deliver.should == true
      end
    end
  end
end