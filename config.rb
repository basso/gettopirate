class Config
		attr_accessor :tvdbApiKey,:transmissionURL,:transmissionPort,:transmissionUser,:transmissionPassword,:tvShowsPath, :logging, :loggingPath, :databasePath, :showrssFeed

		def initialize(tvdbApiKey, transmissionURL,transmissionPort,transmissionUser,transmissionPassword,tvShowsPath,logging,loggingPath,databasePath,showrssFeed)
			@tvdbApiKey = tvdbApiKey
			@transmissionURL = transmissionURL
			@transmissionPort = transmissionPort
			@transmissionUser = transmissionUser
			@transmissionPassword = transmissionPassword
			@tvShowsPath = tvShowsPath
			@logging = logging
			@loggingPath = loggingPath
			@databasePath = databasePath
			@showrssFeed = showrssFeed
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
