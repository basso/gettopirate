# pump bundler
require 'rubygems'
require 'bundler/setup'
# require your gems as usual
require 'data_mapper'
require 'pry'
require 'json'
require 'awesome_print'
require 'tvdb_party'
require 'trans-api'
require 'logging'
# load class files
load 'config.rb'
load 'database.rb'
load 'feedparser.rb'
load 'libraryparser.rb'
load 'transmissionclient.rb'

configFile = File.read('config.json')
configData = JSON.parse(configFile)
config = Config.new(configData['tvdbApiKey'], configData['transmissionURL'], configData['transmissionPort'], configData['transmissionUser'], configData['transmissionPassword'],configData['tvShowsPath'],configData['logging'],configData['loggingPath'],configData['databasePath'], configData['showrssFeed'])
$log = Logging.logger['gettopirate_logger']
$log.level = config.getLoggingType
$log.add_appenders \
	Logging.appenders.stdout,
	Logging.appenders.file(config.loggingPath)

$log.debug "Startup #{Time.now}"

db = Database.new(config.databasePath,false,false)
tvdb = TvdbParty::Search.new(config.tvdbApiKey)
torrentClient = TransmissionClient.new(config.transmission)

feedparser = FeedParser.new(config.showrssFeed)
$log.debug "Feed is #{config.showrssFeed}"
feedparser.fetch
library = LibraryParser.new(config.tvShowsPath)
library.importFromDisk
library.importShowInformation(tvdb)
library.importEpisodeInformation(tvdb)
library.cleanDeletedEpisodes
library.cleanDeletedShows

feedparser.uploadTorrent(tvdb, torrentClient, config)

