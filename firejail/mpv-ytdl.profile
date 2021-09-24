# Firejail profile for mpv
# Description: Video player based on MPlayer/mplayer2
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mpv-ytdl.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/youtube-dl

include allow-python3.inc

netfilter
protocol unix,inet,inet6

private
private-bin env,python3*,youtube-dl
private-etc youtube-dl.conf

include private-etc:net.inc

include mpv-common.profile
