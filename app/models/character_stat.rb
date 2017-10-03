class CharacterStat < ApplicationRecord
  belongs_to :character

  def add_count(stat)
    key = "count_#{stat}".to_sym
    self[key] += 1
  end

  def add_max(stat, value)
    key = "max_#{stat}".to_sym
    self[key] = value if value  > self[key]
  end

  def add_total(stat, value)
    key = "total_#{stat}".to_sym
    self[key] += value
  end
end
