#!/bin/bash

PORT=${PORT:-4567}
echo "Starting server on port $PORT..."
puma -p $PORT -R config.ru
