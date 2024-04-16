PBF=$1
BOUNDING=$2
DOWNLOAD_PBF="${PBF:-}"
PBF_BOUNDING="${BOUNDING:-}"
OSM_DATA=osm-data
DATA=$OSM_DATA:/data/database/
OSM_TILES=osm-tiles
TILES=$OSM_TILES:/data/tiles/
IMAGE=doclassif/osm-tile-server

echo "params" $DOWNLOAD_PBF $PBF_BOUNDING

if [ -f imported ]; then
    docker run \
    --name osm-tile-server \
    -p 8070:80 \
    -e UPDATES=enabled \
    -v $DATA \
    -v $TILES \
    -d $IMAGE \
    run 
else
    bash remove.sh
    docker volume create $OSM_DATA
    docker volume create $OSM_TILES
    docker run \
    --name osm-tile-server-import \
    -e DOWNLOAD_PBF=$DOWNLOAD_PBF \
    -e PBF_BOUNDING="$PBF_BOUNDING" \
    -v $DATA \
    -v $TILES \
    $IMAGE \
    import && 
    touch imported &&
    docker rm osm-tile-server-import --force &&
    bash install.sh
fi

