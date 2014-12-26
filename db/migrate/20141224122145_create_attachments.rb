# -*- encoding : utf-8 -*-
class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file

      t.timestamps
    end
  end
end
