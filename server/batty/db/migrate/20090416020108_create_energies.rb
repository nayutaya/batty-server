
class CreateEnergies < ActiveRecord::Migration
  def self.up
    create_table :energies do |t|
      # 作成日時
      t.datetime :created_at,     :null => false
      # デバイスID
      t.integer  :device_id,      :null => false
      # 観測バッテリ残量
      t.integer  :observed_level, :null => false
      # 観測日時
      t.datetime :observed_at,    :null => false
    end

    add_index :energies, :device_id
    add_index :energies, :observed_at
  end

  def self.down
    drop_table :energies
  end
end
