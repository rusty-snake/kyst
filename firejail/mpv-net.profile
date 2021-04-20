# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

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
