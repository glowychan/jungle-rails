require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    @params = { first_name: "Ronald", last_name: "McDonald", email: "ronald@mcdonalds.COM", password: "bigmac", password_confirmation: "bigmac" }
  end

  describe 'Validations' do
    it "should save valid parameters" do
      @user = User.new(@params)
      expect(@user.valid?).to be true
      @user.save
      expect(@user.errors.full_messages).to be_empty
    end

    it "should have a unique email" do
      @user1 = User.new(@params)
      @user1.save
      @user2 = User.new(@params)
      @user2.save
      expect(@user2.errors.full_messages).to include "Email already registered"
    end

    it "should have a unique email case insensitive" do
      @user1 = User.new(@params)
      @user1.save
      @params[:email] = "Ronald@MCDONALDS.com"
      @user2 = User.new(@params)
      @user2.save
      expect(@user2.errors.full_messages).to include "Email already registered"
    end

    it "must have an email" do
      @params[:email] = nil
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "Email must be entered"
    end

    it "must have a first name" do
      @params[:first_name] = nil
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "First name must be entered"
    end

    it "must have a last name" do
      @params[:last_name] = nil
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "Last name must be entered"
    end

    it "must have a password" do
      @params[:password] = nil
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "Password must be entered"
    end

    it "must confirm password" do
      @params[:password_confirmation] = nil
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "Password must be confirmed"
    end

    it "should match the password and password confirmation" do
      @params[:password_confirmation] = "different"
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "Password does not match password confirmation"
    end

    it "should have a password of at least 6 characters" do
      @params[:password] = "t"
      @params[:password_confirmation] = "t"
      @user = User.new(@params)
      @user.save
      expect(@user.errors.full_messages).to include "Password must be at least 6 characters long"
    end
  end

  describe 'authenticate_with_credentials' do

    it "should return correct user with matching email and password" do
      @user = User.new(@params)
      @user.save
      expect(User.authenticate_with_credentials(@params[:email], @params[:password])).to eq(@user)
    end

    it "should return correct user with matching email case insensitive and password" do
      @user = User.new(@params)
      @user.save
      expect(User.authenticate_with_credentials('Ronald@MCDONALDS.com', @params[:password])).to eq(@user)
    end

    it "should return nil when wrong email provided" do
      @user = User.new(@params)
      @user.save
      expect(User.authenticate_with_credentials(@params[:email], 'wrong')).to be_nil
    end

    it "should return nil when unregistered email and any password provided" do
      @user = User.new(@params)
      @user.save
      expect(User.authenticate_with_credentials('random_but_incorrect_email', @params[:password])).to be_nil
    end

  end
end
