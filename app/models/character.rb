class Character < ApplicationRecord

  include FightLoggerHelper

  has_many :character_gears
  has_one  :character_stat
  [
    :helmet,
    :shield,
    :boot,
    :chest,
    :weapon,
  ].each do |gear|
    has_one gear, -> { joins(:gear).where("type = ? AND equiped = true", gear.to_s.capitalize) }, class_name: 'CharacterGear'
  end

  alias :stat :character_stat

  has_attached_file :profile_pic,
    url:         "/system/:class/:attachment/:id/:style.png",
    default_url: lambda { |a| ActionController::Base.helpers.asset_path("icons/#{rand(10) + 1}.png") }
  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\Z/

  validates :name,
            :carac_points_to_spend,
            :max_hp,
            :speed,
            :strength,
            :agility,
            :lvl,
            :xp,
            :gold,
            :prev_lvl_xp,
            :next_lvl_xp,
            :gold,
            :current_hp,
            :current_max_hp,
            :description,
            presence: true

  validates :name, uniqueness: true

  after_initialize :set_defaults, unless: :persisted?
  after_create do
    CharacterStat.create!(character: self)
  end

  [:strength, :speed, :agility, :max_hp].each do |carac|
    define_method(carac) do
      [:helmet, :shield,  :chest, :weapon].map do |gear|
        send(gear.to_s).try(:send, "given_#{carac}") || 0
      end.reduce(self[carac], :+)
    end
  end

  def set_defaults
    {
      carac_points_to_spend: 10,
      max_hp:                50,
      speed:                 2,
      strength:              2,
      agility:               2,
      lvl:                   1,
      xp:                    0,
      gold:                  20,
      prev_lvl_xp:           1,
      next_lvl_xp:           30,
      current_hp:            0,
      current_max_hp:        0,
      is_stun:               false,
      name:                  get_random_name,
      description:           Faker::MostInterestingManInTheWorld.quote
  }.each {|attr, value| self[attr] ||= value }
  end

  def equip(gear)
    return if gear.character_id != self.id
    _equiped_gear = send(gear.type.downcase)
    _equiped_gear.update_attributes(:equiped, false)
    gear.update_attributes(:equiped, true)
  end

  def buy(gear)
    return if gear.price > gold
    return if self.character_gears.where(gear_id: gear.id)
    self.gold -= gear.price
    gear.build_for(self)
    new_gear = save!
    equip(new_gear) unless send(gear.type.downcase)
    new_gear
  end

  def get_random_name
    name = ""
    loop do
      name = [Faker::LeagueOfLegends.champion, Faker::HarryPotter.character, Faker::LordOfTheRings.character].sample
      break if Character.where(name: name).first.nil?
    end
    name
  end

  def prepare_for_fight
    self.current_max_hp = max_hp
    self.current_hp = max_hp
    self.save!
  end

  def spend_caracs_points(params)
    [:max_hp, :strength, :speed, :agility].each do |carac|
      _spend_carac_points(carac, [params[carac] || 0, carac_points_to_spend].min)
    end
    save!
  end

  def random_spend_caracs_points
    carac_points_to_spend.times do
      _spend_carac_points([:max_hp, :strength, :speed, :agility].sample)
    end
    save!
  end

  def loss_shield(dmg, enemy)
    left_dmg = dmg
    [
      :helmet,
      :shield,
    ].each do |gear|
      if self.try gear
        left_dmg = self.call(gear).use(left_dmg)
      end
    end
    damaged = dmg - left_dmg
    enemy.stat.add_total(:armor_hitten, damaged)
    stat.add_total(:armor_loss, damaged)
    damaged
  end

  def loss_hp(dmg, enemy)
    self.current_hp -= dmg
    self.current_max_hp -= (dmg * 0.10).to_i
    fight_log("#{self} lost #{dmg} hp from #{enemy}!")
    enemy.stat.add_total(:hp_hitten, dmg)
    stat.add_total(:hp_loss, dmg)
    dmg
  end

  def get_hit(enemy, dodged, crit, weapon)
    dmg = (enemy.weapon.try(:use) || enemy.lvl * 2)
    dmg = dmg * enemy.strength * 0.1 if enemy.strength > 0
    dmg = dmg * 1.1 if crit
    dmg = dmg.ceil
    if (dodged)
      stat.add_total(:dodged_amount, dmg)
      enemy.stat.add_total(:miss_amount, dmg)
      fight_log("#{self} dodged #{enemy} from #{dmg} damage")
    else
      fight_log("#{enemy} crit on #{self} !") if crit
      enemy.stat.add_max(crit ? :crit : :hit, dmg)
      shiled_dmg = loss_shield(dmg, enemy)
      chest.try(:use) if shiled_dmg == 0 && dmg
      loss_hp(dmg - shiled_dmg, enemy)
    end

  end

  def try_dodge(enemy)
    did_dodge = rand < (agility.to_f / (enemy.agility + agility) * 0.8)
    if did_dodge
      stat.add_count(:dodge)
      enemy.stat.add_count(:missed)
    end
    did_dodge
  end

  def win_xp(amount)
    self.xp += amount
    stat.add_max(:one_time_xp, amount)
    if xp >= next_lvl_xp
      old_prev_lvl_xp = prev_lvl_xp
      self.lvl += 1
      self.max_hp += 10
      self.carac_points_to_spend += 5
      fight_log("#{self} LVL UP !!! now lvl #{self.lvl}")
      self.prev_lvl_xp = next_lvl_xp
      self.next_lvl_xp = next_lvl_xp * Math.sqrt(next_lvl_xp - old_prev_lvl_xp)
      win_gold(lvl * 100)
    end
  end

  def win_gold(amount)
    self.gold += amount
    stat.add_max(:one_time_gold, amount)
    stat.add_max(:gold, gold)
  end


  def win(enemy)
    enemy.stat.add_count(:loose)
    stat.add_count(:win)
    fight_log("#{enemy} get rekt by #{self}")
    current_lvl = self.lvl         # needed if lvl up
    current_enemy_lvl = enemy.lvl  #
    win_xp((current_enemy_lvl.to_f / current_lvl * current_lvl * 30).to_i)
    win_gold((current_enemy_lvl.to_f / current_lvl * current_lvl * 10).to_i)
    enemy.win_xp((current_lvl.to_f / current_enemy_lvl * current_enemy_lvl * 10).to_i)
    enemy.win_gold((current_lvl.to_f / current_enemy_lvl  * current_enemy_lvl).to_i)
  end

  def try_hit(enemy)
    fight_log("#{self} engaged #{enemy}")
    self.boot.try(:use)
    did_crit = _try_crit(enemy)
    dodged = !did_crit && enemy.try_dodge(self)
    enemy.get_hit(self, dodged, did_crit, weapon)
    if (enemy.current_hp <= 0)
      win(enemy)
      return self
    # not used yet bc no dmg return and no spells
    elsif (current_hp <= 0)
      enemy.win(self)
      return enemy
    end
    _try_stun(enemy)
    enemy.save!
    save!
    nil
  end

  def to_s
    name
  end

  private

  def _try_stun(enemy)
    did_stun = (strength.to_f / ((enemy.strength + strength) || 0.01)) - 0.10 - rand > 0
    if did_stun
      stat.add_count(:stuns)
      enemy.stat.add_count(:get_stuned)
      enemy.is_stun = true
      fight_log("#{self} stuned #{enemy}")
    end
    did_stun
  end

  def _try_crit(enemy)
    did_crit = (0.10 + agility.to_f / 1000 - rand) > 0
    did_crit && stat.add_count(:crit)
  end

  def _spend_carac_points(carac, points=1)
    self[carac] += carac != :max_hp ? points : points * 2
    self.carac_points_to_spend -= points
  end

end
