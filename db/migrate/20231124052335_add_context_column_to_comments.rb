class AddContextColumnToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :content, :text
  end
end