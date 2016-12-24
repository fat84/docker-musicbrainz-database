cd mbslave
sed -i "/token=/token=34WjtNMLtA9h6glaBehZJ1OXH8cf8uc8GpfLn3zr/g"  mbslave.conf 

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

./mbslave-import.py ../mbdata/mbdump.tar.bz2 ../mbdata/mbdump-derived.tar.bz2

./mbslave-remap-schema.py <sql/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/statistics/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/caa/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/wikidocs/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/documentation/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/CreateIndexes.sql | grep -v musicbrainz_collate | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/CreateSlaveIndexes.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/statistics/CreateIndexes.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/caa/CreateIndexes.sql | ./mbslave-psql.py
./mbslave-remap-schema.py <sql/CreateViews.sql | ./mbslave-psql.py
