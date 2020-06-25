require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe '#GET index' do
    before { get :index, params: { question_id: question } }

    it { expect(response).to render_template(:index) }
  end

  describe '#GET new' do
    before { get :new, params: { question_id: question } }

    it { expect(response).to render_template(:new) }
    it { expect(assigns(:answer)).to be_a_new(Answer) }
    it { expect(assigns(:answer).question).to eq(question) }
  end

  describe '#GET show' do
    before { get :show, params: { question_id: question, id: answer } }

    it { expect(response).to render_template(:show) }
  end

  describe '#GET edit' do
    before { get :edit, params: { question_id: question, id: answer } }

    it { expect(response).to render_template(:edit) }
  end

  describe '#POST create' do
    context 'with valid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it { expect { subject }.to change(Answer, :count).by(1) }
      it do
        subject
        expect(response).to redirect_to(question_answer_path(question, Answer.last))
      end
    end

    context 'with invalid attributes' do
      context 'when body empty' do
        subject { post :create, params: { question_id: question, answer: attributes_for(:answer, :empty_body) } }

        it { expect { subject }.to_not change(Answer, :count) }
        it do
          subject
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe '#PATCH update' do
    before { patch :update, params: { question_id: question, id: answer, answer: answer_params } }

    context 'with valid attributes' do
      let(:answer_params) { { body: 'new_body' } }

      it { expect(assigns(:answer)).to eq(answer) }
      it { expect(answer.reload.body).to eq('new_body') }
    end

    context 'with invalid attributes' do
      context 'when body empty' do
        let(:answer_params) { { body: '' } }

        it { expect(response).to render_template(:edit) }
        it { expect(answer.reload.body).to eq('My body') }
      end
    end
  end

  describe '#DELETE destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    subject { delete :destroy, params: { question_id: question, id: answer } }

    it { expect { subject }.to change(Answer, :count).by(-1) }
    it do
      subject
      expect(response).to redirect_to(question_answers_path(question))
    end
  end
end
