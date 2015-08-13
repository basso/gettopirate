# gettopirate

## Logic
- Reads what tv shows you have, checks with TVDB, adds to local sqlite database
- It does this to get BIG DATA, and set the torrent download path directly to the correct "Showfolder/Seasonumber/"
- Parses ShowRSS Feed (One Feed)
- Decodes scene release naming to pull information about quality, repack, showname, episode/season etc
- Searches TVDB

## Points

- this hack is made to live in a crontab
- Does not handle deletion of torrent transfer in transmission since transmission randomizes ID's after reboot
- Only handles ShowRSS

## Laws 
- Path to TV Shows should only have TV show directories in it
- Directory names should be exact TVDB's show name
- Each show directory needs to have Season under directories: "Season 1, Season 2" etc
- If directory name is renamed, it is deleted in the database and re-scanned on next run
- If episodes are renamed or deleteded, it is deletes it in the database and re-scans on next run
- more to come
