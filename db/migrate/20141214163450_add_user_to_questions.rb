# -*- encoding : utf-8 -*-
class AddUserToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, index: true
  end
end
