#!/bin/bash

set -ex

WORKDIR="/go/src/github.com/${GITHUB_REPOSITORY}"

mkdir -p "$(dirname "${WORKDIR}")"
ln -s "${GITHUB_WORKSPACE}" "${WORKDIR}"
if [[ -n ${BUILD_DIR} ]]; then
    cd ${BUILD_DIR}
fi
go get -v ./...
go build

UPLOAD_URL="$(jq -r .release.upload_url "$GITHUB_EVENT_PATH")"
UPLOAD_URL="${UPLOAD_URL/\{?name,label\}/}"
TAG="$(jq -r .release.tag_name "$GITHUB_EVENT_PATH")"
if [[ -n ${BIN_NAME} ]]; then
    BIN_NAME="$(basename "$GITHUB_REPOSITORY")"
fi
SUFFIX="${BIN_NAME}_${TAG}_${GOOS}_${GOARCH}"

case "$GOOS" in
   "windows") 
        FILE_NAME="${BIN_NAME}.exe"
        GZ_NAME="${FILE_NAME}-${SUFFIX}.zip"
        CONTENT_TYPE="zip"
        zip -v -9 "${GZ_NAME}" "${FILE_NAME}"
        ;;
   *)
        FILE_NAME="${BIN_NAME}"
        GZ_NAME="${FILE_NAME}-${SUFFIX}.tar.gz"
        CONTENT_TYPE="gzip"
        tar cvfz "${GZ_NAME}" "${FILE_NAME}"
        ;;
esac

CHECKSUM=$(md5sum ${GZ_NAME} |awk '{print $1}')

set +x
curl -X POST --data-binary "@${GZ_NAME}" \
  -H "Content-Type: application/${CONTENT_TYPE}" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${GZ_NAME}"

curl -X POST --data "$CHECKSUM" \
  -H "Content-Type: text/plain" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${GZ_NAME}-checksum.txt"
