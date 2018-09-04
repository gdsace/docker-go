#!/bin/sh
IMAGE_URL=$1
IMAGE_TAG=$2;

REPOSITORY_URL=${IMAGE_URL}:${IMAGE_TAG};
TAG="${REPOSITORY_URL}-next";
TAG_LATEST="${REPOSITORY_URL}-latest";

VERSIONS=$(docker run --entrypoint="version-info" ${TAG});
VERSION_GO=$(printf "${VERSIONS}" | grep -e 'go:' | cut -f 2 -d ':');
GO_VERSION_REPO_URL="${REPOSITORY_URL}-${VERSION_GO}";

printf "Checking existence of [${GO_VERSION_REPO_URL}]...";
$(docker pull ${GO_VERSION_REPO_URL}) && EXISTS=$?;
if [ "${EXISTS}" != "0" ] || [ -z "${COMMIT_MESSAGE##*'[force build]'*}" ]; then
  printf "[${GO_VERSION_REPO_URL}] not found. Pushing new image...\n";
  printf "Pushing [${TAG_LATEST}]... ";
  docker tag ${TAG} ${TAG_LATEST};
  docker push ${TAG_LATEST};
  printf "Pushing [${GO_VERSION_REPO_URL}]... ";
  docker tag ${TAG} ${GO_VERSION_REPO_URL};
  docker push ${GO_VERSION_REPO_URL};
else
  printf "[${GO_VERSION_REPO_URL}] found. Skipping push.\n";
  echo exists;
fi;