module VoteableModel
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :restrict_with_error
  end

  def vote_up(user)
    votes.create(user: user, status: "+")
  end

  def vote_down(user)
    votes.create(user: user, status: "-")
  end

  module ClassMethods
  end

end