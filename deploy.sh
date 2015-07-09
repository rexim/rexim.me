#!/bin/sh

if [ ! -f ./deploy.config ]; then
    echo "Please create ./deploy.config file."
    echo "Use ./deploy.config.example as an example."
    exit 1
fi

. ./deploy.config

echo "Blog directory: ${BLOG_DIRECTORY}"
echo "Blog user: ${BLOG_USER}"
echo "Blog group: ${BLOG_GROUP}"
echo "----------"
echo "Enter to depoy, ^C to cancel"

read SKIP

./site.pl
rm -rfv ${BLOG_DIRECTORY}
cp -rv ./html/ ${BLOG_DIRECTORY}
chown -Rv ${BLOG_USER}:${BLOG_GROUP} ${BLOG_DIRECTORY}

echo "DONE"
