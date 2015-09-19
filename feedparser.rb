require 'feedjira'
require 'open-uri'
load 'naminginterpreter.rb'

class FeedParser

	def initialize (feedURL, animeFeedURL)
		@feedURL = feedURL
		@animeFeedURL = animeFeedURL
	end

	def fetchShanaRSS	
		cleanedName = true # Does not contain . - and has spaces
		anime = true
		interpreter = NamingInterpreter.new(cleanedName, anime)
		feed = Feedjira::Feed.fetch_and_parse @animeFeedURL
		$log.debug "Fetching all entries from feed"
		arr = []
		feed.entries.each do |entrie|
				$log.debug "Entry: #{entrie.summary}"
				release = interpreter.read(entrie.summary)
				$log.debug "Interpreted values: #{release}"
				release[:link] = entrie.url
				release[:entryID] = entrie.entry_id
				arr.push(release)
		end
		
		arr.each do |feed|
			if FeedItem.first(:entryID => feed[:entryID]).nil?
				$log.debug "#RSS Feed EntryID #{feed[:entryID]} is not in database, saving to database!"
				feedItem = FeedItem.new
				feedItem.attributes = {
					:name => feed[:name],
					:episodeName => feed[:episodeName],
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
					:type => "Anime",
					:timestamp => Time.now
				}
				feedItem.save!
			end
		end
	end

	def fetchShowRSS
				anime = false
		cleanedName = true # Does not contain . - and has spaces
		interpreter = NamingInterpreter.new(cleanedName, anime)
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
					:episodeName => feed[:episodeName],
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
					:type => "Show",
					:timestamp => Time.now
				}
				feedItem.save!
			end
		end
	end

	def fetch
		fetchShowRSS
		fetchShanaRSS		
	end

	def uploadTorrent (torrentClient, config)
		$log.debug "Checking if torrents should be uploaded to transmission at #{config.transmissionURL}"
		FeedItem.each do |item|
			if !item.prossesed
				if item.type == "Show"
				wantedPath = "#{config.tvShowsPath}/#{item.name}"
				end	
				if item.type == "Anime"
				wantedPath = "#{config.animePath}/#{item.name}"
				end
				$log.debug "--Show path will be: #{wantedPath}"

						if item.type == "Show"
							downloadDir = "#{config.tvShowsPath}/#{item.name}/Season #{item.season}"
						end	
						if item.type == "Anime"
							downloadDir = "#{config.animePath}/#{item.name}"
						end	
						$log.debug "----Download path will be: #{downloadDir}"
						$log.debug "----Sending torrent to transmission"
						if item.link.include? "magnet"
							torrentClient.addMagnet(item.link, downloadDir)
						end
						if item.link.include? "http"
							file = downloadFile(item.link,config)
							if file != nil
								torrentClient.add_file(file, downloadDir)
							end
						end
						
						item.prossesed = true
						item.save!
				end
		end
	end

	def downloadFile(link, config)
		fail = false
		begin
		download = open("#{link}")
		rescue OpenURI::HTTPError => error
			response = error.io
			response.status
			response.string
			fail = true
			return nil
		end
		if !fail
		IO.copy_stream(download, "#{config.torrentDir}/temp.torrent")
		file = File.open("#{config.torrentDir}/temp.torrent")
		return file
		end
	end
end
