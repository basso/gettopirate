class Show
 	include DataMapper::Resource
	has n, :episodes
	
	property :id, 				Serial
	property :name, 			String
	property :remoteID, 	Integer
	property :overview, 	String
	property :dirName, 		String
	property :path, 			String
	property :timestamp, 	DateTime
end

class Episode
	include DataMapper::Resource
	belongs_to :show

	property :id, 				Serial
	property :name, 			String
	property :overview, 	String
	property :episode, 		Integer
	property :season, 		Integer
	property :filename, 	String
	property :path, 			String
	property :timestamp, 	DateTime
end

class FeedItem
	include DataMapper::Resource

	property :id, 				Serial
	property :entryID, 		String
	property :name, 			String
	property :season, 		Integer
	property :episode, 		Integer
	property :source, 		String
	property :quality, 		String
	property :codec, 			String
	property :releaser, 	String
	property :proper, 		Boolean
	property :repack, 		Boolean
	property :real, 			Boolean
	property :link, 			String
	property :prossesed, 	Boolean
	property :timestamp, 	DateTime
end

class File
	include DataMapper::Resource

	property :id, 						Serial
	property :showfolder, 		String
	property :seasonfolder, 	String
	property :episodefolder, 	String
	property :filename, 			String
	property :timestamp, 			DateTime
end
