#!/bin/sh

NODE_NAME="$(cat /proc/sys/kernel/hostname)"
OUTDIR="/root/config-export"
ARCHIVE="/root/${NODE_NAME}-config-export.tar.gz"

mkdir -p "$OUTDIR"

cp /etc/config/network "$OUTDIR/network-${NODE_NAME}"
cp /etc/config/system "$OUTDIR/system-${NODE_NAME}"
cp /etc/config/firewall "$OUTDIR/firewall-${NODE_NAME}"
cp /etc/config/dhcp "$OUTDIR/dhcp-${NODE_NAME}"

batctl meshif bat0 if > "$OUTDIR/batman-if-${NODE_NAME}.txt"
batctl meshif bat0 n > "$OUTDIR/batman-neighbors-${NODE_NAME}.txt"
batctl meshif bat0 o > "$OUTDIR/batman-originators-${NODE_NAME}.txt"

ip addr > "$OUTDIR/ip-addr-${NODE_NAME}.txt"
ip route > "$OUTDIR/ip-route-${NODE_NAME}.txt"
ip link show eth1 > "$OUTDIR/eth1-link-${NODE_NAME}.txt"
ip link show bat0 > "$OUTDIR/bat0-link-${NODE_NAME}.txt"

apk list --installed > "$OUTDIR/packages-${NODE_NAME}.txt"

tar -czf "$ARCHIVE" -C /root config-export

echo ""
echo "========================================"
echo "Export Complete"
echo "Archive Created:"
echo "$ARCHIVE"
echo "========================================"

ls -lh "$ARCHIVE"