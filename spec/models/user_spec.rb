require 'spec_helper'

describe User do
  it "validates the length of the login" do
    user = User.new(login: 'x', password: 'pie', email: 'hello@balls.com')
    expect(user).to_not be_valid
    user = User.new(login: 'xsdfjhdsjkfhdsjhfdksjfkdjsf', password: 'pie', email: 'hello@balls.com')
    expect(user).to_not be_valid
    user = User.new(login: 'xsdfj', password: 'pie', email: 'hello@balls.com')
    expect(user).to be_valid
  end

  describe "#password=" do
    it "encrypts the password automatically" do
      BCrypt::Password.should_receive(:create).with("your mom").and_call_original
      user = User.new
      user.password = "your mom"
      expect(user.password.length).to be > 20
    end
  end

  describe ".authenticate" do
    before do
      User.create!(login: 'maus', password: 'foobar', email: 'honk@bonk.com')
    end

     it "returns nil if user doesnt exist" do
	user = User.authenticate( 'nomaus', 'badpassword' )
	expect(user).to be_nil 
     end

     it "returns nil if valid user bad password" do
	user = User.authenticate( 'maus', 'badpassword' )
	expect(user).to be_nil
     end

     it "returns user if valid user and password" do
	user = User.authenticate( 'maus', 'foobar' )
	expect(user).to be_a_kind_of User
     end

  end

end
