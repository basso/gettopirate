class LibraryParser
	def initialize (path)
		@path = path
	end

	def importFromDisk
		directories = Dir.entries(@path)	
		#Clean up some shit
		directories.each do |dir|
			if dir[0] == "."
				directories.delete(dir)
			end
		end
		
		directories.each do |dir|
			if Show.first(:dirName => dir).nil?
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
				traverse(showPath, episodes)
				
				episodes.each do |ep|
					# If filename does not exist in database run import code
					if show.episodes.first(:filename => ep[:filename]).nil?
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
		else
			if x.downcase["sample"]
				next
			end
			if x.downcase["._"]
				next
			end
			if x.downcase[".mkv"] || x.downcase[".avi"] || x.downcase[".mp4"] && !x.downcase[".part"]	
				episode = {:filename => x, :path => path}

				array.push(episode)
			end
		end
	end
end

	def importShowInformation (tvdb)
		Show.each do |show|
			if show.name.nil? || show.remoteID.nil? || show.overview.nil? 
				id = tvdb.search(show.dirName).first
				result = tvdb.get_series_by_id(id["seriesid"])
				show.name = result.name
				show.remoteID = result.id
				show.overview = result.overview
				show.save!
			end
		end
	end
	
	def importEpisodeInformation (tvdb)
		Show.each do |show|
		  show.episodes.each do |episode|
				if episode.name.nil? || episode.overview.nil?
					showresult = tvdb.get_series_by_id(show.remoteID)
					seasonNumber, episodeNumber = findSeasonAndEpisode(episode.filename)
					result = showresult.get_episode(seasonNumber,episodeNumber)
					episode.name = result.name
					episode.overview = result.overview
					episode.season = result.season_number
					episode.episode = result.number
					episode.save!
				end
			end
		end
	end

	# This is why you have everything in a fucking database
	# All that fucking parsing work
	# Look how fucking sexy this is
	def cleanDeletedShows
		Show.each do |show|
			if !File.directory? show.path
				show.destroy
			end
		end
	end
	
	def cleanDeletedEpisodes
		Episode.each do |episode|
			if !File.exist? episode.path
				episode.destroy
			end
		end
	end
end
