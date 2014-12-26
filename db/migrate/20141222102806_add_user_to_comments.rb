# -*- encoding : utf-8 -*-
class AddUserToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :user, index: true
  end
end
