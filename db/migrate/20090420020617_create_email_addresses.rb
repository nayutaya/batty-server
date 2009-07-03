
class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      # 作成日時
      t.datetime :created_at,       :null => false
      # アクティべーショントークン
      t.string   :activation_token, :null => false, :limit => 40
      # ユーザID
      t.integer  :user_id,          :null => false
      # メールアドレス
      t.string   :email,            :null => false, :limit => 200
      # アクティべーション日時
      t.datetime :activated_at,     :null => true
    end

    add_index :email_addresses, :created_at
    add_index :email_addresses, :activation_token, :unique => true
    add_index :email_addresses, :user_id
    add_index :email_addresses, [:email, :user_id], :unique => true
    add_index :email_addresses, :activated_at
  end

  def self.down
    drop_table :email_addresses
  end
end
