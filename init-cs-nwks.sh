#!/bin/bash


srccfgdir="$1"
shift
dstcfgdir="$1"
shift


if [ -z $srccfgdir ]; then
    echo "Missing source config directory!"
    exit 1
fi
if [ -z $dstcfgdir ]; then
    echo "Missing dest config directory!"
    exit 1
fi

echo "Source directory: $srccfgdir"
ls $srccfgdir
echo "Dest directory: $dstcfgdir"
ls $dstcfgdir



if [ -z $CS_NWKS_PGUSER ]; then
    echo "Missing CS_NWKS_PGUSER!"
    exit 1
fi
if [ -z $CS_NWKS_PGPWD ]; then
    echo "Missing CS_NWKS_PGPWD!"
    exit 1
fi
if [ -z $CS_NWKS_PGHOST ]; then
    echo "Missing CS_NWKS_PGHOST!"
    exit 1
fi
if [ -z $CS_NWKS_RMQUSER ]; then
    echo "Missing CS_NWKS_RMQUSER!"
    exit 1
fi
if [ -z $CS_NWKS_RMQPWD ]; then
    echo "Missing CS_NWKS_RMQPWD!"
    exit 1
fi
if [ -z $CS_NWKS_RMQHOST ]; then
    echo "Missing CS_NWKS_RMQHOST!"
    exit 1
fi
if [ -z $CS_NWKS_REDISHOST ]; then
    echo "Missing CS_NWKS_REDISHOST!"
    exit 1
fi

set -e


pgurl="postgres://$CS_NWKS_PGUSER:$CS_NWKS_PGPWD@$CS_NWKS_PGHOST"

if psql "$pgurl/postgres" -lqt | cut -d \| -f 1 | grep -qw chirpstack; then
    echo "Database chirpstack already exists."
else
    echo "Creating database chirpstack..."
    psql "$pgurl/postgres" -c "create database chirpstack with owner chirpstack;"
EOF
fi

psql "$pgurl/chirpstack?sslmode=disable" -c 'create extension if not exists  pg_trgm;'


mkdir -p $dstcfgdir
cp $srccfgdir/* $dstcfgdir
echo "Destdir: $dstcfgdir"
ls $dstcfgdir

sed -i "s/CS_NWKS_PGHOST/$CS_NWKS_PGHOST/g" $dstcfgdir/chirpstack.toml
sed -i "s/CS_NWKS_PGPWD/$CS_NWKS_PGPWD/g" $dstcfgdir/chirpstack.toml
sed -i "s/CS_NWKS_PGUSER/$CS_NWKS_PGUSER/g" $dstcfgdir/chirpstack.toml

sed -i "s/CS_NWKS_REDISHOST/$CS_NWKS_REDISHOST/g"  $dstcfgdir/chirpstack.toml

sed -i "s/CS_NWKS_RMQHOST/$CS_NWKS_RMQHOST/g"  $dstcfgdir/chirpstack.toml
sed -i "s/CS_NWKS_RMQUSER/$CS_NWKS_RMQUSER/g"  $dstcfgdir/chirpstack.toml
sed -i "s/CS_NWKS_RMQPWD/$CS_NWKS_RMQPWD/g"  $dstcfgdir/chirpstack.toml

sed -i "s/CS_NWKS_RMQHOST/$CS_NWKS_RMQHOST/g"  $dstcfgdir/region_eu868.toml
sed -i "s/CS_NWKS_RMQUSER/$CS_NWKS_RMQUSER/g"  $dstcfgdir/region_eu868.toml
sed -i "s/CS_NWKS_RMQPWD/$CS_NWKS_RMQPWD/g"  $dstcfgdir/region_eu868.toml

rm -rf $dstcfgdir/*~
rm -rf $dstcfgdir/*.sh

touch $dstcfgdir/csnwksinit-done

echo "Updated $dstcfgdir."
