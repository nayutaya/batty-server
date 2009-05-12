
class CreateEmailCredentials < ActiveRecord::Migration
  def self.up
    create_table :email_credentials do |t|
      # 作成日時
      t.datetime :created_at,       :null => false
      # アクティべーショントークン
      t.string   :activation_token, :null => false, :limit => 40
      # ユーザID
      t.integer  :user_id,          :null => false
      # メールアドレス
      t.string   :email,            :null => false, :limit => 200
      # ハッシュされたパスワード
      t.string   :hashed_password,  :null => false, :limit => 8 + 1 + 64
      # アクティべーション日時
      t.datetime :activated_at,     :null => true
      # ログイン日時
      t.datetime :loggedin_at,      :null => true
    end

    add_index :email_credentials, :created_at
    add_index :email_credentials, :activation_token, :unique => true
    add_index :email_credentials, :user_id
    add_index :email_credentials, :email, :unique => true
    add_index :email_credentials, :activated_at
  end

  def self.down
    drop_table :email_credentials
  end
end
