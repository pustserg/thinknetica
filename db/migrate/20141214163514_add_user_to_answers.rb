# -*- encoding : utf-8 -*-
class AddUserToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :user, index: true
  end
end
