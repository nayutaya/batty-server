
class CreateDeviceIcons < ActiveRecord::Migration
  def self.up
    create_table :device_icons do |t|
      # 作成日時
      t.datetime :created_at,    :null => false
      # 更新日時
      t.datetime :updated_at,    :null => false
      # 表示順
      t.integer  :display_order, :null => false
      # 名称
      t.string   :name,          :null => false, :limit => 30
      # 16x16アイコンのURL
      t.string   :url16,         :null => false, :limit => 200
      # 32x32アイコンのURL
      t.string   :url32,         :null => false, :limit => 200
    end

    add_index :device_icons, :display_order
  end

  def self.down
    drop_table :device_icons
  end
end
