# gettopirate
Full of bugs, does not work yet fully yet

## What does decode
Show Name S05E08 720p HDTV x264 KILLERS

## What does not decode
###Show.Name.S05E08.720p.HDTV.x264.KILLERS
need to implement clean filter
###Show.Name.S05E08.Episode.Name.720p.HDTV.x264.KILLERS
need to implement episode name remover if more than 0 words between S05E08 and 720p
### SD
Don't care about SD releases

## What is ignored
### WEB DL
Not sure what standard they follow
### Anime
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
