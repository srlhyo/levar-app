docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml up -d
docker cp dump.sql mysql_laravel:/dump.sql
docker exec -i mysql_laravel sh -c 'exec mysql -ularavel -plaravel laravel' < dump.sql
