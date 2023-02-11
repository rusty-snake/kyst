Keep Your Systemd-Sandbox Tight
===============================

These files are supposed to reside in `/etc/systemd/system/{foobar.service.d}`.

You can use `systemctl edit <UNIT>` to edit them.

`systemd-analyze security <UNIT>` give you an good overview over the hardning score of a unit.
