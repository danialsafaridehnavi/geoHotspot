# Hotspot

Web API to keep track and search for Point of Interest

Server API
==========
## hotspot
		
* api
```
get /api/hotspot - list hotspot for specified pagination/sorting parameters skip, limit, sort
post /api/hotspot - create a hotspot item with the specified attributes excluding id
put /api/hotspot/:id - update hotspot attributes of the specified id
delete /api/hotspot/:id - delete hotspot item of the specified id
post /api/hotspot/:id/tag/:fk - tag the specified hotspot with existing tag
delete /api/hotspot/:id/tag/:fk - untag the specified hotspot for the input tag
```

Configuration
=============
* save docker-compose.yml and .env into local directory
* update environment variables defined in .env
* docker-compose -f docker-compose.yml up -d
