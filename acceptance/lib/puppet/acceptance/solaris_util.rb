module Puppet
  module Acceptance
    module ZoneUtils
      def clean(agent)
        on agent,"zoneadm -z tstzone halt ||:"
        on agent,"zoneadm -z tstzone uninstall -F ||:"
        on agent,"zonecfg -z tstzone delete -F ||:"
        on agent,"rm -f /etc/zones/tstzone.xml ||:"
        on agent,"zfs destroy -r tstpool/tstfs ||:"
        on agent,"zpool destroy tstpool ||:"
        on agent,"rm -rf /tstzones ||:"
      end

      def setup(agent)
        on agent,"mkdir -p /tstzones/mnt"
        on agent,"chmod -R 700 /tstzones"
        on agent,"mkfile 1024m /tstzones/dsk"
        on agent,"zpool create tstpool /tstzones/dsk"
        on agent,"zfs create -o mountpoint=/tstzones/mnt tstpool/tstfs"
        on agent,"chmod 700 /tstzones/mnt"
      end
    end
    module CronUtils
      def clean(agent)
        on agent, "userdel monitor ||:"
        on agent, "groupdel monitor ||:"
        on agent, "mv /var/spool/cron/crontabs/root.orig /var/spool/cron/crontabs/root ||:"
      end

      def setup(agent)
        on agent, "cp /var/spool/cron/crontabs/root /var/spool/cron/crontabs/root.orig"
      end
    end
  end
end
