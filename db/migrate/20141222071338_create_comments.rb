class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :commentable, index: true

      t.timestamps
    end
  end
end
