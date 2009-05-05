
class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      # 作成日時
      t.datetime :created_at,     :null => false
      # 更新日時
      t.datetime :updated_at,     :null => false
      # デバイストークン
      t.string   :device_token,   :null => false, :limit => 40
      # ユーザID
      t.integer  :user_id,        :null => false
      # 名称
      t.string   :name,           :null => false, :limit => 50
      # デバイスアイコンID
      t.integer  :device_icon_id, :null => false
    end

    add_index :devices, :device_token, :unique => true
    add_index :devices, :user_id
    add_index :devices, :name
    add_index :devices, :device_icon_id
  end

  def self.down
    drop_table :devices
  end
end
