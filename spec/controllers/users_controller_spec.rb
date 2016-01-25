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
    end

  end



  describe 'GET #show' do
    it 'gets user response as a hash' do
      set_http_header!(user)
      get :show, {:id => user.to_param}, valid_session
      
      expect(assigns(:user)).to eq(user)
    end
  end

  # describe 'POST #create' do
  #   context 'with valid params' do
  #     it 'creates a new User' do
  #       valid_attributes[:role] = :regular
  #       expect {
  #         post :create, {:user => valid_attributes}, valid_session
  #       }.to change(User, :count).by(1)
  #     end
  #   end

  #   context 'with invalid params' do
  #     it 'assigns a newly created but unsaved user as @user' do
  #       post :create, {:user => invalid_attributes}, valid_session
  #       expect(assigns(:user)).to be_a_new(User)
  #     end
  #   end
  # end

  # describe 'PUT #update' do
  #   context 'with valid params' do

  #     let(:new_attributes) { {email: 'someone@else.com'} }

  #     it 'updates the requested user' do
  #       put :update, {:id => user.to_param, :user => new_attributes}, valid_session
  #       user.reload
  #       skip('Add assertions for updated state')
  #       expect(user.email).to eq('someone@else.com')
  #     end

  #     it 'assigns the requested user as @user' do
  #       put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
  #       expect(assigns(:user)).to eq(user)
  #     end
  #   end

  #   context 'with invalid params' do
  #     it 'assigns the user as @user' do
  #       put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
  #       expect(assigns(:user)).to eq(user)
  #     end
  #   end
  # end

  # describe 'DELETE #destroy' do
  #   it 'destroys the requested user' do
  #     expect {
  #       delete :destroy, {:id => user.to_param}, valid_session
  #     }.to change(User, :count).by(-1)
  #   end

  #   it 'redirects to the users list' do
  #     delete :destroy, {:id => user.to_param}, valid_session
  #     expect(response).to redirect_to(users_url)
  #   end
  # end



end
