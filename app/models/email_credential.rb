# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090529051529
#
# Table name: email_credentials
#
#  id               :integer       not null, primary key
#  created_at       :datetime      not null, index_email_credentials_on_created_at
#  activation_token :string(40)    not null, index_email_credentials_on_activation_token(unique)
#  user_id          :integer       not null, index_email_credentials_on_user_id
#  email            :string(200)   not null, index_email_credentials_on_email(unique)
#  hashed_password  :string(73)    not null
#  activated_at     :datetime      index_email_credentials_on_activated_at
#  loggedin_at      :datetime
#

# メール認証情報
class EmailCredential < ActiveRecord::Base
  EmailMaximumLength = 200
  TokenLength  = 20
  TokenPattern = TokenUtil.create_token_regexp(TokenLength)
  HashedPasswordPattern = /\A([0-9a-f]{8}):([0-9a-f]{64})\z/
  MaximumRecordsPerUser = 10

  belongs_to :user

  validates_presence_of :email
  validates_presence_of :activation_token
  validates_presence_of :hashed_password
  validates_length_of :email, :maximum => EmailMaximumLength, :allow_nil => true
  validates_format_of :activation_token, :with => TokenPattern, :allow_nil => true
  validates_format_of :hashed_password, :with => HashedPasswordPattern, :allow_nil => true
  validates_email_format_of :email,
    :message => "%{fn}は有効なメールアドレスではありません。"
  validates_uniqueness_of :email
  validates_each(:user_id, :on => :create) { |record, attr, value|
    if record.user && record.user.email_credentials(true).size >= MaximumRecordsPerUser
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }

  before_validation_on_create { |record|
    if record.activation_token.blank?
      record.activation_token = record.class.create_unique_activation_token
    end
  }

  def self.create_unique_activation_token
    return TokenUtil.create_unique_token(self, :activation_token, TokenLength)
  end

  def self.create_hashed_password(password)
    salt = 8.times.map { rand(16).to_s(16) }.join
    return salt + ":" + Digest::SHA256.hexdigest(salt + ":" + password)
  end

  def self.compare_hashed_password(password, hashed_password)
    return false unless HashedPasswordPattern =~ hashed_password
    salt, digest = $1, $2
    return (Digest::SHA256.hexdigest(salt + ":" + password) == digest)
  end

  def self.authenticate(email, password)
    credential = self.find_by_email(email)
    return nil unless credential
    return nil unless credential.authenticated?(password)
    return credential
  end

  def authenticated?(password)
    return false unless self.class.compare_hashed_password(password, self.hashed_password)
    return false unless self.activated?
    return true
  end

  def activated?
    return !self.activated_at.nil?
  end

  def activate!
    return false if self.activated?
    self.update_attributes!(:activated_at => Time.now)
    return true
  end

  def login!
    self.update_attributes!(:loggedin_at => Time.now)
  end
end
