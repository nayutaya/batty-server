# -*- coding: utf-8 -*-

# == Schema Information
# Schema version: 20090420021540
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
  has_many :energies
  has_many :triggers
  has_many :events
  belongs_to :user
  belongs_to :device_icon

  validates_presence_of :name
  validates_presence_of :device_token
  validates_length_of :name, :maximum => 50, :allow_nil => true
  validates_format_of :device_token, :with => TokenUtil.create_token_regexp(20), :allow_nil => true
  validates_uniqueness_of :device_token

  def self.create_unique_device_token
    return TokenUtil.create_unique_token(self, :device_token, 20)
  end

  def current_energy
    return self.energies.first(:order => "observed_at DESC")
  end

  def energies_for_trigger
    return self.energies.all(
      :order => "energies.observed_at DESC, energies.id DESC",
      :limit => 2)
  end

  def active_triggers(energy_levels)
    return [] if energy_levels.size < 2
    return self.triggers.enable.
      all(:order => "triggers.id ASC").
      select { |trigger| trigger.triggered?(*energy_levels[0, 2]) }
  end

  def update_event
    self.transaction {
      energies = self.energies_for_trigger
      triggers = self.active_triggers(energies.map(&:observed_level))

      events = triggers.map { |trigger|
        {:device_id => self.id}.
          merge(energies.first.to_event_hash).
          merge(trigger.to_event_hash)
      }

      return events.
        reject { |attrs| Event.exists?(attrs) }.
        map    { |attrs| Event.create!(attrs) }
    }
  end

  def update_energy(options = {})
    options = options.dup
    observed_level = options.delete(:observed_level)
    observed_at    = options.delete(:observed_at)
    update_event   = (options.delete(:update_event) == true)
    raise(ArgumentError) unless options.empty?

    self.energies.create!(
      :observed_level => observed_level,
      :observed_at    => observed_at)

    self.update_event if update_event

    return nil
  end
end
