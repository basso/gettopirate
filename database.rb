class Database

	def initialize (databasePath, inMemory, displayLogs)
		@databasePath = databasePath
		@inMemory = inMemory
		@displayLogs = displayLogs
	
		if displayLogs
			DataMapper::Logger.new($stdout, :debug)
		end
		
		if inMemory
			DataMapper.setup(:default, 'sqlite::memory:')
		else
			DataMapper.setup(:default, "sqlite:#{databasePath}")
		end
	
		load 'models.rb'
		DataMapper.finalize
		DataMapper.auto_upgrade!
	end

end
