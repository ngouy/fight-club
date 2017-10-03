class Gear < ApplicationRecord

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    [
      :power,
      :given_speed,
      :given_strength,
      :given_agility,
      :given_max_hp,
    ].each { |carac| self[carac] ||= 0 }
  end

  def build_for(char)
    CharacterGear.create!(character: char, gear: self)
  end

  def use
    print("use #{self.type}")
  end

end
