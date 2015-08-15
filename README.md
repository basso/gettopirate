# gettopirate
Full of bugs, might explode at any time
## Install

```
1. Install ruby and bundler.
2. Install transmission on the server

3. Registrer for ShowRSS and add shows
4. Filter shows to only include 720p
5. On feed settings make sure to select RAW 

git clone git@github.com:basso/gettopirate.git
cd gettopirate
bundle install
alter settings in config.json.example and rename to config.json
ruby gettopirate.rb
```

## What does decode
- Only 720p/1080p releases
- Show Name S05E08 720p HDTV x264 KILLERS
- Show.Name.S05E08.Episode.Name.No.Matter.How.long.720p.HDTV.x264.KILLERS

## What does not decode
###Show.Name.S05E08.720p.HDTV.x264.KILLERS
ShowRSS feeds are cleaned
### SD
Don't care about SD releases

## What is ignored
### WEB DL
Not sure what standard they follow.

## Logic
- Reads what tv shows you have (or have deleted), checks with TVDB, adds to local sqlite database
- It does this to get BIG DATA, and set the torrent download path directly to the correct "Showfolder/Seasonumber/"
- Parses ShowRSS Feed (One Feed)
- Decodes scene release naming to pull information about quality, repack, showname, episode/season etc
- Checks if it has the episode, if yes skip
- If not sends torrent to transmission with exact directory to download to

## Points

- this hack is made to live in a crontab
- Does not handle deletion of torrent transfer in Transmission since it randomizes ID's after reboot
- Only handles ShowRSS

## Laws 
- Path to TV Shows should only have TV show directories in it
- Directory names should be exact TVDB's show name
- Each show directory needs to have Season under directories: "Season 1, Season 2" etc
- Episodes must have SxxExx in the title (eg S01E23) to be scanned in library

```
Show Name
--Season 1
----Episode 1 S01E01
```

- If directory name is renamed, it is deleted in the database and re-scanned on next run
- If episodes are renamed or deleteded, it is deletes it in the database and re-scans on next run
- more to come
