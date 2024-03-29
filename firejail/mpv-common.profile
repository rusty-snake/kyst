# Firejail profile for mpv
# Description: Video player based on MPlayer/mplayer2
quiet
# Persistent local customizations
include mpv-common.local
# Persistent global definitions
#include globals.local

noblacklist ${HOME}/.config/mpv

noblacklist /usr/lib64/liblua*

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-write-mnt.inc
include disable-xdg.inc

whitelist /usr/share/vulkan
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
seccomp !set_mempolicy
seccomp.block-secondary
tracelog

disable-mnt
private-bin mpv
# Causes slow OSD, see #2838
#private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,mpv
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
