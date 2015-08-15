class NamingInterpreter
	def initialize (cleaned)
		@cleaned = cleaned
	end

	def read(name)
		if @cleaned
			words = name.split(' ')
			deleteEpisodeTitle(words)
			season, episode = findSeasonAndEpisode(words)
			quality = findQuality(words)
			codec = findCodec(words)
			releaser = findRelease(words)
			source = findSource(words)
			proper = findProper(words)
			repack = findRepack(words)
			real = findReal(words)
			name = findName(words)
			result = {:name=>name,:season=>season,:episode=>episode,:source=>source,:quality=>quality,:codec=>codec,:releaser=>releaser,:proper=>proper,:repack=>repack,:real=>real,:link => nil,:entryID=>nil}
			
			#FUCKING RUBY BUG
			if result[:proper].kind_of?(Array)
				result[:proper] = false
			end
			if result[:repack].kind_of?(Array)
				result[:repack] = false
			end
			if result[:quality].kind_of?(Array)
				result[:quality] = nil
			end
			if result[:real].kind_of?(Array)
				result[:real] = nil
			end

			return result		
		end
	end

	def deleteEpisodeTitle(words)
		ep = ""
		qu = ""
		words.each do |word|
			if word.upcase.start_with?('S') && word[3] == 'E' && word =~ /\d/
				ep = word
			end

			if word.downcase === "720p" || word === "1080p"
				qu = word
			end	
		end
		
		hash = Hash[words.map.with_index.to_a]
		wordsToDelete = words.slice(hash[ep]+1,hash[qu]-2)
		
		wordsToDelete.each do |word|
			words.delete(word)
		end
	end
	
	def findSeasonAndEpisode(words)
		words.each do |word|
			if word.upcase.start_with?('S') && word[3] == 'E' && word =~ /\d/
				season = word[1,2].to_i
				episode = word[4,5].to_i
				words.delete(word)
				return season, episode
			end
		end
	end

	def findQuality(words)
		words.each do |word|
			if word.downcase === "720p" || word === "1080p"
				quality = word
				words.delete(word)
				return quality
			end
		end
	end

	def findCodec(words)
		words.each do |word|
			if word.downcase === "xvid" || word.downcase === "x264"
				codec = word
				words.delete(word)
				return codec
			end
		end
	end

	def findRelease(words)
		releaser = words.last
		words.delete(words.last)
		return releaser
	end

	def findProper(words)
		words.each do |word|
			if word.downcase === 'proper'
				proper = word
				words.delete(word)
				return true
			end
		end
	end


	def findRepack(words)
		words.each do |word|
			if word.downcase === 'repack'
				repack = word
				words.delete(word)
				return true
			end
		end
	end
	
	def findReal(words)
		words.each do |word|
			if word.downcase === 'real'
				real = word
				words.delete(word)
				return true
			end
		end
	end

	def findSource(words)
		words.each do |word|
			if word.downcase === "pdtv" || word.downcase === "hdtv"
				source = word
				words.delete(word)
				return source
			end
		end
	end

	def findName(words)
		name = words.join(" ")
		return name
	end

end
