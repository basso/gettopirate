# pump bundler
require 'rubygems'
require 'bundler/setup'
# require your gems as usual
require 'data_mapper'
require 'pry'
require 'json'
require 'awesome_print'
require 'trans-api'
require 'logging'
# load class files
load 'config.rb'
load 'database.rb'
load 'feedparser.rb'
load 'transmissionclient.rb'

configFile = File.read('config.json')
configData = JSON.parse(configFile)
config = Config.new(configData['transmissionURL'], configData['transmissionPort'], configData['transmissionUser'], configData['transmissionPassword'],configData['tvShowsPath'],configData['logging'],configData['loggingPath'],configData['databasePath'], configData['showrssFeed'], configData['shanaFeed'], configData['animePath'], configData['torrentDir'])
$log = Logging.logger['gettopirate_logger']
$log.level = config.getLoggingType
$log.add_appenders \
	Logging.appenders.stdout,
	Logging.appenders.file(config.loggingPath)

$log.debug "Startup #{Time.now}"

db = Database.new(config.databasePath,false,false)
torrentClient = TransmissionClient.new(config.transmission)
feedparser = FeedParser.new(config.showrssFeed, config.shanaFeed)
$log.debug "ShowRSS Feed is #{config.showrssFeed}"
$log.debug "ShanaRSS Feed is #{config.shanaFeed}"
feedparser.fetch
feedparser.uploadTorrent(torrentClient, config)

