class AddVoteableToVotes < ActiveRecord::Migration
  def change
    add_reference :votes, :voteable, index: true
  end
end
