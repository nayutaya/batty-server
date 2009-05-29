
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
  # TODO: timeの時間としての正しさ

  # TODO: paramsからインスタンスを生成するメソッドを追加
  # TODO: Energyモデルを作成するためのハッシュを生成するメソッドを追加
end
