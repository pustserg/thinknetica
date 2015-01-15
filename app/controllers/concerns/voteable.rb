module VoteableControler
  extend ActiveSupport::Concern

  included do
    before_filter :check_for_voting
    def vote_up
      self.vote_up(current_user)
      redirect_to :back
    end

    def vote_down
      self.vote_down(current_user)
      redirect_to :back
    end

    def check_for_voting
      render json: { error: 'fufufu' }, status: 403 if current_user == user
      
      votes.each do |vote|
        if vote.user == current_user
          redirect_to :back and return
        end
      end
    end
  end

  module ClassMethods
    
  end
end
