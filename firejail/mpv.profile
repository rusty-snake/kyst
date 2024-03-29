# Firejail profile for mpv
# Description: Video player based on MPlayer/mplayer2
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mpv.local
# Persistent global definitions
include globals.local

ignore nodvd
ignore disable-mnt

noblacklist ${MUSIC}
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

net none
protocol unix

include mpv-common.profile
