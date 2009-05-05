
class CreateOpenIdCredentials < ActiveRecord::Migration
  def self.up
    create_table :open_id_credentials do |t|
      # 作成日時
      t.datetime :created_at,   :null => false
      # ユーザID
      t.integer  :user_id,      :null => false
      # 識別URL
      t.string   :identity_url, :null => false, :limit => 200
      # ログイン日時
      t.datetime :loggedin_at,  :null => true
    end

    add_index :open_id_credentials, :user_id
    add_index :open_id_credentials, :identity_url, :unique => true
  end

  def self.down
    drop_table :open_id_credentials
  end
end
