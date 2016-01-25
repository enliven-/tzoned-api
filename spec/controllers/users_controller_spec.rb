require 'rails_helper'


RSpec.describe UsersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.

  let(:user)    { FactoryGirl.create(:user) }
  let(:manager) { FactoryGirl.create(:manager) }
  let(:admin)   { FactoryGirl.create(:admin) }
  
  let(:valid_attributes)   { FactoryGirl.attributes_for(:user) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_user) }

  let(:valid_session) { {} }

  def set_http_header!(user)
    request.headers['Authorization'] = user.auth_token
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end




  describe 'GET #index' do
    it 'is forbidden for regular user' do
      set_http_header!(user)
      get :index, {}, valid_session

      expect(response).to have_http_status(:forbidden)
    end

    it 'is accessible to manager' do
      set_http_header!(manager)
      get :index, {}, valid_session

      expect(response).to have_http_status(200)
    end

    it 'is accessible to admin' do
      set_http_header!(admin)
      get :index, {}, valid_session

      expect(response).to have_http_status(200)
    end

    it 'returns users (except self) as array' do
      set_http_header!(manager)
      user  = FactoryGirl.create(:user)
      admin = FactoryGirl.create(:admin)
      get :index, {}, valid_session


      expect(json_response[:users].length).to eq(2)

      expect(json_response[:users].first[:email]).to  eq(user.email)
      expect(json_response[:users].second[:email]).to eq(admin.email)
    end
  end



  describe 'GET #show' do

    it 'it is only accessible to manager and admin; but not user' do
      set_http_header!(user)
      get :show, {:id => manager.id}, valid_session

      expect(response).to have_http_status(:forbidden)
    end

    it 'gets user response as a hash' do
      set_http_header!(manager)
      get :show, {:id => user.id}, valid_session
      expect(assigns(:user)).to eq(user)

      set_http_header!(admin)
      get :show, {:id => user.id}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end


  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        valid_attributes[:role] = :regular
        expect {
          post :create, {:user => valid_attributes}, valid_session
        }.to change(User, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user as @user' do
        post :create, {:user => invalid_attributes}, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end



  describe 'PUT #update' do
    context 'with valid params' do

      let(:new_attributes) { {email: 'someone@else.com'} }

      it 'updates the requested user' do
        set_http_header!(manager)
        put :update, {:id => user.id, :user => new_attributes}, valid_session
        user.reload
        expect(user.email).to eq('someone@else.com')
      end

      it 'assigns the requested user as @user' do
        set_http_header!(manager)
        put :update, {:id => user.id, :user => valid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it 'is forbidden to regular user' do
        second_user = FactoryGirl.create(:user)
        set_http_header!(user)
        put :update, {:id => second_user.id, :user => valid_attributes}, valid_session
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid params' do
      it 'assigns the user as @user' do
        set_http_header!(manager)
        put :update, {:id => user.id, :user => invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = FactoryGirl.create(:user)
      set_http_header!(manager)
      expect {
        delete :destroy, {:id => user.id}, valid_session
      }.to change(User, :count).by(-1)
    end

    it 'is forbidden to user' do
      first_user  = FactoryGirl.create(:user)
      second_user = FactoryGirl.create(:user)
      set_http_header!(first_user)
      expect {
        delete :destroy, {:id => second_user.id}, valid_session
      }.to change(User, :count).by(0)
    end

    it 'gives a success response' do
      user = FactoryGirl.create(:user)
      set_http_header!(manager)
      delete :destroy, {:id => user.id}, valid_session
      expect(response).to have_http_status(204)
    end
  end



end
