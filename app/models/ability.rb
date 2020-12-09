# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end
  end

  def quest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities

    can :create, [Question, Answer, Comment, Link, Rate, Regard, ActiveStorage::Attachment, Subscription]
    can :update, [Question, Answer, Comment, Rate], user_id: user.id
    can :destroy, [Question, Answer, Comment, Rate, Subscription], user_id: user.id

    subscribe_abilities
    links_abilities
    regard_abilities
    attachment_abilities
    rate_abilities
    comment_abilities
  end

  private

  def subscribe_abilities
    can(:subscribe, Question)
    can(:unsubscribe, Question)
  end

  def links_abilities
    can :update, Link do |link|
      user.author_of?(link.linkable)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end
  end

  def regard_abilities
    can :update, Regard do |link|
      user.author_of?(link.question)
    end

    can :destroy, Regard do |link|
      user.author_of?(link.question)
    end

    can :choose_as_best, Answer do |answer|
      user.author_of?(answer.question)
    end
  end

  def attachment_abilities
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end

  def rate_abilities
    can :rate_up, [Question, Answer] do |record|
      !user.author_of?(record)
    end

    can :rate_down, [Question, Answer] do |record|
      !user.author_of?(record)
    end

    can :cancel_rate, [Question, Answer] do |record|
      !user.author_of?(record)
    end
  end

  def comment_abilities
    can :create_comment, [Question, Answer]
  end
end
