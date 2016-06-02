module SapphireBot
  GOOGLE = GoogleServices.new

  BOT = Discordrb::Commands::CommandBot.new(token: CONFIG[:discord_token],
                                            application_id: CONFIG[:discord_client_id],
                                            prefix: CONFIG[:prefix],
                                            advanced_functionality: false)

  STATS = Stats.new

  BOT.bucket(:roasted, delay: 3000)

  BOT.include! Commands::Announce
  BOT.include! Commands::Delete
  BOT.include! Commands::Flip
  BOT.include! Commands::Invite
  BOT.include! Commands::Lmgtfy
  BOT.include! Commands::Roll
  BOT.include! Commands::Stats
  BOT.include! Commands::Ping
  BOT.include! Commands::KickAll
  BOT.include! Commands::About
  BOT.include! Commands::Avatar
  BOT.include! Commands::Eval
  BOT.include! Commands::Toggle
  BOT.include! Commands::Set
  BOT.include! Commands::Default
  BOT.include! Commands::Settings
  BOT.include! Commands::Game
  BOT.include! Commands::Ignore
  BOT.include! Commands::YoutubeSearch

  if CONFIG[:music_BOT]
    BOT.include! MusicBOT::Commands::MusicHelp
    BOT.include! MusicBOT::Commands::Join
    BOT.include! MusicBOT::Commands::Leave
    BOT.include! MusicBOT::Commands::Add
    BOT.include! MusicBOT::Commands::Queue
    BOT.include! MusicBOT::Commands::ClearQueue
    BOT.include! MusicBOT::Commands::Skip
    BOT.include! MusicBOT::Commands::Repeat
  end

  BOT.include! Events::Mention
  BOT.include! Events::MessagesReadStat
  BOT.include! Events::AutoShorten
  BOT.include! Events::MassMessage
  BOT.include! Events::ReadyMessage

  Thread.new do
    loop do
      ServerConfig.save
      sleep(60)
    end
  end

  Thread.new do
    LOGGER.info 'Type exit to safely stop the bot'
    loop do
      next unless gets.chomp.casecmp('exit').zero?
      LOGGER.info 'Exiting...'
      STATS.save
      ServerConfig.save
      MusicBot.delete_files
      exit
    end
  end

  LOGGER.info "Oauth url: #{BOT.invite_url}+&permissions=#{CONFIG[:permissions_code]}"
  BOT.run
end
