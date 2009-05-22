class CreateHttpActions < ActiveRecord::Migration
  def self.up
    create_table :http_actions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :http_actions
  end
end
