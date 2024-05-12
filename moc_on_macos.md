## Moc on MacOS
This is for scenario if you want to play mp3 on MacOS through terminal

### Pre-requisites
```bash
brew install berkeley-db
brew install jack
brew install libmad libid3tag
```
### Configure Jack
check the location of Jack
```bash
ls /usr/local/Cellar/jack
```
```bash
vim ~/Library/LaunchAgents/org.jackaudio.jackd.plist # add below content

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.jackaudio.jackd</string>
    <key>WorkingDirectory</key>
    <string>/Users/shengzhen/</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/Cellar/jack/1.9.22_1/bin/jackd</string>
      <string>-d</string>
      <string>coreaudio</string>
    </array>
    <key>EnableGlobbing</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>


# starting jack in the background
launchctl load ~/Library/LaunchAgents/org.jackaudio.jackd.plist
# or you could also start jack foreground
jackd start coreaudio
# check if jack is running
launchctl list|grep jack
# if you want to remove it, run below
# https://ss64.com/mac/launchctl.html
launchctl unload ~/Library/LaunchAgents/org.jackaudio.jackd.plist
```
### Install Moc on MacOS
```bash
brew install moc
```
### Configure Moc
Create a directory if not exists
```bash
mkdir ~/.moc
# create theme
mkdir ~/.moc/themes
vim ~/.moc/themes/rhowaldt_theme # add below content

background           = default    default
frame                = default    default
window_title         = default    default
directory            = blue       default
selected_directory   = blue       default    reverse
playlist             = default    default
selected_playlist    = default    default    reverse
file                 = default    default
selected_file        = default    default    reverse
marked_file          = blue       default    bold
marked_selected_file = blue       default    reverse
info                 = default    default
selected_info        = default    default
marked_info          = blue       default    bold
marked_selected_info = blue       default    bold
status               = default    default
title                = blue       default    bold
state                = default    default
current_time         = default    default
time_left            = default    default
total_time           = default    default
time_total_frames    = default    default
sound_parameters     = default    default
legend               = default    default
disabled             = default    default
enabled              = blue       default    bold
empty_mixer_bar      = default    default
filled_mixer_bar     = default    default    reverse
empty_time_bar       = default    default
filled_time_bar      = default    default    reverse
entry                = default    default
entry_title          = default    default
error                = default    default    bold
message              = default    default    bold
plist_time           = default    default



vim ~/.moc/config  #  add below content

MusicDir = /Users/shengzhen/Documents/music
StartInMusicDir = yes
SoundDriver = JACK
XTerms = xterm-256color
Theme = rhowaldt_theme
MOCDir = ~/.moc
UseRCC = no

```

That's it run mocp to enjoy the music

### Further work
Bind keyboard shortcuts to control moc player
Check the location of the Moc
```bash
which mocp
/usr/local/bin/mocp
```

1. Right click any file in Finder -> create service -> Run AppleScript (double click) -> edit AppleScript as below 

play/pause: -G
next song : -f
prev song : -r
```bash
on run {input, parameters}
	
	do shell script "/usr/local/bin/mocp -G"
	
	return input
end run

on run {input, parameters}
	
	do shell script "/usr/local/bin/mocp -f"
	
	return input
end run

on run {input, parameters}
	
	do shell script "/usr/local/bin/mocp -r"
	
	return input
end run
```

2. Save services separately as: moc_play_pause, moc_next, moc_prev

3. System settings -> keyboard -> Keyboard Shortcuts -> services -> General -> double click on each to setup shortcuts

Done. Now you can control the moc player via keyboard shortcuts


