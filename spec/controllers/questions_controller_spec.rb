# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
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
    it { expect(assigns(:question).links.first).to be_a_new(Link) }
  end

  describe '#GET show' do
    before { get :show, params: { id: question } }

    it { expect(response).to render_template(:show) }
  end

  describe '#POST create' do
    before { login(user) }
    subject { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it { expect { subject }.to change(Question, :count).by(1) }
      it do
        subject
        expect(assigns(:question).user).to eq(user)
      end
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
    before { patch :update, params: { id: question, question: question_params, format: :js } }

    context 'when user is question owner' do
      let(:question) { create(:question, user: user) }

      context 'with valid attributes' do
        let(:question_params) { { title: 'new_title', body: 'new_body' } }

        it { expect(response).to render_template(:update) }
        it { expect(assigns(:question)).to eq(question) }
        it { expect(question.reload.title).to eq('new_title') }
        it { expect(question.reload.body).to eq('new_body') }
      end

      context 'with invalid attributes' do
        shared_examples 'invalid result' do
          it { expect(response).to render_template(:update) }
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

    context 'when user is not question owner' do
      let(:question) { create(:question) }

      context 'with valid attributes' do
        let(:question_params) { { title: 'new_title', body: 'new_body' } }

        it { expect(response).to render_template(:show) }
        it { expect(assigns(:question)).to eq(question) }
        it { expect(question.reload.title).to eq(question.title) }
        it { expect(question.reload.body).to eq(question.body) }
      end

      context 'with invalid attributes' do
        shared_examples 'invalid result' do
          it { expect(response).to render_template(:show) }
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
  end

  describe '#DELETE destroy' do
    context 'user is question owner' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }

      it { expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1) }
      it do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to(questions_path)
      end
    end

    context 'user is not question owner' do
      before { login(user) }
      let!(:question) { create(:question, user: another_user) }

      it { expect { delete :destroy, params: { id: question } }.to_not change(Question, :count) }
      it do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to(questions_path)
      end
    end
  end

  describe '#POST subscribe' do
    before { login(user) }
    before { post :subscribe, params: { id: question, format: :js } }

    context 'when user is question owner' do
      let(:question) { create(:question, user: user) }

      it { expect(response.body).to be_truthy }
    end

    context 'when user is not question owner' do
      let(:question) { create(:question) }

      it { expect(response.body).to be_truthy }
    end
  end

  describe '#DELETE unsubscribe' do
    before { login(user) }
    subject { delete :unsubscribe, params: { id: question, format: :js } }

    context 'when user is question owner' do
      let(:question) { create(:question, user: user) }

      it do
        subject
        expect(response.body).to be_truthy
        expect(question.reload.subscriptions.count).to eq(0)
      end
    end

    context 'when user is question owner' do
      let(:question) { create(:question, user: user) }

      it do
        subject
        expect(response.body).to be_truthy
      end

      it { expect { subject }.to_not change(Subscription, :count) }
    end
  end

  include_examples 'rated_actions', :question
  include_examples 'commented_actions', :question
end
