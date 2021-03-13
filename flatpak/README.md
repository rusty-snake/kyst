Keep Your Flatpak-Sandbox Tight
===============================

These files are supposed to reside in `~/.local/share/flatpak/overrides`.

You can use `flatpak info -m <APP-ID>` to see the metadata (which include the
original permissions) of an app and `flatpak info -M <APP-ID>` to see the
current permissions.

`global` is a special override which affects _all_ flatpaks.
I do not use it at this time.

---------------------------------------------------------------------

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.
