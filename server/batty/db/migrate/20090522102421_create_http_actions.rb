
class CreateHttpActions < ActiveRecord::Migration
  def self.up
    create_table :http_actions do |t|
      # 作成日時
      t.datetime :created_at,  :null => false
      # 更新日時
      t.datetime :updated_at,  :null => false
      # トリガID
      t.integer  :trigger_id,  :null => false
      # 有効/無効
      t.boolean  :enable,      :null => false
      # HTTPメソッド
      t.string   :http_method, :null => false, :limit => 10
      # URL
      t.string   :url,         :null => false, :limit => 200
      # POSTデータ
      t.text     :body,        :null => true
    end

    add_index :http_actions, :trigger_id
    add_index :http_actions, :enable
  end

  def self.down
    drop_table :http_actions
  end
end
