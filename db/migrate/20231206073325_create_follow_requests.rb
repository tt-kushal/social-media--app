class CreateFollowRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :follow_requests do |t|
      t.integer :follower_id, null: false
      t.integer :following_id, null: false
      t.integer :status, default: 0
      t.timestamps
    end

    add_foreign_key :follow_requests, :users, column: :follower_id
    add_foreign_key :follow_requests, :users, column: :following_id
  end
end
