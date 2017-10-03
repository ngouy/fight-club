class CharacterGear < ApplicationRecord

  belongs_to :gear
  belongs_to :character

  [
    :description,
    :name,
    :lvl,
    :price,
    :given_hp,
    :given_speed,
    :given_agility,
    :given_strength,
    :capacity,
    :created_at,
    :updated_at,
    :type,
  ].each do |gear_attr|
    define_method(gear_attr) do
      gear[gear_attr]
    end
  end

  def initialize(params={})
    super
    self.capacity_left = capacity
  end

  def use(ammount=1)
    used = [capacity_left, ammount].min
    update_attributes(capacity_left: capacity_left - used)
    used = gear.try(:use) || used
    if (max_capacity <= 0)
      self.destroy
      character.stat.gear_destroyed += 1
      character.stat.save!
    end
    used
  end

  def repair
    repair_capacity = [character.gold, self.lvl * (capacity_left - capacity)].min
    character.gold -= repair_capacity
    character.save!
    self.capacity_left += repair_capacity / self.lvl
  end

end
