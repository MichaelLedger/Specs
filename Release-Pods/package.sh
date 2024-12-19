#!/bin/bash
echo "start generate static library $1"
bundle exec pod package $1  --force --no-mangle --verbose