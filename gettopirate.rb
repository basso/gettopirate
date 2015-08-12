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
# load class files
load 'config.rb'
load 'database.rb'
load 'feedparser.rb'
load 'libraryparser.rb'
load 'transmissionclient.rb'

configFile = File.read('config.json')
configData = JSON.parse(configFile)
config = Config.new(configData['tvdbApiKey'], configData['transmissionURL'], configData['transmissionPort'], configData['transmissionUser'], configData['transmissionPassword'],configData['tvShowsPath'])

db = Database.new('test.db',false,false)
tvdb = TvdbParty::Search.new(config.tvdbApiKey)
torrentClient = TransmissionClient.new(config.transmission)
feedparser = FeedParser.new('')
feedparser.fetch

library = LibraryParser.new(config.tvShowsPath)
library.importFromDisk
library.importShowInformation(tvdb)
library.importEpisodeInformation(tvdb)
library.cleanDeletedEpisodes
library.cleanDeletedShows

feedparser.uploadTorrent(tvdb, torrentClient, config)
