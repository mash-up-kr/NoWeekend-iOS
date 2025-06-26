#!/bin/bash

# SRCROOT 자동 설정 (스크립트 위치 기준)
if [ -z "$SRCROOT" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  SRCROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"
fi

# Needle 바이너리 경로 확인
NEEDLE_BINARY="${SRCROOT}/Tuist/Dependencies/SwiftPackageManager/.build/release/needle"
if [[ ! -x "$NEEDLE_BINARY" ]]; then
    NEEDLE_BINARY="$(command -v needle)"
fi
if [[ -z "$NEEDLE_BINARY" || ! -x "$NEEDLE_BINARY" ]]; then
    echo "Needle binary not found. Please install needle first:"
    echo "   brew install needle"
    exit 1
fi

# 생성할 파일 경로
GENERATED_DIR="${SRCROOT}/Projects/App/DI/Sources/Generated"
GENERATED_FILE="${GENERATED_DIR}/NeedleGenerated.swift"
mkdir -p "$GENERATED_DIR"

echo "SRCROOT is: $SRCROOT"
echo "Generating Needle code..."

"$NEEDLE_BINARY" generate \
    --header-doc="" \
    "$GENERATED_FILE" \
    "${SRCROOT}/Projects/Feature/Home/Interface/Sources" \
    "${SRCROOT}/Projects/Feature/Profile/Interface/Sources" \
    "${SRCROOT}/Projects/Feature/Calendar/Interface/Sources" \
    "${SRCROOT}/Projects/Feature/Onboarding/Interface/Sources" \
    "${SRCROOT}/Projects/App/DI/Sources"

if [[ $? -eq 0 ]]; then
    echo "Needle code generation completed: $GENERATED_FILE"
else
    echo "Needle code generation failed"
    exit 1
fi