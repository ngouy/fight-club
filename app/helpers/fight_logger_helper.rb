module FightLoggerHelper
  def fight_log(to_log)
    @@_logs ||= []
    # Rails.logger.debug(to_log)
    @@_logs.push(to_log)
  end

  def self.get_log
    @@_logs ||= []
    @@_logs.join("\n")
  end

  def self.reset_log
    @@_logs = []
  end

end
