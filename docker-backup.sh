#!/usr/bin/env bash

##
## Setzten von Umgebungsvariablen
##

LOGDIR="/var/log/docker"
LOGFILE="backup.log"
LOGPATH="$LOGDIR/$LOGFILE"
CONTAINER_LIST=$(docker ps --format '{{.Names}}')
CURRENTDATE=$(date +"%Y%m%d_%H%M")
NFS_SHARE="<PATH TO NFS SHARE>"
BACKUP_DIR="/mnt/backup"
DOCKER_VOLUME_DIR="/var/lib/docker/volumes"
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

echo ""
echo "###### Stoppe Docker Container... ######"
echo ""

for container in $CONTAINER_LIST; do
    docker stop $container
done

echo ""
echo "Done!"
echo ""

echo "###### Mount NFS Share ######"
mount $NFS_SHARE $BACKUP_DIR
echo "Done!"
echo ""

echo "###### Backup Docker Volumes ######"
echo ""
dockerVolumes=$(find $DOCKER_VOLUME_DIR -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
echo "$dockerVolumes"
echo ""

for volume in $dockerVolumes; do
  echo "Start Backup $volume"
    volumePath="$DOCKER_VOLUME_DIR/$volume/"
    targetPath="$BACKUP_DIR/docker/volumes/$volume"
    mkdir -p $targetPath


    targetArchiveFile="$volume-$CURRENTDATE.tar.gz"
    cd $DOCKER_VOLUME_DIR && tar -czpf $targetArchiveFile $volume
    chown $OWNER:$OWNER $targetArchiveFile
    mv $targetArchiveFile $targetPath

    if [ -f "$targetArchiveFile" ]; then
        echo "Datei $targetArchiveFile erfolgreich erstellt"
    fi

    find "$targetPath" -mtime +$MAXDAYS -type f -delete

    echo "Done!"
    echo ""
done

echo "###### Unmount NFS Share ######"
umount $BACKUP_DIR
echo "Done!"
echo ""

echo "###### Start Docker Container ######"
echo ""

if [ -z $CONTAINER_LIST ]; then
    CONTAINER_LIST=$(docker ps -qf "status=exited")
fi

for container in $CONTAINER_LIST; do
    docker restart $container 
done
echo ""
echo "Done!"
echo ""

echo "###### Backup beendet: $(date) ######"