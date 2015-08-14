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
		$log.debug "Fetching all entries from feed"
		arr = []	
		feed.entries.each do |entrie|
			if !entrie.title.include? "WEB DL"
				$log.debug "Entry: #{entrie.title}"
				release = interpreter.read(entrie.title)
				$log.debug "Interpreted values: #{release}"
				release[:link] = entrie.url
				release[:entryID] = entrie.entry_id
				arr.push(release)
			end
		end
		
		arr.each do |feed|
			if FeedItem.first(:entryID => feed[:entryID]).nil?
				$log.debug "#RSS Feed EntryID #{feed[:entryID]} is not in database, saving to database!"
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
					:real => feed[:real],
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
		$log.debug "Checking if torrents should be uploaded to transmission at #{config.transmissionURL}"
		FeedItem.each do |item|
			
			if !item.prossesed
				search = tvdb.search(item.name).first
				$log.debug "--Searching TVDB for show with #{item.name}"
				result = tvdb.get_series_by_id(search["seriesid"])
				$log.debug "--TVDB result: #{result.name}"
				wantedPath = "#{config.tvShowsPath}/#{result.name}"
				$log.debug "--Show path will be: #{wantedPath}"

					if Show.first(:name => result.name).nil?
						$log.debug "----#{item.name} is not in the database so has no directory"
						downloadDir = "#{config.tvShowsPath}/#{result.name}/Season #{item.season}"
						$log.debug "----Download path will be: #{downloadDir}"
						$log.debug "----Sending torrent to transmission"
						binding.pry
						torrentClient.addMagnet(item.link, downloadDir)
						item.prossesed = true
						item.save!
					end
					if !Show.first(:name => result.name).nil?
						$log.debug "----#{result.name} is in the database"
						if Show.first(:name => result.name).episodes(:season => item.season, :episode => item.episode).empty?
							$log.debug "------#{item.name} Season #{item.season} Episode #{item.episode} is not in database"
							downloadDir = "#{config.tvShowsPath}/#{result.name}/Season #{item.season}"
							$log.debug "----Download path will be: #{downloadDir}"
							$log.debug "----Sending torrent to transmission"
							torrentClient.addMagnet(item.link, downloadDir)
							item.prossesed = true
							item.save!
						else
							$log.debug "----No episode to download"
						end
					end
				end
		end
	end
end
