# -*- coding: utf-8 -*-

# == Schema Information
# Schema version: 20090522102421
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
  has_many :energies, :dependent => :destroy
  has_many :triggers, :dependent => :destroy
  has_many :email_actions, :through => :triggers
  has_many :http_actions, :through => :triggers
  has_many :events, :dependent => :destroy
  belongs_to :user
  belongs_to :device_icon

  TokenLength  = 20
  TokenPattern = TokenUtil.create_token_regexp(TokenLength)

  validates_presence_of :device_token
  validates_presence_of :user_id
  validates_presence_of :name
  validates_presence_of :device_icon_id
  validates_length_of :name, :maximum => 50, :allow_nil => true
  validates_format_of :device_token, :with => TokenPattern, :allow_nil => true
  validates_uniqueness_of :device_token

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

  # FIXME: リファクタリング
  def update_event
    self.transaction {
      current_energies = self.current_two_energies
      current_energy   = current_energies.first

      first_level, second_level = current_energies.map(&:observed_level)
      triggers = self.fired_triggers(first_level, second_level)

      return triggers.map { |trigger|
        event = {:device_id => self.id, :trigger_id => trigger.id, :energy_id => current_energy.id}
        event.merge!(trigger.to_event_hash)
        event.merge!(current_energy.to_event_hash)
        [current_energy, trigger, event]
      }.reject { |energy, trigger, event|
        Event.exists?(event)
      }.map { |energy, trigger, event|
        Event.create!(event)
      }
    }
  end

=begin
  # FIXME: リファクタリング
  def update_energy(options = {})
    options = options.dup
    observed_level = options.delete(:observed_level)
    observed_at    = options.delete(:observed_at)
    update_event   = (options.delete(:update_event) == true)
    raise(ArgumentError) unless options.empty?

    self.transaction {
      self.energies.create!(
        :observed_level => observed_level,
        :observed_at    => observed_at)

      if update_event
        return self.update_event
      else
        return nil
      end
    }
  end
=end
end
