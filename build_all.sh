#!/bin/bash

set -e

PROJECT_DIR=$(dirname "$(realpath "$0")")

cd "$PROJECT_DIR"

echo "Do bazel build"
bazelisk build //...  -- -//iPhone/...

echo "Do xcodebuild"
xcodebuild \
    -project GTM.xcodeproj \
    -scheme GTM \
    -configuration Debug \
    build test

xcodebuild \
    -project GTMiPhone.xcodeproj \
    -scheme GTMiPhone \
    -configuration Debug \
    -destination "platform=iOS Simulator,name=iPhone 15,OS=18.5" \
    build test

echo "Do pod lib lint"
pod lib lint --verbose \
    --configuration=Debug \
    GoogleToolboxForMac.podspec

echo "Successfully built and tested GoogleToolboxForMac"
