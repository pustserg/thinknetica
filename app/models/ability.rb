class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :edit, :update, :destroy, to: :eud
    @user = user
    if user
      user.admin? ? admin_abilty : user_ability
    else
      guest_ability      
    end
  end

  def guest_ability
    can :read, :all
  end

  def admin_abilty
    can :manage, :all
  end

  def user_ability
    guest_ability
    can :create, [Question, Answer, Comment, Vote]
    can(:eud, [Question, Answer, Comment]) { |resource| resource.user == user }

    can(:edit, Question) { |resource| resource.user == user }

    [Question, Answer, Comment].each do |cl|
      can(:vote_up, cl) { |object| object.user != user && !object.votes.map(&:user).include?(user) }
      can(:vote_down, cl) { |object| object.user != user && !object.votes.map(&:user).include?(user) }
    end

    can(:make_best, Answer) { |answer| answer.question.user == user } 
    can(:add_to_favs, Question)
  end
end
