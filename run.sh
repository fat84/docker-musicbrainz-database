cd mbslave

createuser musicbrainz
createdb -l C -E UTF-8 -T template0 -O musicbrainz musicbrainz
createlang plpgsql musicbrainz
psql musicbrainz -c 'CREATE EXTENSION cube;'
psql musicbrainz -c 'CREATE EXTENSION earthdistance;'

echo 'CREATE SCHEMA musicbrainz;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA statistics;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA cover_art_archive;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA wikidocs;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA documentation;' | ./mbslave-psql.py -S

./mbslave-remap-schema.py <sql/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/statistics/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/caa/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/wikidocs/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/documentation/CreateTables.sql | ./mbslave-psql.py
