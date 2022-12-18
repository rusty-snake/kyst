# Firejail profile for firefox
# Description: Safe and easy web browser from Mozilla
# This file is overwritten after every install/update
# Persistent local customizations
include firefox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include allow-bin-sh.inc

blacklist /opt
blacklist /srv
blacklist /usr/games
blacklist /usr/libexec
#blacklist /usr/local
blacklist /usr/src
blacklist /var

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.cache/fontconfig
whitelist ${HOME}/.fontconfig
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/Downloads/Firefox
whitelist ${RUNUSER}/pulse/native
whitelist ${RUNUSER}/wayland-0
whitelist /usr/share/doc
whitelist /usr/share/firefox
whitelist /usr/share/gnome-shell/search-providers/firefox-search-provider.ini
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
#include whitelist-common.inc
include whitelist-run-common.inc
#include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp !chroot
#seccomp.keep
seccomp.block-secondary
seccomp-error-action kill

disable-mnt
private-bin basename,bash,cat,dirname,expr,firefox,getenforce,ln,mkdir,pidof,restorecon,rm,rmdir,sed,sh,uname
private-dev
private-etc firefox,fonts,localtime,mime.types,selinux
include private-etc:net.inc
#private-lib
private-tmp

dbus-user filter
dbus-user.own org.mozilla.Firefox.*
dbus-user.own org.mozilla.firefox.*
dbus-user.talk org.freedesktop.Notifications
dbus-system none

env PATH=/usr/bin
read-only ${HOME}
read-write ${HOME}/.cache
read-write ${HOME}/.mozilla
read-write ${HOME}/Downloads/Firefox
