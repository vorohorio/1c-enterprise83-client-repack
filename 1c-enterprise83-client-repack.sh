#!/bin/bash
# 1c-enterprise83-client-repack.sh
# Скрипт перепаковки deb-пакетов 1С:Предприятия 8.3, который позволит установить несколько версий клиента 1С.

function movelib {
  lib=$1
  fname="$tmpdir/server/opt/1C/v8.3/$ARCH/$lib"
  if [ -f $fname ]; then
    mv $fname "$tmpdir/opt/1C/v8.3/$ARCH"
  fi

}



tmpdir=1c-enterprise83-repack-tmp
mkdir $tmpdir

for i in 1c-enterprise83-common_8.3.*.deb
do
  if ! [[ $i =~ "nls" ]] ; then
    echo "extract $i"
    dpkg-deb -x $i $tmpdir/
  fi
done

for i in 1c-enterprise83-client_8.3.*.deb
do
  if ! [[ $i =~ "nls" ]] ; then
    echo "extract $i"
    dpkg-deb -x $i $tmpdir/
    dpkg-deb -e $i $tmpdir/DEBIAN/
  fi
done


mkdir "$tmpdir/server/"
for i in 1c-enterprise83-server_8.3.*.deb
do
  if ! [[ $i =~ "nls" ]] ; then
    echo "extract $i"
    dpkg-deb -x $i "$tmpdir/server/"
  fi
done

Version=`awk '/^Version:/{print $2}' "$tmpdir/DEBIAN/control"`
Architecture=`awk '/^Architecture:/{print $2}' "$tmpdir/DEBIAN/control"`

case $Architecture in
    amd64)
        ARCH="x86_64"
        ;;
    i386)
        ARCH="i386"
        ;;
    *)
        echo "WARNING: unsupported arch: $ARCH"
        ARCH="$Architecture"
        ;;
esac

#echo $Version
#echo $ARCH

for i in accnt accntui addin addncpp backbas backend basic basicui bp bpui bsl calc calcui chart chartui config core83 crcore dbeng8 dbgbase dbgmc dbgrc dbgtgt dbgwc dcs dcscore dcsui debug devtool dsgncmd dsgnfrm edb edbui entext enums ext extui filedb fmtd fmtdui frame frntend ftext grphcs help helpui html htmlui httpsrv image imageui inet lockman map mapui mngbase mngcln mngcore mngdsgn mngsrv mngui morph moxel moxelui nuke83 odata pack pictedt rclient richui rscalls rtrsrvc scheme schemui sqlite stl83 techsys test testbase txtedt txtedui vrsbase vrscore wbase ws xdto xml2
do
  #echo -e $i
  movelib "$i.so"
  movelib "${i}_root.res"
  movelib "${i}_ru.res"
done

# очистка
mv "$tmpdir/opt/1C/v8.3/$ARCH/" "$tmpdir/opt/1C/v8.3/$Version"
mv "$tmpdir/usr/share/applications/1cestart.desktop" "$tmpdir/"
rm -R "$tmpdir/usr"
chmod -R 700 "$tmpdir/server"
rm -R "$tmpdir/server"

# настройка 1cestart.desktop
sed -i "s/Exec=.*$/Exec=\/opt\/1C\/v8.3\/$Version\/1cestart/" "$tmpdir/1cestart.desktop"
sed -i "s/Name\[ru_RU\]=.*$/Name\[ru_RU\]=1С:Предприятие $Version/" "$tmpdir/1cestart.desktop"
sed -i "s/Name=.*$/Name=1C:Enterprise $Version/" "$tmpdir/1cestart.desktop"
mkdir -p "$tmpdir/usr/share/applications"
mv "$tmpdir/1cestart.desktop" "$tmpdir/usr/share/applications/1cestart-$Version.desktop"

# настройка DEBIAN/control
sed -i "s/Package: .*$/Package: 1c-enterprise83-client-$Version/" "$tmpdir/DEBIAN/control"
sed -i 's/Version: .*$/Version: 1/' "$tmpdir/DEBIAN/control"
sed -i 's/Installed-Size: .*$/Installed-Size: 400000/' "$tmpdir/DEBIAN/control"
sed -i 's/Depends: .*$/Depends: libwebkitgtk-1.0-0 ( >= 1.2.5 )/' "$tmpdir/DEBIAN/control"

# сборка пакета
fakeroot dpkg-deb --build $tmpdir
mv $tmpdir.deb 1c-enterprise83-client-repack-${Version}_${Architecture}.deb

chmod -R 700 "$tmpdir"
rm -R $tmpdir
