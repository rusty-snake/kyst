Keep Your Flatpak-Sandbox Tight
===============================

These files are supposed to reside in `~/.local/share/flatpak/overrides`.

You can use `flatpak info -m <APP-ID>` to see the metadata (which include the
original permissions) of an app and `flatpak info -M <APP-ID>` to see the
current permissions.

`global` is a special override which affects _all_ flatpaks.
