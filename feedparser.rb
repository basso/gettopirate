require 'feedjira'
load 'naminginterpreter.rb'

class FeedParser

	def initialize (feedURL)
		@feedURL = feedURL
	end

	def fetch
		cleanedName = true # Does not contain . - and has spaces
		interpreter = NamingInterpreter.new(cleanedName)
		feed = Feedjira::Feed.fetch_and_parse @feedURL
		arr = []	
		feed.entries.each do |entrie|
			if !entrie.title.include? "WEB DL"
				release = interpreter.read(entrie.title)
				release[:link] = entrie.url
				release[:entryID] = entrie.entry_id
				arr.push(release)
			end
		end
		
		arr.each do |feed|
			if FeedItem.first(:entryID => feed[:entryID]).nil?
				feedItem = FeedItem.new
				feedItem.attributes = {
					:name => feed[:name],
					:season => feed[:season],
					:episode => feed[:episode],
					:source => feed[:source],
					:quality => feed[:quality],
					:codec => feed[:codec],
					:releaser => feed[:releaser],
					:proper => feed[:proper],
					:repack => feed[:repack],
					:link => feed[:link],
					:prossesed => false,
					:entryID => feed[:entryID],
					:timestamp => Time.now
				}
				feedItem.save!
			end
		end
	end

	def uploadTorrent (tvdb, torrentClient, config)
		FeedItem.each do |item|
			if !item.prossesed
				binding.pry
				search = tvdb.search(item.name).first
				result = tvdb.get_series_by_id(search["seriesid"])
				wantedPath = "#{config.tvShowsPath}/#{result.name}"
					if Show.first(:name => result.name).nil?
						puts "#{item.name} is not in the database so has no directory"
						puts "Suggested download path will be = #{config.tvShowsPath}/#{result.name}/Season #{item.season}"
						downloadDir = "#{config.tvShowsPath}/#{result.name}/Season #{item.season}"
						torrentClient.addMagnet(item.link, downloadDir)
						item.prossesed = true
						item.save!
					end
					if !Show.first(:name => result.name).nil?
						puts "The show #{item.name} is in database"
						if Show.first(:name => result.name).episodes(:season => item.season, :episode => item.episode).empty?
							puts "#{item.name} Season #{item.season} Episode #{item.episode} is not in database"
							puts "Suggested download path will be = #{Show.first(:name => result.name).path}/Season #{item.season}"
							torrentClient.addMagnet(item.link, downloadDir)
							item.prossesed = true
							item.save!
						end
					end
				end
		end
	end
end
