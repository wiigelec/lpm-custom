#!/bin/bash
####################################################################
# 
# fix-scripts.sh
#
####################################################################


#------------------------------------------------------------------#
# fix-scripts
#------------------------------------------------------------------#


#------------------------------------------------------------------#
# sudo
FILE=$BUILD_SCRIPTS/sudo.build
echo ${FILE##*/}
linenum=$(grep -n "cat > /etc/pam.d/sudo" $FILE | sed 's/:.*//')
sed -i "$linenum i [[ -d /etc/pam.d ]] &&" $FILE
linenum=$(grep -n "chmod 644 /etc/pam.d/sudo" $FILE | sed 's/:.*//')
sed -i "$linenum i [[ -f /etc/pam.d/sudo ]] &&" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# unzip
FILE=$BUILD_SCRIPTS/unzip.build
echo ${FILE##*/}
sed -i '/convmv -f cp936 -t utf-8 -r --nosmart --notest/d' $FILE
sed -i '/<\/path\/to\/unzipped\/files>/d' $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# post-lfs-config-profile
FILE=$BUILD_SCRIPTS/postlfs-config-profile.build
echo ${FILE##*/}
linenum=$(grep -n "### CONFIGURE MAKE INSTALL ###" $FILE | sed 's/:.*//')
linenum2=$(grep -n "### END CONFIGURE MAKE INSTALL ###" $FILE | sed 's/:.*//')
sed -i "${linenum},${linenum2}s/\\$/\\\\\$/g" $FILE
sed -i 's/export LANG=<ll>.*/export LANG=C.UTF-8/g' $FILE
sed -i '/cat > ~\/.bash_profile << "EOF"/ i \
install --directory --mode=0755 --owner=root --group=root \/etc\/skel' $FILE
sed -i 's/cat > ~\/.bash_profile << "EOF"/cat > \/etc\/skel\/.bash_profile << "EOF"/g' $FILE
sed -i 's/cat > ~\/.profile << "EOF"/cat > \/etc\/skel\/.profile << "EOF"/g' $FILE
sed -i 's/cat > ~\/.bashrc << "EOF"/cat > \/etc\/skel\/.bashrc << "EOF"/g' $FILE
sed -i 's/cat > ~\/.bash_logout << "EOF"/cat > \/etc\/skel\/.bash_logout << "EOF"/g' $FILE
sed -i 's/\\$HOME/\$HOME/g' $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# which
FILE=$BUILD_SCRIPTS/which.build
echo ${FILE##*/}
line1=$(grep -n "cat > /usr/bin/which << \"EOF\"" $FILE | sed 's/:.*//')
line2=$(grep -n "chown -v root:root /usr/bin/which" $FILE | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# dhcpd
FILE=$BUILD_SCRIPTS/dhcpcd.build
echo ${FILE##*/}
line1=$(grep -n "make install-dhcpcd" $FILE | sed 's/:.*//')
line2=$(grep -n "systemctl start dhcpcd@eth0" $FILE | sed 's/:.*//')
line3=$(grep -n "systemctl enable dhcpcd@eth0" $FILE | sed 's/:.*//')
sed -i "${line1}d;${line2}d;${line3}d" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# iptables
FILE=$BUILD_SCRIPTS/iptables.build
echo ${FILE##*/}
line1=$(grep -n "iptables -A INPUT  -i ! WAN1  -j ACCEPT" $FILE | sed 's/:.*//')
line2=$(grep -n "iptables -A OUTPUT -j" $FILE | tail -n1 | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
line3=$(grep -n "make install-iptables" $FILE | sed 's/:.*//')
sed -i "${line3}d" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# wpa_supplicant
FILE=$BUILD_SCRIPTS/wpa_supplicant.build
echo ${FILE##*/}
line1=$(grep -n "network={" $FILE | sed 's/:.*//')
line2=$(grep -n "update_config=1" $FILE | tail -n1 | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
line3=$(grep -n "systemctl start wpa_supplicant@wlan0" $FILE | sed 's/:.*//')
sed -i "${line3}d" $FILE
line3=$(grep -n "systemctl enable wpa_supplicant@wlan0" $FILE | sed 's/:.*//')
sed -i "${line3}d" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# gpm
FILE=$BUILD_SCRIPTS/gpm.build
echo ${FILE##*/}
line1=$(grep -n "make install-gpm" $FILE | sed 's/:.*//')
sed -i "${line1}d" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# libnl
FILE=$BUILD_SCRIPTS/libnl.build
echo ${FILE##*/}
line1=$(grep -n "General setup --->" $FILE | sed 's/:.*//')
line2=$(grep -n "<*/M>   Virtual Routing and Forwarding (Lite)" $FILE | tail -n1 | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# bash -e
echo "bash -e"
fix_files=$(grep -rl "bash -e" $BUILD_SCRIPTS)
for a in $fix_files; do sed -i 's/bash -e/set -e/' $a; done
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# as_root
echo "as_root"
fix_files=$(grep -rl "as_root" $BUILD_SCRIPTS)
for a in $fix_files; do sed -i 's/as_root/sudo/' $a; done
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# linux-pam
FILE=$BUILD_SCRIPTS/linux-pam.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
line1=$(grep -n "auth.*nullok" $FILE | sed 's/:.*//')
line2=$(grep -n "password.*nullok" $FILE | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# shadow
FILE=$BUILD_SCRIPTS/shadow.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
linenum=$(grep -n "for FUNCTION in FAIL_DELAY" $FILE | sed 's/:.*//')
linenum2=$(grep -n "### END CONFIGURE MAKE INSTALL ###" $FILE | sed 's/:.*//')
sed -i "${linenum},${linenum2}s/\\$/\\\\\$/g" $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# xorg env
FILE=$BUILD_SCRIPTS/xorg-env.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
echo "xorg-env"
sed -i 's/<PREFIX>/\/usr/' $FILE
sed -i 's/^XORG_CONFIG=.*/XORG_CONFIG="$XORG_CONFIG"/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# xorg libs
FILE=$BUILD_SCRIPTS/xorg7-lib.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/grep -A9 summary \*make_check\.log/d' $FILE
sed -i '/ln -sv $XORG_PREFIX\/lib\/X11 \/usr\/lib\/X11 &&/d' $FILE
sed -i '/ln -sv $XORG_PREFIX\/include\/X11 \/usr\/include\/X11/d' $FILE
sed -i '/exit/d' $FILE
echo "exit" >> $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# xorg apps
FILE=$BUILD_SCRIPTS/xorg7-app.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/exit/d' $FILE
echo "exit" >> $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# xorg fonts
FILE=$BUILD_SCRIPTS/xorg7-font.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/exit/d' $FILE
echo "exit" >> $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# harfbuzz/freetype/graphite
echo "harfbuzz/freetype/graphite"
cp $BUILD_SCRIPTS/freetype2.build $BUILD_SCRIPTS/freetype2-pass1.build
sed -i 's/{PKG_ID}/{PKG_ID}-pass1/g' $BUILD_SCRIPTS/freetype2-pass1.build
                                     
cp $BUILD_SCRIPTS/graphite2.build $BUILD_SCRIPTS/graphite2-pass1.build
sed -i 's/{PKG_ID}/{PKG_ID}-pass1/g' $BUILD_SCRIPTS/graphite2-pass1.build
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# mesa/libva
FILE=$BUILD_SCRIPTS/libva-pass1.build
cp $BUILD_SCRIPTS/libva.build $BUILD_SCRIPTS/libva-pass1.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
cp $BUILD_SCRIPTS/libva.build $FILE
sed -i 's/{PKG_ID}/{PKG_ID}-pass1/g' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# libvdpau
FILE=$BUILD_SCRIPTS/libvdpau.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/[ -e \$XORG_PREFIX\/share\/doc\/libvdpau ] && mv -v \$XORG_PREFIX\/share\/doc\/libvdpau{,1\.5}/d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# dbus
FILE=$BUILD_SCRIPTS/dbus.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/make install-dbus/d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# lightdm
FILE=$BUILD_SCRIPTS/lightdm.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/make install-lightdm/d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# imlib2
FILE=$BUILD_SCRIPTS/imlib2.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/html/d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# boost
FILE=$BUILD_SCRIPTS/boost.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/-j<N>/-j\$(nproc)/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# sdl2
FILE=$BUILD_SCRIPTS/sdl2.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
num=$(grep -n "cd test" $FILE | sed 's/:.*//')
sed -i "$num,$(($num+2))d" $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# qt6
FILE=$BUILD_SCRIPTS/qt6.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/\$QT6DIR/\\\$QT6DIR/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# qt5-components
FILE=$BUILD_SCRIPTS/qt5-components.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/\$QT5DIR/\\\$QT5DIR/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# v4l-utils
FILE=$BUILD_SCRIPTS/v4l-utils.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/contrib\/test\/\$prog/contrib\/test\/\\$prog/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# network manager
FILE=$BUILD_SCRIPTS/NetworkManager.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/\/usr\/share\/man\/man\$section/\/usr\/share\/man\/man\\$section/' $FILE
sed -i 's/install -vm 644 \$file/install -vm 644 \\$file/' $FILE
sed -i 's/netdev &&/netdev/' $FILE
sed -i '/netdev <username>/d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# kf6-frameworks
FILE=$BUILD_SCRIPTS/kf6-frameworks.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/The options used here are:/,+5d' $FILE
sed -i '/exit/d' $FILE
echo "exit" >> $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# qcoro
FILE=$BUILD_SCRIPTS/qcoro.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/make test/d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# plasma-build
FILE=$BUILD_SCRIPTS/plasma-build.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/The options used here are:/,+5d' $FILE
sed -i '/exit/d' $FILE
echo "exit" >> $FILE
linenum=$(grep -n "# Setup xsessions (X11 sessions)" $FILE | sed 's/:.*//')
sed -i "$linenum i sudo sh -e << ROOT_EOF" $FILE
linenum=$(grep -n "ln -sfv \$KF6_PREFIX/share/xdg-desktop-portal/portals/kde.portal" $FILE | sed 's/:.*//')
((linenum++))
sed -i "$linenum i ROOT_EOF" $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# java
FILE=$BUILD_SCRIPTS/java.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
[[ $(uname -m) == "x86_64" ]] && sed -i 's/\(PKG_URL=.*\)i686\(.*\)/\1x86_64\2/' $FILE
sed -i '/wget http/d' $FILE
sed -i '/public class HelloWorld/,+6d' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# ojdk-conf
FILE=$BUILD_SCRIPTS/ojdk-conf.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/\$JAVA_HOME/\\\$JAVA_HOME/' $FILE
sed -i 's/\${AUTO_CLASSPATH_DIR}/\\\${AUTO_CLASSPATH_DIR}/' $FILE
sed -i 's/\$dir/\\\$dir/' $FILE
sed -i 's/\$jar/\\\$jar/' $FILE
sed -i 's/`find/\\`find/' $FILE
sed -i 's/null`/null\\`/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# openjdk
FILE=$BUILD_SCRIPTS/openjdk.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/export MAKEFLAGS/d' $FILE
sed -i 's/make images/make images JOBS=\$(nproc)/' $FILE
sed -i 's/\${s}\.png \\/\\\${s}\.png \\\\/' $FILE
sed -i 's/\${s}x\${s}/\\\${s}x\\\${s}/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# postgresql
FILE=$BUILD_SCRIPTS/postgresql.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
line1=$(grep -n "install -v -dm700 /srv/pgsql/data &&" $FILE | sed 's/:.*//')
line2=$(grep -n "su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'" $FILE | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
sed -i '/make install-postgresql/d' $FILE
line1=$(grep -n "su - postgres -c '/usr/bin/postgres -D /srv/pgsql/data >" $FILE | sed 's/:.*//')
line2=$(grep -n "su - postgres -c \"/usr/bin/pg_ctl stop -D /srv/pgsql/data\"" $FILE | sed 's/:.*//')
sed -i "$line1,${line2}d" $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# libreoffice
FILE=$BUILD_SCRIPTS/libreoffice.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/<PREFIX>/\/opt\/libreoffice-\$PKG_VERS/' $FILE
sed -i 's/\$LO_PREFIX/\\\$LO_PREFIX/' $FILE
sed -i 's/\$i/\\\$i/' $FILE
sed -i 's/\$(basename \$i)/\\\$(basename \\\$i)/' $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# qemu
FILE=$BUILD_SCRIPTS/qemu.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/usermod -a -G kvm <username>/usermod -a -G kvm \$USER/' $FILE
line1=$(grep -n "chmod 4750 /usr/libexec/qemu-bridge-helper" $FILE | sed 's/:.*//')
sed -i "${line1}a ln -sv qemu-system-\`uname -m\` \/usr\/bin\/qemu" $FILE
line1=$(grep -n "VDISK_SIZE=50G" $FILE | sed 's/:.*//')
line2=$(grep -n "echo allow br0 > /etc/qemu/bridge.conf" $FILE | sed 's/:.*//')
sed -i "$line1,$(($line2+1))d" $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# xorg7-legacy
FILE=$BUILD_SCRIPTS/xorg7-legacy.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i '/exit/d' $FILE
echo "exit" >> $FILE
fi
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# tigervnc
FILE=$BUILD_SCRIPTS/tigervnc.build
echo ${FILE##*/}
if [[ -f $FILE ]]; then
sed -i 's/\$XORG_PREFIX/\\\$XORG_PREFIX/' $FILE
sed -i 's/\$(whoami)/\\\$(whoami)/' $FILE
line1=$(grep -n "systemctl start" $FILE | sed 's/:.*//')
line2=$(grep -n "systemctl enable" $FILE | sed 's/:.*//')
if [[ ! -z $line1 ]] && [[ ! -z $line2 ]]; then sed -i "$line1,${line2}d" $FILE; fi
fi
#------------------------------------------------------------------#

