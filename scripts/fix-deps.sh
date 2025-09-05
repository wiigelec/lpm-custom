#!/bin/bash
####################################################################
# 
# fix-deps.sh
#
####################################################################


#------------------------------------------------------------------#
# fix-deps
#------------------------------------------------------------------#


#------------------------------------------------------------------#
# dejavu-fonts
echo "dejavu-fonts"
fix_files=$(grep -rl dejavu-fonts $DEPTREE_DEPS)
for a in $fix_files; do sed -i '/dejavu-fonts/d' $a; done
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# polkit-agent
echo "polkit-agent"
fix_files=$(grep -rl polkit-agent $DEPTREE_DEPS)
for a in $fix_files; do sed -i '/polkit-agent/d' $a; done
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# dovecot
echo "dovecot"
fix_files=$(grep -rl dovecot $DEPTREE_DEPS)
for a in $fix_files; do sed -i 's/dovecot/dovecot/' $a; done
#------------------------------------------------------------------#
	
#------------------------------------------------------------------#
# x-window-system
echo "x-window-system"
fix_files=$(grep -rl x-window-system $DEPTREE_DEPS)
for a in $fix_files; do sed -i 's/x-window-system/xinit/' $a; done
#------------------------------------------------------------------#
	
#------------------------------------------------------------------#
# java
echo "java"
fix_files=$(grep -rl java $DEPTREE_DEPS)
for a in $fix_files; do sed -i 's/java/java/' $a; done
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# harfbuzz/freetype/graphite
echo "harfbuzz/freetype/graphite"
sed -i 's/\(freetype2\)/\1-pass1/' $DEPTREE_DEPS/harfbuzz.deps	
sed -i 's/\(graphite2\)/\1-pass1/' $DEPTREE_DEPS/harfbuzz.deps

cp $DEPTREE_DEPS/freetype2.deps $DEPTREE_DEPS/freetype2-pass1.deps
cp $DEPTREE_DEPS/graphite2.deps $DEPTREE_DEPS/graphite2-pass1.deps

sed -i '/freetype2/d' $DEPTREE_DEPS/freetype2-pass1.deps
sed -i '/harfbuzz/d' $DEPTREE_DEPS/freetype2-pass1.deps
sed -i '/graphite2/d' $DEPTREE_DEPS/graphite2-pass1.deps

echo "--freetype2-pass1--" >> $DEPTREE_DEPS/freetype2-pass1.deps 
echo "--graphite2-pass1--" >> $DEPTREE_DEPS/graphite2-pass1.deps 

echo "--freetype2--" >> $DEPTREE_DEPS/harfbuzz.deps 
echo "--graphite2--" >> $DEPTREE_DEPS/harfbuzz.deps 

cp $DEPTREE_DEPS/harfbuzz.deps $DEPTREE_DEPS/freetype2.deps
cp $DEPTREE_DEPS/harfbuzz.deps $DEPTREE_DEPS/graphite2.deps
#------------------------------------------------------------------#
	
#------------------------------------------------------------------#
# libva/mesa
echo "libva/mesa"
sed -i 's/\(libva\)/\1-pass1/' $DEPTREE_DEPS/mesa.deps	
cp $DEPTREE_DEPS/libva.deps $DEPTREE_DEPS/libva-pass1.deps
sed -i '/libva/d' $DEPTREE_DEPS/libva-pass1.deps
sed -i '/mesa/d' $DEPTREE_DEPS/libva-pass1.deps
echo "--libva-pass1--" >> $DEPTREE_DEPS/libva-pass1.deps 
echo "--libva--" >> $DEPTREE_DEPS/mesa.deps 
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# libsecret
echo "libsecret"
sed -i '/gnome-keyring/d' $DEPTREE_DEPS/libsecret.deps
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# gcr
echo "gcr"
sed -i '/--gcr--/ i openssh' $DEPTREE_DEPS/gcr.deps
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# network-manager-applet
echo "network-manager-applet"
echo "gnome-keyring" >> $DEPTREE_DEPS/network-manager-applet.deps
#------------------------------------------------------------------#

#------------------------------------------------------------------#
# urllib
echo "urllib"
sed -i 's/hatchling/hatch-vcs/' $DEPTREE_DEPS/urllib3.deps
#------------------------------------------------------------------#

