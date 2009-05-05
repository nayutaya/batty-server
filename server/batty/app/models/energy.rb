# == Schema Information
# Schema version: 20090420021540
#
# Table name: energies
#
#  id             :integer       not null, primary key
#  created_at     :datetime      not null
#  device_id      :integer       not null, index_energies_on_device_id
#  observed_level :integer       not null
#  observed_at    :datetime      not null, index_energies_on_observed_at
#

# エネルギー
class Energy < ActiveRecord::Base
  belongs_to :device

  validates_presence_of :observed_level
  validates_presence_of :observed_at
  validates_inclusion_of :observed_level, :in => (0..100), :allow_nil => true

  # TODO: Eventモデルに変換するためのハッシュを生成するインスタンスメソッドを実装
end
