class LibraryParser
	def initialize (path)
		@path = path
	end

	def importFromDisk
		$log.debug "Starting import from disk at: #{@path}"
		directories = Dir.entries(@path)
		#Clean up some shit
		directories.each do |dir|
			if dir[0] == "."
				directories.delete(dir)
			end
		end
		$log.debug "All directories: #{directories}"
		
		directories.each do |dir|
			if Show.first(:dirName => dir).nil?
				$log.debug "#{dir} is not in Show Database, adding to database"
				show = Show.new(
								:dirName => dir, 
								:path => "#{@path}/#{dir}", 
								:timestamp => Time.now
								)
				show.save!
			end
				show = Show.first(:dirName => dir)
				showPath = "#{@path}/#{dir}"
				episodes = []
				$log.debug "Traversing #{showPath}"
				traverse(showPath, episodes)
				
				episodes.each do |ep|
					# If filename does not exist in database run import code
					if show.episodes.first(:filename => ep[:filename]).nil?
						$log.debug "#{ep[:filename]} is not in database, saving!"
						newepisode = Episode.new(
													:filename => ep[:filename], 
													:path => ep[:path], 
													:timestamp => Time.now
													)
						show.episodes << newepisode
						show.episodes.save!
					end
				end
		end
	end

def findSeasonAndEpisode(file)
	filename = file
	if filename.include? "."
		filename = filename.gsub! '.',' '
	end

	if filename.include? "-"
		filename = filename.gsub! '-',' '
	end
		words = filename.split(' ')
		words.each do |word|
			if word.upcase.start_with?('S') && word[3].upcase == 'E' && word =~ /\d/
				season = word[1,2].to_i
				episode = word[4,5].to_i
				return season, episode
			end
			if word.upcase.start_with?('S') && word[2].upcase == 'E' && word =~ /\d/
				season = word[1,1].to_i
				episode = word[3,4].to_i
				return season, episode
			end
		end
end

def traverse(start, array)
	Dir.foreach(start) do |x|
		path = File.join(start, x)
		if x == "." or x == ".."
			next
		elsif File.directory?(path)
			traverse(path, array)
				$log.debug "--#{path} is folder, going deeper"
		else
			if x.downcase["sample"]
				next
			end
			if x.downcase["._"]
				next
			end
			if x.downcase[".mkv"] || x.downcase[".avi"] || x.downcase[".mp4"] && !x.downcase[".part"]	
				episode = {:filename => x, :path => path}
				$log.debug "----#{x}"
				array.push(episode)
			end
		end
	end
end

	def importShowInformation (tvdb)
		$log.debug "Starting import of show information"
		Show.each do |show|
			if show.name.nil? || show.remoteID.nil? || show.overview.nil? 
				$log.debug "Directory name: #{show.dirName} does not have TVDB information"
				id = tvdb.search(show.dirName).first
				result = tvdb.get_series_by_id(id["seriesid"])
				$log.debug "TVDB result: #{result.name}, saving!"
				show.name = result.name
				show.remoteID = result.id
				show.overview = result.overview
				show.save!
			end
		end
	end

	# OH GOD WHAT HAVE I DONE
	def importEpisodeInformation (tvdb)
		$log.debug "Starting import of episode information"
		Show.each do |show|
			$log.debug "--#{show.name}"
		  show.episodes.each do |episode|
				if episode.name.nil?
					$log.debug "----#{episode.filename} does not have TVDB information"
					showresult = tvdb.get_series_by_id(show.remoteID)
					seasonNumber, episodeNumber = findSeasonAndEpisode(episode.filename)
					$log.debug "----Interpreted result: Season #{seasonNumber}, Episode #{episodeNumber}"
					result = showresult.get_episode(seasonNumber,episodeNumber)
					
					if result.nil?
						$log.debug "---- NO TVDB result: #{episode.filename}, trying with episode title from Feed"
						feeditem = FeedItem.first(:name => showresult.name, :episode => episodeNumber, :season => seasonNumber)
						if feeditem.nil?
							$log.debug "------#{episode.filename} not in feed"
						else
							tvdbEpisodes = tvdb.get_all_episodes(showresult)
							searchArray = feeditem.episodeName.downcase.gsub(/[^0-9a-z ]/i, '').split(" ")
							tvdbEpisodes.each do |ep|
								episodeArray = ep.name.downcase.gsub(/[^0-9a-z ]/i, '').split(" ")
								searchResult = (episodeArray - searchArray)
								if searchResult.count < 1
									$log.debug "------Found episode with feeditem!"
									$log.debug "------TVDB result: #{ep.name}, saving!"
									episode.name = ep.name
				        	episode.overview = ep.overview
									episode.season = ep.season_number
									episode.episode = ep.number
								  episode.save!
								end
							end
						end
					end
					
					if !result.nil?
						$log.debug "----TVDB result: #{result.name}, saving!"
						episode.name = result.name
						episode.overview = result.overview
						episode.season = result.season_number
						episode.episode = result.number
						episode.save!
					end
				end
			end
		end
	end

	# This is why you have everything in a fucking database
	# All that fucking parsing work
	# Look how fucking sexy this is
	def cleanDeletedShows
		$log.debug "Checking for deleted shows"
		Show.each do |show|
			if !File.directory? show.path
				$log.debug "--Directory #{show.path} is gone, deleting!"
				show.destroy
			end
		end
	end
	
	def cleanDeletedEpisodes
		$log.debug "Checking for deleted episodes"
		Episode.each do |episode|
			if !File.exist? episode.path
				$log.debug "--File #{episode.path} is gone, deleting!"
				episode.destroy
			end
		end
	end
end
