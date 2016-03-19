require './settings.rb'
require './Auth.rb'
require 'yaml'
require 'bundler'
Bundler.require

unless File.exist? './.tw_config'
  auth = Auth.new Consumer_key, Consumer_secret
  puts "Go: #{auth.authorize_url}"
  print 'Please enter a PIN: '
  auth.pin gets.to_i
  tokens = {:access_token=>auth.access_token,:access_token_secret=>auth.access_token_secret}
  File.open './.tw_config','w' do |f|
    f.print YAML.dump tokens
  end
end
if File.exist? './.tw_config'
  tokens = YAML.load_file('./.tw_config')
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = Consumer_key
  config.consumer_secret     = Consumer_secret
  config.access_token        = tokens[:access_token]
  config.access_token_secret = tokens[:access_token_secret]
end

my_id = client.user.id

begin
  friends = []
  client.friend_ids().each_slice(100).each do |slice|
    client.users(slice).each do |friend|
      friends << friend
    end
  end
  followers = []
  client.follower_ids().each_slice(100).each do |slice|
    client.users(slice).each do |follower|
      followers << follower
    end
  end
  mutual = (friends & followers)
  if File.exist?('./followers.yml') && File.exist?('./mutual.yml')
    prev_followers = YAML.load_file('./followers.yml')
    prev_mutual = YAML.load_file('./mutual.yml')


    # ブロックされた（した）可能性
    blocked = (prev_mutual - mutual )
    if blocked.size > 0
      str = ''
      str = str + "ブロックされた（した）可能性あり\n"
      blocked.each do |i|
        str = str + "@#{i.screen_name} (#{i.id}) #{i.name}\n"
      end
      File.open(Log_path,"a") do |file|
        file.puts "#{Time.now.to_s} #{str}"
      end
      client.create_direct_message my_id, "ブロック検出: #{blocked.size}\n" + str

    end

    # 新たなフォロワー
    newfollowers = ( (followers - prev_followers) & followers )
    if newfollowers.size > 0
      str = ''
      str = str + "新たなフォロワー\n"
      newfollowers.each do |i|
        str = str + "@#{i.screen_name} (#{i.id}) #{i.name}\n"
      end
      File.open(Log_path,"a") do |file|
        file.puts "#{Time.now.to_s} #{str}"
      end
      client.create_direct_message my_id, "新たなフォロワー: #{newfollowers.size}\n" + str
    end

    # 消えたフォロワー
    gone = []
    ( (prev_followers - followers) ).each do |i|
      followers.include?(i)
      unless followers.include?(i)
        gone << i
      end
    end
    if gone.size > 0
      str = ''
      str = str + "消えたフォロワー\n"
      gone.each do |i|
        str = str + "@#{i.screen_name} (#{i.id}) #{i.name}\n"
      end
      File.open(Log_path,"a") do |file|
        file.puts "#{Time.now.to_s} #{str}"
      end
      client.create_direct_message my_id, "消えたフォロワー: #{gone.size}\n" + str
    end

  end

  ##
  File.open './followers.yml','w' do |f|
    f.print YAML.dump followers
  end
  File.open './mutual.yml','w' do |f|
    f.print YAML.dump mutual
  end

rescue =>e
  puts e
end