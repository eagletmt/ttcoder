require 'spec_helper'

describe SessionsController do
  describe '#create_user' do
    let(:user_params) do
      {
        name: 'User_Name',
        poj_user: '',
        aoj_user: '',
      }
    end

    context 'without auth hash' do
      it 'rejects' do
        post :create_user, user: user_params
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
