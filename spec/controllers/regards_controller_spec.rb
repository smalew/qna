require 'rails_helper'

RSpec.describe RegardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }
  let!(:regard) { create(:regard, question: question, answer: answer) }


  describe '#GET index' do
    context 'Login user' do
      before { login(user) }
      before { get :index }

      it { expect(response).to render_template(:index) }
      it { expect(assigns(:regards)).to eq([regard]) }
    end

    context 'Anonym user' do
      before { get :index }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end
end
