# -*- encoding : utf-8 -*-
class AddVoteableTypeToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :voteable_type, :string
    add_index :votes, :voteable_type
  end
end
