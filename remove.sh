docker rm osm-tile-server-import --force
docker rm osm-tile-server --force
docker volume rm osm-data
docker volume rm osm-tiles
rm imported