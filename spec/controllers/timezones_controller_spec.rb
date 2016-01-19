require 'rails_helper'

RSpec.describe TimezonesController, type: :controller do


  describe 'GET #index' do
    before(:each) do
      user = FactoryGirl.create(:user)
      request.headers['Authorization'] =  user.auth_token
      FactoryGirl.create :timezone, user: user
      get :index, { user_id: user.id }
    end

    it 'returns records from the database as json array' do
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response).to be_a Array
    end

    it { should respond_with 200 }
  end


  describe 'GET #show' do
    before(:each) do
      user = FactoryGirl.create(:user)
      @timezone = FactoryGirl.create(:timezone, user: user)
      request.headers['Authorization'] =  user.auth_token

      get :show, { user_id: user.id, id: @timezone.id }
    end

    it 'returns the information about timezone as a hash' do
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:name]).to eql @timezone.name
    end

    it { should respond_with 200 }
  end



  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        user = FactoryGirl.create(:user)
        @timezone_attributes = FactoryGirl.attributes_for :timezone
        request.headers['Authorization'] =  user.auth_token
        post :create, { user_id: user.id, timezone: @timezone_attributes }
      end

      it 'renders the json representation for the timezone record just created' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:name]).to eql @timezone_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_timezone_attributes = { gmt_difference: 9000 } # name not present
        request.headers['Authorization'] =  user.auth_token
        post :create, { user_id: user.id, timezone: @invalid_timezone_attributes }
      end

      it 'renders an errors json' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on when the timezone could not be created' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end



  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] =  @user.auth_token
      @timezone = FactoryGirl.create :timezone, user: @user
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { user_id: @user.id, id: @timezone.id,
              timezone: { name: 'CT' } }
      end

      it 'renders the json representation for the updated timezone' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:name]).to eql 'CT'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { user_id: @user.id, id: @timezone.id,
              timezone: { gmt_difference: 'two hundred' } }
      end

      it 'renders an errors json' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:errors][:gmt_difference]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end



  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] =  @user.auth_token
      @timezone = FactoryGirl.create :timezone, user: @user
      delete :destroy, { user_id: @user.id, id: @timezone.id }
    end

    it { should respond_with 204 }
  end


end
