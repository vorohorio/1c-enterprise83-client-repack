#!/bin/bash
# 1c-enterprise83-client-repack.sh
# Скрипт перепаковки deb-пакетов 1С:Предприятия 8.3, который позволит установить несколько версий клиента 1С.

if [ -z "$2" ]
then
 echo "Порядок использования: `basename $0` 8.3.5-1248 amd64"
 exit 65
fi

VER1C=$1
SUFFIX=$2

cd $VER1C

tmpdir=1c-enterprise83-repack-tmp
mkdir $tmpdir

for i in 1c-enterprise83-common_8.3.*$SUFFIX.deb
do
  if ! [[ $i =~ "nls" ]] ; then
    echo "extract $i"
    dpkg-deb -x $i $tmpdir/
  fi
done

for i in 1c-enterprise83-client_8.3.*$SUFFIX.deb
do
  if ! [[ $i =~ "nls" ]] ; then
    echo "extract $i"
    dpkg-deb -x $i $tmpdir/
    dpkg-deb -e $i $tmpdir/DEBIAN/
  fi
done


for i in 1c-enterprise83-server_8.3.*$SUFFIX.deb
do
  if ! [[ $i =~ "nls" ]] ; then
    echo "extract $i"
    dpkg-deb -x $i "$tmpdir/"
  fi
done
rm -R "$tmpdir/etc"


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

# очистка
mv "$tmpdir/opt/1C/v8.3/$ARCH/" "$tmpdir/opt/1C/v8.3/$Version"
mv "$tmpdir/usr/share/applications/1cestart.desktop" "$tmpdir/"
rm -R "$tmpdir/usr"

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
dpkg-deb --build $tmpdir
mv $tmpdir.deb 1c-enterprise83-client-repack-${Version}_${Architecture}.deb

chmod -R 700 "$tmpdir"
rm -R $tmpdir
