#!/bin/bash

set -u
set -x

readonly PACKAGE="${1}"
readonly VERSION="${2}"
readonly TMP_DIR="${PACKAGE}_${VERSION}"

sudo yum update -y
sudo yum groupinstall -y 'Development Tools'

mkdir "${TMP_DIR}"
pushd "${TMP_DIR}"

readonly ENV="env-${PACKAGE}-${VERSION}"
virtualenv "${ENV}"
set +u; source "${ENV}/bin/activate"; set -u
pip install --upgrade pip

readonly TARGET_DIR='target'
pip install --verbose --use-wheel --no-dependencies --target "${TARGET_DIR}" "${PACKAGE}==${VERSION}"
set +u; deactivate; set -u

pushd "${TARGET_DIR}"
tar -cvzf "../../${PACKAGE}-${VERSION}.tar.gz" *
popd

popd
rm -rf "${TMP_DIR}"
