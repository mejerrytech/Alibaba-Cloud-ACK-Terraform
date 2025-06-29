auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2022-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /tmp/loki/index
    cache_location: /tmp/loki/cache
    shared_store: filesystem

  filesystem:
    directory: /tmp/loki/chunks

wal:
  dir: /wal

limits_config:
  max_streams_per_user: 1000

chunk_store_config:
  max_look_back_period: 0

table_manager:
  retention_deletes_enabled: false
  retention_period: 10h
