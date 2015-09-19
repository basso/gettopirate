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
- Show Name S05E08 Episode Name No Matter How long 720p HDTV x264 KILLERS
- Some Anime naming scemes, only tested with DeadFish and Horriblesubs

## What does not decode
###Show.Name.S05E08.720p.HDTV.x264.KILLERS
ShowRSS feeds are cleaned
### SD
Don't care about SD releases

## What is ignored
### WEB DL
Not sure what standard they follow.

## Logic
- Reads feed, prosseses, decodes name
- Parses ShowRSS Feed (One Feed)
- Parses Shana Feed (One Feed)
- ShowRSS feed: Decodes Series name and season and sets download directory to /Series Path/Show Name/Season X
- Shana-Project feed: Decodes Series name and sets download directory to /Anime Path/Anime Name/

## Points

- this hack is made to live in a crontab
- Does not handle deletion of torrent transfers in Transmission since it randomizes ID's after reboot
- Only handles ShowRSS and Shana Project RSS feed
