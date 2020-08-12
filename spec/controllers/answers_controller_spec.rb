require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question) }

  before { sign_in(user) }

  describe '#POST create' do
    subject { post :create, params: { question_id: question, answer: answer_params, format: :js } }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it { expect { subject }.to change(Answer, :count).by(1) }
      it { expect { subject }.to change(question.answers, :count).by(1) }
      it do
        subject
        expect(assigns(:answer).user).to eq(user)
      end
      it do
        subject
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      context 'when body empty' do
        let(:answer_params) { attributes_for(:answer, :empty_body) }

        it { expect { subject }.to_not change(Answer, :count) }
        it do
          subject
          expect(response).to render_template(:create)
        end
      end
    end
  end

  describe '#PATCH update' do
    before { patch :update, params: { question_id: question, id: answer, answer: answer_params, format: :js } }

    context 'user is answer owner' do
      let!(:answer) { create(:answer, question: question, user: user) }

      context 'with valid attributes' do
        let(:answer_params) { { body: 'new_body' } }

        it { expect(response).to render_template(:update) }
        it { expect(assigns(:answer)).to eq(answer) }
        it { expect(answer.reload.body).to eq('new_body') }
      end

      context 'with invalid attributes' do
        context 'when body empty' do
          let(:answer_params) { attributes_for(:answer, :empty_body) }

          it { expect(response).to render_template(:update) }
          it { expect(assigns(:answer)).to eq(answer) }
          it { expect(answer.reload.body).to eq(answer.body) }
        end
      end
    end

    context 'user is not answer owner' do
      let!(:answer) { create(:answer, question: question) }

      context 'with valid attributes' do
        let(:answer_params) { { body: 'new_body' } }

        it { expect(response).to render_template('questions/show') }
        it { expect(assigns(:answer)).to eq(answer) }
        it { expect(answer.reload.body).to eq(answer.body) }
      end

      context 'with invalid attributes' do
        context 'when body empty' do
          let(:answer_params) { attributes_for(:answer, :empty_body) }

          it { expect(response).to render_template('questions/show') }
          it { expect(assigns(:answer)).to eq(answer) }
          it { expect(answer.reload.body).to eq(answer.body) }
        end
      end
    end
  end

  describe '#DELETE destroy' do
    context 'user is answer owner' do
      let!(:answer) { create(:answer, question: question, user: user) }

      subject { delete :destroy, params: { question_id: question, id: answer, format: :js } }

      it { expect { subject }.to change(Answer, :count).by(-1) }
      it do
        subject
        expect(response).to render_template(:destroy)
      end
    end

    context 'user is not answer owner' do
      let!(:answer) { create(:answer, question: question, user: another_user) }

      subject { delete :destroy, params: { question_id: question, id: answer, format: :js } }

      it { expect { subject }.to_not change(Answer, :count) }
      it do
        subject
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe '#PATCH choose_as_best' do
    shared_examples 'correct result' do
      it { expect(response).to render_template(:choose_as_best) }
      it { expect(question.reload.best_answer).to eq(answer) }
    end

    shared_examples 'incorrect result' do
      it { expect(response).to render_template(:choose_as_best) }
      it { expect(question.reload.best_answer).to be_nil }
    end

    context 'user is question owner' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }

      context "and best answer do not exist yet" do
        before { patch :choose_as_best, params: { id: answer, format: :js } }

        context 'and answer owner' do
          let!(:answer) { create(:answer, user: user, question: question) }

          include_examples 'correct result'
        end

        context "and isn't answer owner" do
          let!(:answer) { create(:answer, question: question) }

          include_examples 'correct result'
        end
      end

      context "and best answer already exist" do
        let!(:answer) { create(:answer, question: question, best_answer: true) }
        let!(:another_answer) { create(:answer, question: question) }

        before { patch :choose_as_best, params: { id: another_answer, format: :js } }

        it { expect(response).to render_template(:choose_as_best) }
        it { expect(question.reload.best_answer).to eq(another_answer) }
      end
    end

    context 'user is not question owner' do
      before { login(user) }
      let!(:question) { create(:question) }

      before { patch :choose_as_best, params: { id: answer, format: :js } }

      context 'and answer owner' do
        let!(:answer) { create(:answer, user: user, question: question) }

        include_examples 'incorrect result'
      end

      context "and isn't answer owner" do
        let!(:answer) { create(:answer, question: question) }

        include_examples 'incorrect result'
      end
    end
  end

  include_examples 'rated_actions', :answer
  include_examples 'commented_actions', :answer
end
