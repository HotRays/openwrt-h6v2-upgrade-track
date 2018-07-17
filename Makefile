
VERSION := "$(shell echo 3.0.0_build`date +%Y%m%d%H%M`)"

all: pack

update_version:
	@sed -i "s/DISTRIB_RELEASE='.*'/DISTRIB_RELEASE='${VERSION}'/" _root_/etc/openwrt_release
	@echo update version ${VERSION}

pack: update_version out/README.txt _root_/etc/openwrt_release
	@tar czf _root_.tgz _root_ && cat shell-compile.sh _root_.tgz >upgrade_${VERSION}.sh && echo gen upgrade_${VERSION}.sh OK!
	@rm -f _root_.tgz
	cp _root_/etc/openwrt_release out/
	mv upgrade_${VERSION}.sh out/upgrade.bin.sh
	cd out && tar cvzf ../upgrade_${VERSION}.tgz README.txt upgrade.bin.sh openwrt_release

clean:
	rm -f upgrade_*.sh
