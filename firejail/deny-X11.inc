# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/.mutter-Xwaylandauth*
blacklist /tmp/.ICE-unix
blacklist ${RUNUSER}/ICEauthority
rmenv DISPLAY
rmenv XAUTHORITY
