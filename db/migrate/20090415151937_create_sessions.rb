
class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
      t.string   :session_id, :null => false, :limit => 64
      t.text     :data,       :null => true
    end

    add_index :sessions, :updated_at
    add_index :sessions, :session_id, :unique => true
  end

  def self.down
    drop_table :sessions
  end
end
