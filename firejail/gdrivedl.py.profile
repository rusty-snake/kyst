# Firejail profile for gdrivedl.py
quiet
# Persistent local customizations
include gdrivedl.py.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/bin/gdrivedl.py
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin python3*
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,nsswitch.conf,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none
