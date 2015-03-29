class ChannelManager
  def subscribe(channel, user, socket)
    @channels ||= {}
    @channels[channel] ||= {}
    if @channels[channel][user]
      @channels[channel].delete user
    end
    @channels[channel][user] = socket
    @users ||= {}
    @users[user] ||= []
    @users[user]<< channel
  end

  def get_channel(channel)
    @channels && @channels[channel]
  end

  def get_channel_user(channel, user)
    c = get_channel(channel)
    c && c[user]
  end

  def unsubscribe(channel, user)
    c = get_channel(channel)
    c.delete user if c
    c = user_channels(user)
    c.delete channel if c
    unregister_bot? channel
  end

  def user_channels(user)
    @users && @users[user]
  end

  def user_in_channel?(user, channel)
    c = user_channels(user)
    return false unless c
    c.include? channel
  end

  def send_channel_user(channel, user, data)
    u = get_channel_user(channel, user)
    u.send data if u
  end

  def send_channel(channel, data)
    c = get_channel(channel)
    c.each do |_, s|
      s.send data
    end if c
  end

  def bot_registered?(channel)
    @bots && @bots[channel]
  end

  def register_bot?(channel, bot)
    c = get_channel(channel)
    if c && !c.empty? && !bot_registered?(bot)
      @bots ||= {}
      @bots[channel] = bot
    end
  end

  def unregister_bot?(channel)
    c = get_channel(channel)
    if c && c.empty? && bot_registered?(channel)
      @bots[channel].exit
      @bots.delete(channel)
    end
  end
end