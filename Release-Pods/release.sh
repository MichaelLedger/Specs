#!/bin/bash
echo "bundle exec fastlane ios release_pod --env $1"
bundle exec fastlane ios release_pod --env $1
