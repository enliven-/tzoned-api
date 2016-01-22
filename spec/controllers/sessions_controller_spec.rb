require 'rails_helper'

RSpec.describe SessionsController, type: :controller do



  describe 'POST #create' do

    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do

      before(:each) do
        credentials = { email: @user.email, password: 'mypassword' }
        post :create, { user: credentials }
      end

      it 'returns the user record corresponding to the given credentials' do
        @user.reload
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:user][:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do

      before(:each) do
        credentials = { email: @user.email, password: 'invalidpassword' }
        post :create, { user: credentials }
      end

      it 'returns a json with an error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { should respond_with 422 }
    end

  end



  describe 'DELETE #destroy' do

    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.auth_token }
    end

    it { should respond_with 204 }

  end


end
