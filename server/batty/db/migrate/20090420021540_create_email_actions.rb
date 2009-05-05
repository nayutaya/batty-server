
class CreateEmailActions < ActiveRecord::Migration
  def self.up
    create_table :email_actions do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # 更新日時
      t.datetime :updated_at, :null => false
      # トリガID
      t.integer  :trigger_id, :null => false
      # 有効/無効
      t.boolean  :enable,     :null => false
      # メールアドレス
      t.string   :email,      :null => false, :limit => 200
      # メール表題
      t.string   :subject,    :null => false, :limit => 200
      # メール本文
      t.text     :body,       :null => true
    end

    add_index :email_actions, :trigger_id
    add_index :email_actions, :enable
  end

  def self.down
    drop_table :email_actions
  end
end
