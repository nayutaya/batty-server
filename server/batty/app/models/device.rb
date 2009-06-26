# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090529051529
#
# Table name: devices
#
#  id             :integer       not null, primary key
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  device_token   :string(40)    not null, index_devices_on_device_token(unique)
#  user_id        :integer       not null, index_devices_on_user_id
#  name           :string(50)    not null, index_devices_on_name
#  device_icon_id :integer       not null, index_devices_on_device_icon_id
#

# デバイス
class Device < ActiveRecord::Base
  NameMaximumLength = 50
  TokenLength  = 20
  TokenPattern = TokenUtil.create_token_regexp(TokenLength)
  MaximumRecordsPerUser = 10

  has_many :energies, :dependent => :destroy
  has_many :triggers, :dependent => :destroy
  has_many :email_actions, :through => :triggers
  has_many :http_actions, :through => :triggers
  has_many :events, :dependent => :destroy
  belongs_to :user
  belongs_to :device_icon

  validates_presence_of :device_token
  validates_presence_of :user_id
  validates_presence_of :name
  validates_presence_of :device_icon_id
  validates_length_of :name, :maximum => NameMaximumLength, :allow_nil => true
  validates_format_of :device_token, :with => TokenPattern, :allow_nil => true
  validates_uniqueness_of :device_token
  validates_each(:user_id, :on => :create) { |record, attr, value|
    if record.user && record.user.devices(true).size >= MaximumRecordsPerUser
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }

  before_validation_on_create { |record|
    record.device_token ||= record.class.create_unique_device_token
  }

  def self.create_unique_device_token
    return TokenUtil.create_unique_token(self, :device_token, TokenLength)
  end

  def current_energy
    return self.energies.first(
      :order => "energies.observed_at DESC, energies.id DESC")
  end

  def current_two_energies
    return self.energies.all(
      :order => "energies.observed_at DESC, energies.id DESC",
      :limit => 2)
  end

  def fired_triggers(first_level, second_level)
    return [] if first_level.nil?
    return [] if second_level.nil?
    return self.triggers.enable.
      all(:order => "triggers.id ASC").
      select { |trigger| trigger.fire?(first_level, second_level) }
  end

  def build_events
    current_energies = self.current_two_energies
    current_energy   = current_energies.first
    level1, level2   = current_energies.map(&:observed_level)
    fired_triggers   = self.fired_triggers(level1, level2)

    return fired_triggers.
      map    { |trigger| [trigger, self.events.find_or_initialize_by_trigger_id_and_energy_id(trigger.id, current_energy.id)] }.
      select { |trigger, event| event.new_record? }.
      each   { |trigger, event| event.attributes = trigger.to_event_hash }.
      each   { |trigger, event| event.attributes = current_energy.to_event_hash }.
      map    { |trigger, event| event }
  end
end
