module SapphireBot
  module Commands
    module Lmgtfy
      extend Discordrb::Commands::CommandContainer
      command(:lmgtfy, bucket: :default, min_args: 1,
                       description: 'Generates Let Me Goole That For You link.',
                       usage: 'lmgtfy <text>') do |event, *text|
        event.message.delete if event.bot.profile.on(event.server)
                                     .permission?(:manage_messages,
                                                  event.channel)
        event.bot.shortener.shorten("http://lmgtfy.com/?q=#{text.join('+')}", event.bot)
      end
    end
  end
end
