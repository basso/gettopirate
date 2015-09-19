class Config
		attr_accessor :transmissionURL,:transmissionPort,:transmissionUser,:transmissionPassword,:tvShowsPath, :logging, :loggingPath, :databasePath, :showrssFeed, :shanaFeed, :animePath, :torrentDir

		def initialize(transmissionURL,transmissionPort,transmissionUser,transmissionPassword,tvShowsPath,logging,loggingPath,databasePath,showrssFeed,shanaFeed,animePath,torrentDir)
			@transmissionURL = transmissionURL
			@transmissionPort = transmissionPort
			@transmissionUser = transmissionUser
			@transmissionPassword = transmissionPassword
			@tvShowsPath = tvShowsPath
			@animePath = animePath
			@logging = logging
			@loggingPath = loggingPath
			@databasePath = databasePath
			@showrssFeed = showrssFeed
			@shanaFeed = shanaFeed
			@torrentDir = torrentDir
		end

		def transmission
			return { host: transmissionURL, port: transmissionPort, user: transmissionUser, pass: transmissionPassword, path: "/transmission/rpc" }
		end

		def getLoggingType
			if @logging == ":debug"
				return :debug
			end
		end
end
