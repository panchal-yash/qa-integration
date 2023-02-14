#!/bin/bash
set -e

docker network create qa-integration || true
docker network create pmm-qa || true
docker network create pmm-ui-tests_pmm-network || true
docker network create pmm2-upgrade-tests_pmm-network || true
docker-compose -f docker-compose-rs.yaml down -v --remove-orphans
docker-compose -f docker-compose-rs.yaml build
docker-compose -f docker-compose-rs.yaml up -d
echo
echo "waiting 30 seconds for replica set members to start"
sleep 30
echo
bash -x ./configure-replset.sh
bash -x ./configure-agents.sh
