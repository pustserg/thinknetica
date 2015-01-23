module VoteableController
  extend ActiveSupport::Concern

  included do

  end

  def vote_up
    @resource.vote_up(current_user)
    redirect_to :back
  end

  def vote_down
    @resource.vote_down(current_user)
    redirect_to :back
  end

  module ClassMethods
    
  end
end
