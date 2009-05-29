
class AlterEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :trigger_id, :integer, :null => true
    add_column :events, :energy_id,  :integer, :null => true
    add_index :events, :trigger_id
    add_index :events, :energy_id
  end

  def self.down
    remove_index :events, :trigger_id
    remove_index :events, :energy_id
    remove_column :events, :trigger_id
    remove_column :events, :energy_id
  end
end
