# == Schema Information
# Schema version: 20090529051529
#
# Table name: active_forms
#
#  level :integer
#  time  :integer
#

# エネルギー更新APIフォーム
class UpdateEnergyApiForm < ActiveForm
  column :level, :type => :integer
  column :time,  :type => :integer

  # MEMO: 符号つき32ビット整数で表せる時間の範囲
  TimeMinimumValue = Time.at(0x00000000).strftime("%Y%m%d%H%M%S").to_i
  TimeMaximumValue = Time.at(0x7FFFFFFF).strftime("%Y%m%d%H%M%S").to_i

  validates_presence_of :level
  validates_presence_of :time
  validates_numericality_of :level, :only_integer => true, :allow_nil => true
  validates_numericality_of :time, :only_integer => true, :allow_nil => true
  validates_inclusion_of :level, :in => Energy::LevelRange, :allow_nil => true
  validates_inclusion_of :time, :in => TimeMinimumValue..TimeMaximumValue, :allow_nil => true
  validates_each(:time) { |record, attr, value|
    unless record.parsed_time
      record.errors.add(attr, :invalid)
    end
  }

  def self.from(params)
    time = params[:time]
    time = Time.now.strftime("%Y%m%d%H%M%S") if time.blank?
    return self.new(:level => params[:level], :time => time)
  end

  def parsed_time
    time = Time.parse(self.time.to_s)
    return (self.time.to_s == time.strftime("%Y%m%d%H%M%S") ? time : nil)
  rescue ArgumentError
    return nil
  end

  def to_energy_hash
    return {
      :observed_level => self.level,
      :observed_at    => self.parsed_time,
    }
  end
end
