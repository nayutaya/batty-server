
class CreateTriggers < ActiveRecord::Migration
  def self.up
    create_table :triggers do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # 更新日時
      t.datetime :updated_at, :null => false
      # デバイスID
      t.integer  :device_id,  :null => false
      # 有効/無効
      t.boolean  :enable,     :null => false
      # 比較演算子
      t.integer  :operator,   :null => false
      # バッテリ残量
      t.integer  :level,      :null => false
    end

    add_index :triggers, :device_id
    add_index :triggers, :enable
    add_index :triggers, :level
  end

  def self.down
    drop_table :triggers
  end
end
