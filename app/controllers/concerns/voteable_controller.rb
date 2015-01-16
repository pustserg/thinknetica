module VoteableController
  extend ActiveSupport::Concern

  included do
    before_filter :check_for_voting, only: [:vote_down, :vote_up]
  end

  def vote_up
    @resource.vote_up(current_user)
    redirect_to :back
  end

  def vote_down
    @resource.vote_down(current_user)
    redirect_to :back
  end

  private
  def check_for_voting
    render json: { error: 'fufufu' }, status: 403 if current_user == @resource.user
    
    votes.each do |vote|
      if vote.user == current_user
        redirect_to :back and return
      end
    end
  end

  module ClassMethods
    
  end
end
