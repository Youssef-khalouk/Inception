#!/bin/sh
set -e

redis-server /etc/redis/redis.conf \
    --maxmemory 256mb \
    --maxmemory-policy allkeys-lru \
    --bind 0.0.0.0 \
    --protected-mode no \
    --daemonize no