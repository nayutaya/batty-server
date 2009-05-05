
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # 更新日時
      t.datetime :updated_at, :null => false
      # ユーザトークン
      t.string   :user_token, :null => false, :limit => 40
      # ニックネーム
      t.string   :nickname,   :null => true,  :limit => 40
    end

    add_index :users, :user_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
