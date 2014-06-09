#!/bin/bash

DISABLE_DEPLOY_FLAG="/tmp/_REXIM_ME_DISABLE_DEPLOY"

function predate {
    while read line; do
        echo "$(date -R): $line"
    done
}

function fail {
    MESSAGE=$1
    touch "${DISABLE_DEPLOY_FLAG}"
    if [ ! -z "${ADMIN_EMAIL}" ]; then
        printf "${MESSAGE}\n\nPlease, remove ${DISABLE_DEPLOY_FLAG} when the problem is fixed.\n\nThanks." | mail -s "rexim.me: FAIL ON DEPLOY" "${ADMIN_EMAIL}"
    fi
    exit 1
}

# Check if the deploy is disabled
if [ -f "${DISABLE_DEPLOY_FLAG}" ]; then
    echo "[ERROR] Deploy is disabled. Remove ${DISABLE_DEPLOY_FLAG} to enable."
    exit 1
fi

# Reading config file
CONFIG_FILEPATH="/etc/rexim.me/deploy.conf"

if [ ! -f "${CONFIG_FILEPATH}" ]; then
    echo "[ERROR] ${CONFIG_FILEPATH} was not found"
    exit 1
fi

. /etc/rexim.me/deploy.conf

# Rotating log if needed
if [ -f "${PATH_TO_LOG}" ]; then
    if [ $(stat -c%s "${PATH_TO_LOG}") -ge "${MAX_LOG_SIZE}" ]; then
        TIMESTAMP=$(date +%s)
        gzip -c "${PATH_TO_LOG}" > "${PATH_TO_LOG}-${TIMESTAMP}.gz"
        rm "${PATH_TO_LOG}"
    fi
fi

# Redirecting to logs
exec > >(predate | tee -a "${PATH_TO_LOG}")
exec 2>&1

# Deploying
cd "${BLOG_GIT_DIRECTORY}"                        || fail "Cannot cd to the git directory \"${BLOG_GIT_DIRECTORY}\""
git fetch "${BLOG_GIT_REMOTE}"                    || fail "Cannot fetch the latest changes from the remote \"${BLOG_GIT_REMOTE}\""
git diff --exit-code "${BLOG_GIT_BRANCH}" "${BLOG_GIT_REMOTE}/${BLOG_GIT_BRANCH}" > /dev/null && exit 0
git merge "${BLOG_GIT_REMOTE}/${BLOG_GIT_BRANCH}" || fail "Cannot merge the latest changes to the branch \"${BLOG_GIT_BRANCH}\""
./generate_pages.pl                               || fail "Cannot generate the pages"
rm -rfv "${BLOG_DIRECTORY}"                       || fail "Cannot remove the blog directory \"${BLOG_DIRECTORY}\""
cp -rv ./html/ "${BLOG_DIRECTORY}"                || fail "Cannot copy generated pages to the blog directory \"${BLOG_DIRECTORY}\""
chown -Rv "${BLOG_USER}:${BLOG_GROUP}" "${BLOG_DIRECTORY}" || fail "Cannot change user and group of the blog directory \"${BLOG_DIRECTORY}\" to ${BLOG_USER}:${BLOG_GROUp}"
echo "[DONE]"

exit 0
