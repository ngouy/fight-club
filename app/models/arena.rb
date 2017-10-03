class Arena < ApplicationRecord

  belongs_to :player_1, class_name: Character, optional: true
  belongs_to :player_2, class_name: Character, optional: true

  include FightLoggerHelper

  def fight
    FightLoggerHelper.reset_log
    p1, p2 = player_1, player_2
    return if p1 == p2
    winner = nil
    [p1, p2].each(&:prepare_for_fight)
    fight_log("#{p1} VS #{p2}")
    loop do
      if p1.is_stun
        winner = p2.try_hit(p1)
      elsif p2.is_stun
        winner = p1.try_hit(p2)
      elsif p1.speed.to_f / ((p1.speed + p2.speed) || 0.01) - rand > 0
        winner = p1.try_hit(p2)
      else
        winner = p2.try_hit(p1)
      end
      break if winner
    end
    [p1, p2].each { |p| p.save! && p.stat.save }
    winner
  end

end
