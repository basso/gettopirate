class Config
		attr_accessor :tvdbApiKey,:transmissionURL,:transmissionPort,:transmissionUser,:transmissionPassword,:tvShowsPath

		def initialize(tvdbApiKey, transmissionURL,transmissionPort,transmissionUser,transmissionPassword,tvShowsPath)
			@tvdbApiKey = tvdbApiKey
			@transmissionURL = transmissionURL
			@transmissionPort = transmissionPort
			@transmissionUser = transmissionUser
			@transmissionPassword = transmissionPassword
			@tvShowsPath = tvShowsPath
		end

		def transmission
			return { host: transmissionURL, port: transmissionPort, user: transmissionUser, pass: transmissionPassword, path: "/transmission/rpc" }
		end
end
