# -*- encoding : utf-8 -*-
class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.string :status

      t.timestamps
    end
  end
end
