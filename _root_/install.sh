#!/bin/sh

INSTALL_DIR="${INSTALL_DIR-.}"

version=`uci get temp_base.@upgrade[0].version 2>/dev/null`
test -n "$version" || version=0
. $INSTALL_DIR/etc/openwrt_release
NEW_VERSION=$DISTRIB_RELEASE
. /etc/openwrt_release
OLD_VERSION=$DISTRIB_RELEASE

NEED_REBOOT=0

# update 20180717 by cmq
test $version -lt 1 && {
	install -m 644 $INSTALL_DIR/etc/hotplug.d/block/10-mount /etc/hotplug.d/block/10-mount

	version=1
}


touch /etc/config/temp_base
uci get temp_base.@upgrade[0] >/dev/null 2>&1 || uci add temp_base upgrade >/dev/null 2>&1
uci set temp_base.@upgrade[0].version=$version
uci commit temp_base

[ "x$NEW_VERSION" = "xOLD_VERSION" ] || {
	cp /etc/openwrt_release /tmp/openwrt_release
	sed -i "s/DISTRIB_RELEASE='.*'/DISTRIB_RELEASE='${NEW_VERSION}'/" /tmp/openwrt_release
	cp /tmp/openwrt_release /etc/openwrt_release
}

sync

logger -t "[upgrade]" "upgrade success!"

[ x$NEED_REBOOT = x1 ] && reboot

exit 0
