class TransmissionClient
	def initialize (config)
		Trans::Api::Client.config = config
	end

	def addMagnet(magnet, dir)
		options = { "download-dir" => dir}
		Trans::Api::Torrent.add_magnet magnet, options
	end
end
