#!/bin/bash

docker run -td --privileged=true --network=bridge -v /sys/fs/cgroup/:/sys/fs/cgroup:ro -v /tmp/$(mktemp -d):/run strongswan

