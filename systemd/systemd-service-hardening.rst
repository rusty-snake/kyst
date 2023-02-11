systemd-service-hardening
=========================

.. warning::

  Work in Progress.

  This hasn't been touched for over two years.

.. contents:: Table of Contents

Documentation
-------------

* `man 5 systemd.exec`_
* `man 5 systemd.resource-control`_

.. _`man 5 systemd.exec`: https://www.freedesktop.org/software/systemd/man/systemd.exec.html
.. _`man 5 systemd.resource-control`: https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html


Capabilities
------------

.. code-block:: ini

  # Empty:
  CapabilityBoundingSet=
  # Minimal:
  CapabilityBoundingSet=CAP_A CAP_B CAP_C

Use a minimal (or empty) capability-bounding-set. The blacklist below can be
used for an binary trial and error search.

.. code-block:: ini

  CapabilityBoundingSet=~CAP_AUDIT_CONTROL
  CapabilityBoundingSet=~CAP_AUDIT_READ
  CapabilityBoundingSet=~CAP_AUDIT_WRITE
  CapabilityBoundingSet=~CAP_BLOCK_SUSPEND
  CapabilityBoundingSet=~CAP_BPF
  CapabilityBoundingSet=~CAP_CHECKPOINT_RESTORE
  CapabilityBoundingSet=~CAP_CHOWN
  CapabilityBoundingSet=~CAP_DAC_OVERRIDE
  CapabilityBoundingSet=~CAP_DAC_READ_SEARCH
  CapabilityBoundingSet=~CAP_FOWNER
  CapabilityBoundingSet=~CAP_FSETID
  CapabilityBoundingSet=~CAP_IPC_LOCK
  CapabilityBoundingSet=~CAP_IPC_OWNER
  CapabilityBoundingSet=~CAP_KILL
  CapabilityBoundingSet=~CAP_LEASE
  CapabilityBoundingSet=~CAP_LINUX_IMMUTABLE
  CapabilityBoundingSet=~CAP_MAC_ADMIN
  CapabilityBoundingSet=~CAP_MAC_OVERRIDE
  CapabilityBoundingSet=~CAP_MKNOD
  CapabilityBoundingSet=~CAP_NET_ADMIN
  CapabilityBoundingSet=~CAP_NET_BIND_SERVICE
  CapabilityBoundingSet=~CAP_NET_BROADCAST
  CapabilityBoundingSet=~CAP_NET_RAW
  CapabilityBoundingSet=~CAP_PERFMON
  CapabilityBoundingSet=~CAP_SETGID
  CapabilityBoundingSet=~CAP_SETFCAP
  CapabilityBoundingSet=~CAP_SETPCAP
  CapabilityBoundingSet=~CAP_SETUID
  CapabilityBoundingSet=~CAP_SYS_ADMIN
  CapabilityBoundingSet=~CAP_SYS_BOOT
  CapabilityBoundingSet=~CAP_SYS_CHROOT
  CapabilityBoundingSet=~CAP_SYS_MODULE
  CapabilityBoundingSet=~CAP_SYS_NICE
  CapabilityBoundingSet=~CAP_SYS_PACCT
  CapabilityBoundingSet=~CAP_SYS_PTRACE
  CapabilityBoundingSet=~CAP_SYS_RAWIO
  CapabilityBoundingSet=~CAP_SYS_RESOURCE
  CapabilityBoundingSet=~CAP_SYS_TIME
  CapabilityBoundingSet=~CAP_SYS_TTY_CONFIG
  CapabilityBoundingSet=~CAP_SYSLOG
  CapabilityBoundingSet=~CAP_WAKE_ALARM

Syscalls
--------

.. code-block:: ini

  SystemCallFilter=@system-service
  SystemCallFilter=~@privileged
  SystemCallFilter=@chown

Enable seccomp whitelisting, drop ``@privileged`` but keep ``@chown``.
You should drop more syscall-groups which are not needed (see ``systemd-analyze
syscall-filter``). You can also use ``SystemCallErrorNumber=EPERM`` to return
``EPERM`` instead of killing the process on violations.

.. code-block:: ini

  SystemCallArchitectures=native

Allow only native syscalls.

Experts tip: Make this system-wide by setting
``SystemCallArchitectures=native`` in ``/etc/systemd/system.conf``.

.. code-block:: ini

  LockPersonality=yes

Block the ``personality`` syscall.

Filesystem
----------

.. code-block:: ini

  PrivateMounts=yes

Run in a own mount-namespace.

.. code-block:: ini

  ProtectSystem=yes     -- only /usr
  ProtectSystem=full    -- only /usr and /etc
  ProtectSystem=strict  -- all except /dev, /proc and /sys

Make your system (or parts of it) read-only. You can use ``ReadWritePaths=`` to
add exceptions and ``ReadOnlyPaths=`` to add more paths (if ``yes`` or ``full``
is used).

.. code-block:: ini

  PrivateTmp=yes

Use a private (not shared) /tmp and /var/tmp.

.. code-block:: ini

  ProtectHome=yes

Make ``/home``, ``/root`` and ``/run/user`` inaccessible. Weak alternatives are
``=read-only`` or ``=tmpfs`` (which allows whitelisting, see below).

.. code-block:: ini

  InaccessiblePaths=-/mnt
  InaccessiblePaths=-/media
  InaccessiblePaths=-/run/media
  InaccessiblePaths=-/boot
  InaccessiblePaths=-/opt

Make some paths inaccessible which are unlikely to ever be accessed.
*TODO: Add more.*

.. code-block:: ini

  ProtectKernelTunables=yes

Make various kernel variables in ``/proc`` and ``/sys`` read-only.

.. code-block:: ini

  ProtectControlGroups=yes

Makes ``/sys/fs/cgroup`` read-only.

.. code-block:: ini

  RestrictSUIDSGID=yes

Forbid setting suid/sgid-bits on files.

.. code-block:: ini

  MountFlags=private
  SystemCallFilter=~@mount

Prevent holes in the filesystem restrictions.

Whitelisting
~~~~~~~~~~~~

.. code-block:: ini

  TemporaryFileSystem=/etc
  BindPaths=-/etc/dnsmasq.conf
  BindReadOnlyPaths=-/etc/resolv.conf

Use whitelisting for ``/etc``.

- ``CacheDirectory=``
- ``ConfigurationDirectory=``
- ``LogsDirectory=``,
- ``RuntimeDirectory=``
- ``StateDirectory=``

.. admonition:: TODO

  Write ``mkdir@.service`` and ``mkfile@.service`` services to create
  directories/files for whitelisting by depending on those units.

  .. code-block:: ini

    [Unit]
    Description=Create a directory
    RequiresMountsFor=FIXME

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/mkdir %i

Devices
~~~~~~~

.. code-block:: ini

  ProtectClock=yes

Prevent the service from changing the HW-clock.

.. code-block:: ini

  PrivateDevices=yes

Prohibit (raw) access to physical devices.

.. code-block:: ini

  DevicePolicy=strict
  DeviceAllow=/dev/null
  DeviceAllow=char-pts

Set a strict device-policy which only grants access to devices which are
explicit allowed by ``DeviceAllow=``.
(Use together with ``PrivateDevices=yes``.)

extras
~~~~~~

  - ``RootDirectory=`` / ``RootImage=``

Network
-------

.. code-block:: ini

  PrivateNetwork=yes

Run in a own private net-namespace.

.. code-block:: ini

  RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6

Restricts the set of available address families. You might need to add
additional families such as ``AF_NETLINK``. If no internet connection is
required, remove ``AF_INET`` and ``AF_INET6``. In the unlikely case where
``AF_UNIX`` is not required, it should be removed too.
*FIXME: Doesn't this break systemd?*

.. code-block:: ini

  ProtectHostname=yes

Run in a own uts-namespace and prohibit hostname/domainname changes (seccomp
filter).

IP black and whitelist
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

  IPAddressDeny=8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844

Blacklist the IP-Addresses of Google Public DNS.

.. code-block:: ini

  IPAddressDeny=any
  IPAddressAllow=localhost
  IPAddressAllow=9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9

Whitelist Quad9 IP-Addresses and localhost.

extras
~~~~~~

* ``NetworkNamespacePath=``

Users
-----

.. code-block:: ini

  PrivateUsers=yes

Run in a own private user-namespace.

.. code-block:: ini

  User=user
  Group=group
  SupplementaryGroups=supp_group1 supp_group2

Run as user ``user`` an group ``group`` with ``supp_group1`` and ``supp_group2``
as supplementary groups.

.. code-block:: ini

  DynamicUser=yes

Dynamically add a user+group for this service and use it, instead of static
user+group by ``User=`` and ``Group=``.

.. code-block:: ini

  RemoveIPC=yes

Remove System V and POSIX IPC objects owned by the user and group specified by
``User=`` and ``Group=`` or ``DynamicUser=yes``.

Limits
------

.. code-block:: ini

  LimitCPU=10
  LimitFSIZE=1G
  LimitDATA=500M
  LimitSTACK=500M
  LimitAS=2G
  LimitCORE=0
  LimitNOFILE=32
  LimitNPROC=8
  LimitMEMLOCK=0
  LimitLOCKS=0
  LimitSIGPENDING=0
  LimitMSGQUEUE=0
  LimitNICE=20
  LimitRTPRIO=0
  LimitRTTIME=0

Set resource limits. ``LimitCPU`` is only usefull for ``Type=oneshot``.


Misc
----

.. code-block:: ini

  NoNewPrivileges=yes

Set the ``NO_NEW_PRIVS`` prctl.

.. code-block:: ini

  ProtectKernelLogs=yes

Deny access to the kernel log ring buffer.

.. code-block:: ini

  ProtectKernelModules=yes

Forbid explicit module loading.

.. code-block:: ini

  MemoryDenyWriteExecute=yes
  InaccessiblePaths=/dev/shm
  SystemCallFilter=~memfd_create

Strong MDWE.

.. code-block:: ini

  RestrictNamespaces=yes
  RestrictNamespaces=cgroup ipc net mnt pid user uts
  RestrictNamespaces=~cgroup ipc net mnt pid user uts

.. code-block:: ini

  RestrictRealtime=yes

Prohibit any attempts to enable realtime scheduling.

.. code-block:: ini

  UMask=0077

Set a tight umask.

extras
~~~~~~

* ``SELinuxContext=``
* ``AppArmorProfile=``
* ``SmackProcessLabel=``

Summary
-------

.. code-block:: ini

  SystemCallFilter=@system-service
  PrivateMounts=yes
  ProtectSystem=full
  PrivateTmp=yes
  ProtectHome=yes
  InaccessiblePaths=-/mnt
  InaccessiblePaths=-/media
  InaccessiblePaths=-/run/media
  InaccessiblePaths=-/boot
  InaccessiblePaths=-/opt
  ProtectClock=yes
  PrivateDevices=yes
  RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
  NoNewPrivileges=yes
  ProtectKernelLogs=yes
  ProtectKernelModules=yes
  ProtectKernelTunables=yes
  ProtectControlGroups=yes
  MemoryDenyWriteExecute=yes
  InaccessiblePaths=/dev/shm
  LockPersonality=yes
  SystemCallArchitectures=native
  ProtectHostname=yes
  RestrictNamespaces=yes
  RestrictRealtime=yes
  RestrictSUIDSGID=yes

.. code-block:: ini

  ProtectSystem=strict
  MountFlags=private
  SystemCallFilter=~@mount
  PrivateNetwork=yes
  PrivateUsers=yes

.. code-block:: ini

  CapabilityBoundingSet=
  TemporaryFileSystem=/…
  BindPaths=-/…
  BindReadOnlyPaths=-/…
  DevicePolicy=strict
  DeviceAllow=/dev/…
  DynamicUser=yes
  RemoveIPC=yes

++++++++++++++++

TODO
----

.. code-block:: ini

  SecureBits=noroot-locked

.. code-block:: ini

  LogRateLimitBurst=
  LogRateLimitIntervalSec=

.. code-block:: ini

  CPUWeight=
  StartupCPUWeight=
  CPUQuota=
  CPUQuotaPeriodSec=
  AllowedCPUs=

  AllowedMemoryNodes=
  MemoryMin=
  MemoryLow=
  MemoryHigh=
  MemoryMax=
  MemorySwapMax=

  TasksMax=

  IOWeight=
  StartupIOWeight=
  IODeviceWeight=
  IOReadBandwidthMax=
  IOWriteBandwidthMax=
  IOReadIOPSMax=
  IOWriteIOPSMax=
  IODeviceLatencyTargetSec=

  Nice=
  CPUSchedulingPolicy=
  CPUSchedulingPriority=
  CPUSchedulingResetOnFork=
  CPUAffinity=
  NUMAPolicy=
  NUMAMask=
  IOSchedulingClass=
  IOSchedulingPriority=

.. code-block:: ini

  OOMScoreAdjust=100
  OOMPolicy=kill
  OOMPolicy=stop

.. code-block:: ini

  ProtectProc=invisible
  ProcSubset=pid


