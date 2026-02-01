#!/bin/bash

# Yeni Uygulama Kurulum Yapısına Uygun Portainer Stack
# Bu YAML, Traefik (edge network) üzerinden çalışacak şekilde ayarlanmıştır.

cat << 'YAML_END'
version: '3.8'

services:
  onfuture:
    container_name: onfuture-web
    restart: unless-stopped
    build:
      context: https://github.com/aliyabuz25/onfuture-web-2.git
      dockerfile: Dockerfile
    environment:
      - NODE_ENV=production
      - PORT=6985
    volumes:
      - /datastore/onfuture/logs.json:/app/logs.json
    networks:
      - edge
    labels:
      - 'traefik.enable=true'
      - 'traefik.docker.network=edge'
      - 'traefik.http.routers.onfuture.rule=Host(`onfuture.az`) || Host(`www.onfuture.az`)'
      - 'traefik.http.routers.onfuture.entrypoints=web'
      - 'traefik.http.services.onfuture.loadbalancer.server.port=6985'
      - 'com.centurylinklabs.watchtower.enable=true'

networks:
  edge:
    external: true
YAML_END

echo ""
echo "=========================================="
echo "TRAEFIK + EDGE NETWORK KURULUM TƏLİMATI"
echo "=========================================="
echo ""
echo "1. Host'da 'edge' network'ün olduğunu yoxlayın: docker network ls | grep edge"
echo "2. Portainer'da yeni bir stack yaradın (Ad: onfuture)"
echo "3. Yuxarıdakı YAML kodunu yapışdırın."
echo "4. Cloudflare Tunnel üzərinden http://127.0.0.1:8080 ünvanına yönləndirin."
echo ""
echo "=========================================="
