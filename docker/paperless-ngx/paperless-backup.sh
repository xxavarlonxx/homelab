#!/usr/bin/env bash

##
## Setzten von Umgebungsvariablen
##

LOGDIR="/var/log/paperless"
LOGFILE="backup.log"
LOGPATH="$LOGDIR/$LOGFILE"
CURRENTDATE=$(date +"%Y%m%d_%H%M")
NFS_SHARE="<PATH TO NFS SHARE>"
MOUNT_DIR="/mnt/backup"
BACKUP_DIR="paperless"
EXPORT_DIR="/home/document/paperless/export"
CONTAINER_LIST=$(docker ps --format '{{.Names}}')
DOCKER_CONTAINER_NAME="paperless-webserver"
MAXDAYS="14"
OWNER="1003"

##
## Ausgabe in Logdatei schreiben
##

mkdir -p $LOGDIR
if [ ! -f $LOGPATH ]; then
    touch $LOGPATH
fi

exec > >(tee -i ${LOGPATH})
exec 2>&1

echo "###### Backup gestartet: $(date) ######"

if [ "$(id -u)" != "0" ]
then
	echo "ERROR: Das Skript kann nur als 'root' ausgeführt werden. Stoppe Backup!"
	exit 1
fi

if [ ! "$(docker ps -a -q -f name=${DOCKER_CONTAINER_NAME})" ]
then
    echo "ERROR: Ein Container mit dem Namen '${DOCKER_CONTAINER_NAME}' läuft aktuell nicht. Stoppe Backup!"
    exit 1
fi

echo ""
echo "###### Start Document-Exporter ######"
echo ""

docker exec -it $DOCKER_CONTAINER_NAME document_exporter -dpz ../export
exportFile=$(ls $EXPORT_DIR)
echo ""
echo "Neue Backup-Datei ${exportFile} in ${EXPORT_DIR} erstellt"
echo "Done!"
echo ""


echo "###### Mount NFS Share ######"
mount $NFS_SHARE $MOUNT_DIR
echo "Done!"
echo ""

echo "###### Move Backup to NFS share ######"
sourcePath="$EXPORT_DIR/$exportFile"
targetPath="$MOUNT_DIR/$BACKUP_DIR"
mkdir -p $targetPath
chown $OWNER:$OWNER $sourcePath
mv $sourcePath $targetPath
echo "Done!"
echo ""

echo "###### Delete old backups ######"
find "$targetPath" -mtime +$MAXDAYS -type f -delete
echo "Done!"
echo ""

echo "###### Unmount NFS Share ######"
umount $MOUNT_DIR
echo "Done!"
echo ""


echo "###### Backup beendet: $(date) ######"