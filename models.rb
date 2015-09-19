class FeedItem
	include DataMapper::Resource
	
	property :id, 				Serial
	property :entryID, 		String
	property :name, 			String
	property :type, 			String
	property :episodeName, String
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
