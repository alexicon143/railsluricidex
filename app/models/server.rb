class Server < ApplicationRecord
  # id
  # friendly_name
  # ip
  # username
  # keyfile
  require_dependency 'ssh'

  has_many :games

  def connect
      @conn ||=SSH.new(self.ip, self.username, keys: [self.keyfile])
      @conn
  end

  def game_stats
    stats = {}
    stats[:num_running] = self.games.select { |g| g.running? }.size
    stats[:num_stopped] = self.games.select { |g| !g.running? }.size
    stats
  end

  def online?
    self.connect.online?
  end

  def uptime
    self.connect.system_uptime
  end
end
