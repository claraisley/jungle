require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

    before(:each) do
      @user = User.new(id: 1, first_name: "Carly", last_name: "Hunt", email: 'carly.hunt@outlook.ca', password: 'little123', password_confirmation: 'little123')
    end 

    it "is valid when all fields are filled" do
      expect(@user).to be_valid
    end
    it "is invalid without first_name" do
      @user.first_name = nil
      expect(@user).to_not be_valid
    end

    it "is invalid without last_name" do
      @user.last_name = nil
      expect(@user).to_not be_valid
    end
    it "is invalid without email" do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it "is invalid without password" do
      @user.password = nil
      expect(@user).to_not be_valid
    end

    it "is invalid with a password with a length less than 6 characters" do
      @user.password = "lit2"
      expect(@user).to_not be_valid
    end

    it "is invalid with case sensitive password" do
      @user.password = "aAbbA"
      expect(@user).to_not be_valid
    end
    it "only allows one email address to register" do
      @user.save
      @user1 = User.new(first_name: "Carly", last_name: "Hunt", email: @user.email, password: 'little123', password_confirmation: 'little123')
      @user1.save
      expect(@user1.errors.messages[:email][0]).to eq("has already been taken")
    end

    it "is invalid when user tries to sign up with case sensitive email" do
      @user.save
      @user1 = User.new(first_name: "Carly", last_name: "Hunt", email: 'CARLY.HUNT@outlook.ca', password: 'little123', password_confirmation: 'little123')
      @user1.save
      expect(@user1.errors.messages[:email][0]).to eq("has already been taken")
    end
  end

    describe '.authenticate_with_credentials' do
      before(:each) do
        @user = User.create(id: 1, first_name: "Carly", last_name: "Hunt", email: 'carly.hunt@outlook.ca', password: 'little123', password_confirmation: 'little123')
      end
  
      it "is valid with correct login information" do
        @email = "carly.hunt@outlook.ca"
        @password = "little123"
        @logged_user = User.authenticate_with_credentials(@email, @password)
        expect(@user[:email]).to eq(@logged_user[:email])
      end
  
      it "is valid with non case sensitive email" do
        @email = "CARLY.HUNT@outlook.ca"
        @password = "little123"
        @logged_user = User.authenticate_with_credentials(@email, @password)
        expect(@user[:email]).to eq(@logged_user[:email])
      end
  
      it "is valid with spaces in email field" do
        @email = "    carly.hunt@outlook.ca   "
        @password = "little123"
        @logged_user = User.authenticate_with_credentials(@email, @password)
        expect(@user[:email]).to eq(@logged_user[:email])
      end
  
      it "is not valid with incorrect password" do
        @email = "carly.hunt@outlook.ca"
        @password = "little"
        @logged_user = User.authenticate_with_credentials(@email, @password)
        expect(@logged_user).to eq(nil)
      end
  
      it "is not valid with incorrect email" do
        @email = "carlhunt@outlook.ca"
        @password = "little123"
        @logged_user = User.authenticate_with_credentials(@email, @password)
        expect(@logged_user).to eq(nil)
      end
    end
end