class TransmissionClient
	def initialize (config)
		Trans::Api::Client.config = config
	end

	def addMagnet(magnet, dir)
		options = { "download-dir" => dir}
		Trans::Api::Torrent.add_magnet magnet, options
	end

	def add_file(file, dir)
		options = { "download-dir" => dir}
		file_name = File.basename(file, ".*")
		base64_file_contents = Base64.encode64 file.read
		Trans::Api::Torrent.add_metainfo base64_file_contents, file_name, options
	end
end
