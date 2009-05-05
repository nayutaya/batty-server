
class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      # 作成日時
      t.datetime :created_at,       :null => false
      # デバイスID
      t.integer  :device_id,        :null => false
      # トリガ比較演算子
      t.integer  :trigger_operator, :null => false
      # トリガバッテリ残量
      t.integer  :trigger_level,    :null => false
      # 観測バッテリ残量
      t.integer  :observed_level,   :null => false
      # 観測日時
      t.datetime :observed_at,      :null => false
    end

    add_index :events, :device_id
    add_index :events, :observed_at
  end

  def self.down
    drop_table :events
  end
end
