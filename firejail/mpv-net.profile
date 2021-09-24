# Firejail profile for mpv
# Description: Video player based on MPlayer/mplayer2
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mpv-net.local
# Persistent global definitions
include globals.local

netfilter
protocol unix,inet,inet6

private

include private-etc:net.inc

include mpv-common.profile
