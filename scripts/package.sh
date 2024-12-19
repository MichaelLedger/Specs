#!/bin/bash
echo "bundle exec pod package $1 --force --no-mangle --verbose"
bundle exec pod package $1 --force --no-mangle --verbose
