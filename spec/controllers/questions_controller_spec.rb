require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe '#GET index' do
    before { get :index }

    it { expect(response).to render_template(:index) }
  end

  describe '#GET new' do
    before { login(user) }
    before { get :new }

    it { expect(response).to render_template(:new) }
    it { expect(assigns(:question)).to be_a_new(Question) }
  end

  describe '#GET show' do
    before { get :show, params: { id: question } }

    it { expect(response).to render_template(:show) }
  end

  describe '#GET edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it { expect(response).to render_template(:edit) }
  end

  describe '#POST create' do
    before { login(user) }
    subject { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it { expect { subject }.to change(Question, :count).by(1) }
      it do
        subject
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      context 'when title empty' do
        let(:question_params) { attributes_for(:question, :empty_title) }

        it { expect { subject }.to_not change(Question, :count) }
        it do
          subject
          expect(response).to render_template(:new)
        end
      end

      context 'when body empty' do
        let(:question_params) { attributes_for(:question, :empty_body) }

        it { expect { subject }.to_not change(Question, :count) }
        it do
          subject
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe '#PATCH update' do
    before { login(user) }
    before { patch :update, params: { id: question, question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { { title: 'new_title', body: 'new_body' } }

      it { expect(assigns(:question)).to eq(question) }
      it { expect(question.reload.title).to eq('new_title') }
      it { expect(question.reload.body).to eq('new_body') }
    end

    context 'with invalid attributes' do
      shared_examples 'invalid result' do
        it { expect(response).to render_template(:edit) }
        it { expect(question.reload.title).to eq(question.title) }
        it { expect(question.reload.body).to eq(question.body) }
      end

      context 'when title empty' do
        let(:question_params) { { title: '', body: 'new_body' } }

        include_examples 'invalid result'
      end

      context 'when body empty' do
        let(:question_params) { { title: 'new_title', body: '' } }

        include_examples 'invalid result'
      end
    end
  end

  describe '#DELETE destroy' do
    before { login(user) }
    let!(:question) { create(:question) }

    it { expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1) }
    it do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to(questions_path)
    end
  end
end
