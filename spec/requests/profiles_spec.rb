require 'rails_helper'

RSpec.describe ProfilesController , type: :controller do 
    include Devise::Test::IntegrationHelpers

    let(:user) { FactoryBot.create(:user) }
    let(:user1) { FactoryBot.create(:user) }

    let(:valid_token) { JWT.encode({ sub: user.id, exp: Time.now.to_i + 3600 }, 'your_secret_key', 'HS256') }
    let(:valid_token1) { JWT.encode({ sub: user1.id, exp: Time.now.to_i + 3600 }, 'your_secret_key', 'HS256') }

    let(:profile) { FactoryBot.create(:profile, user: user1) }
    let(:valid_params) { FactoryBot.attributes_for(:profile) }
    
    let(:invalid_token) { "invalid_token" }
   

    describe 'POST #create' do
        context 'when user has no profile' do
          it 'creates a new profile' do
            request.headers['token'] = valid_token
            post :create, params: { profile: valid_params}
            json_response = JSON.parse(response.body)
            expect(response).to have_http_status(201)
            expect(json_response['profile']).not_to be_nil
          end
        end
    
        context 'when user already has a profile' do
          it 'returns a message that profile has already been created' do
            profile 
            request.headers['token'] = valid_token1
            post :create, params: { profile: valid_params}

            json_response = JSON.parse(response.body)
            expect(response).to have_http_status(200)
            expect(json_response['message']).to eq('profile has already been created')
          end
        end

        context 'when user tries to with invalid create a profile' do
          it 'returns a error message' do
            profile 
            request.headers['token'] = valid_token
            post :create, params: { profile: valid_params.merge(username:"")}
            
            json_response = JSON.parse(response.body)
            expect(response).to have_http_status(422)
            expect(json_response['error']).to eq(["Username can't be blank"])
          end
        end
    end

    describe 'GET #show_my_profile' do
        it 'returns the user profile' do
          profile 
          request.headers['token'] = valid_token1
          get :show_my_profile

          json_response = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
        end
    
        it 'returns 404 if profile not found' do
          request.headers['token'] = valid_token
          get :show_my_profile

          json_response = JSON.parse(response.body)
          expect(response).to have_http_status(404)
          expect(json_response['message']).to eq('profile not found')
        end
    end

    describe 'Put #update' do
      it 'updates the user profile' do
        request.headers['token'] = valid_token1
        patch :update, params: { id: profile.id, profile: { username: 'new_username', age: 30 } }

        json_response = JSON.parse(response.body)
      
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns 422 if profile could not update' do
        
        request.headers['token'] = valid_token1
        patch :update, params: { id: profile.id, profile: { username: '', age: 30 } }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(422)
      end

      it 'returns 404 if profile not found' do
        
        request.headers['token'] = valid_token
        patch :update, params: { id: profile.id, profile: { username: '', age: 30 } }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json_response['message']).to include('profile not found')
      end
    end

    describe 'Delete #destroy' do
      it 'deletes the user profile' do
        request.headers['token'] = valid_token1
        delete :destroy, params: { id: profile.id}

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns 404 if profile not found' do
        request.headers['token'] = valid_token
        delete :destroy, params: { id: profile.id}

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json_response['message']).to eq('profile not found')
      end
    end
end
