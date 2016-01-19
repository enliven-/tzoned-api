require 'rails_helper'


class Authentication
  include Authenticable

  def request
  end

  def response
  end
end


RSpec.describe Authenticable do

  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_user' do
    before do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request) { request }
    end
    it 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end


  describe '#authenticate_with_token' do
    before do
      @user = FactoryGirl.create :user
      allow(authentication).to receive(:current_user) { nil }
      allow(response).to receive(:response_code) { 401 }
      allow(response).to receive(:body) { {'errors' => 'Not authenticated'}.to_json }
      allow(authentication).to receive(:response) { response }
    end

    it 'render a json error message' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors]).to eql 'Not authenticated'
    end

    it {  should respond_with 401 }
  end



  describe '#user_signed_in?' do
    context 'when there is a user on session' do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user) { @user }
      end

      it 'returns true for user_signed_in?' do
        expect(authentication.user_signed_in?).to be true
      end
    end

    context 'when there is no user on session' do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user) { nil }
      end

      it 'returns false for user_signed_in?' do
        expect(authentication.user_signed_in?).to be false
      end
    end
  end

end 
