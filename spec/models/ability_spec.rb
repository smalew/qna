# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Rate }
    it { should be_able_to :read, Regard }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user, admin: false) }
    let(:another_user) { create(:user, admin: false) }

    let(:question) { create(:question, :with_file, user: user) }
    let(:another_question) { create(:question, :with_file, user: another_user) }

    let(:answer) { create(:answer, :with_file, user: user, question: question) }
    let(:another_answer) { create(:answer, :with_file, user: another_user, question: another_question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, another_question, user: user }

      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, another_question, user: user }

      it { should_not be_able_to :rate_up, question, user: user }
      it { should_not be_able_to :rate_down, question, user: user }
      it { should_not be_able_to :cancel_rate, question, user: user }
      it { should be_able_to :rate_up, another_question, user: user }
      it { should be_able_to :rate_down, another_question, user: user }
      it { should be_able_to :cancel_rate, another_question, user: user }

      it { should be_able_to :create_comment, question, user: user }
      it { should be_able_to :create_comment, another_question, user: user }
    end

    context 'answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, another_answer, user: user }

      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, another_answer, user: user }

      it { should_not be_able_to :rate_up, answer, user: user }
      it { should_not be_able_to :rate_down, answer, user: user }
      it { should_not be_able_to :cancel_rate, answer, user: user }
      it { should be_able_to :rate_up, another_answer, user: user }
      it { should be_able_to :rate_down, another_answer, user: user }
      it { should be_able_to :cancel_rate, another_answer, user: user }

      it { should be_able_to :create_comment, answer, user: user }
      it { should be_able_to :create_comment, another_answer, user: user }

      it { should be_able_to :choose_as_best, answer, { question: { user: user } } }
      it { should_not be_able_to :choose_as_best, another_answer, { question: { user: user } } }
    end

    context 'comment' do
      let(:comment) { create(:comment, user: user) }
      let(:another_comment) { create(:comment, user: another_user) }

      it { should be_able_to :create, Comment }
      it { should be_able_to :update, comment, user: user }
      it { should be_able_to :destroy, comment, user: user }

      it { should_not be_able_to :update, another_comment, user: user }
      it { should_not be_able_to :destroy, another_comment, user: user }
    end

    context 'rate' do
      let(:rate) { create(:rate, user: user) }
      let(:another_rate) { create(:rate, user: another_user) }

      it { should be_able_to :create, Rate }
      it { should be_able_to :update, rate, user: user }
      it { should be_able_to :destroy, rate, user: user }

      it { should_not be_able_to :update, another_rate, user: user }
      it { should_not be_able_to :destroy, another_rate, user: user }
    end

    context 'link' do
      let(:link) { create(:link, linkable: question) }
      let(:another_link) { create(:link, linkable: another_question) }

      it { should be_able_to :create, Link }
      it { should be_able_to :update, link, linkable: { user: user } }
      it { should be_able_to :destroy, link, linkable: { user: user } }

      it { should_not be_able_to :update, another_link, linkable: { user: user } }
      it { should_not be_able_to :destroy, another_link, linkable: { user: user } }
    end

    context 'regard' do
      let(:regard) { create(:regard, question: question) }
      let(:another_regard) { create(:regard, question: another_question) }

      it { should be_able_to :create, Regard }
      it { should be_able_to :update, regard, question: { user: user } }
      it { should be_able_to :destroy, regard, question: { user: user } }

      it { should_not be_able_to :update, another_regard, question: { user: user } }
      it { should_not be_able_to :destroy, another_regard, question: { user: user } }
    end

    context 'attachment' do
      it { should be_able_to :create, Regard }
      it { should be_able_to :destroy, question.files.first, record: { user: user } }
      it { should be_able_to :destroy, answer.files.first, record: { user: user } }

      it { should_not be_able_to :destroy, another_question.files.first, record: { user: user } }
      it { should_not be_able_to :destroy, another_answer.files.first, record: { user: user } }
    end
  end
end
