class CreateFriendships < ActiveRecord::Migration
  def self.up
    drop_table :friendships if ActiveRecord::Base.connection.table_exists? :friendships
    create_table :friendships do |t|
      t.integer :friendable_id
      t.integer :friend_id
      t.integer :blocker_id
      t.boolean :pending, :default => true
    end

    add_index :friendships, [:friendable_id, :friend_id], :unique => true
  end

  def self.down
    drop_table :friendships
  end
end
