
module TriggersHelper
  def trigger_condition(trigger)
    return h(format("%s %i %%", trigger.operator_sign, trigger.level))
  end
end
