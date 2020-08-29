#!/bin/bash

# source: https://github.com/cloudbees/java-build-tools-dockerfile/blob/master/entry_point.sh

echo "jenkins user and group adjustments"
JENKINS_UID=${uid:-1000}
JENKINS_GID=${gid:-1000}

echo "get current jenkins uid/gid info inside container"
CUR_USER_GID=$(id -g jenkins || true)
CUR_USER_UID=$(id -u jenkins || true)

JENKINS_UIDGID_CHANGED=false
if [ "$uid" != "$CUR_USER_UID" ]; then
  echo "CUR_USER_UID (${CUR_USER_UID}) does't match uid (${uid}), adjusting..."
  usermod -o -u "$uid" jenkins
  JENKINS_UIDGID_CHANGED=true
fi
if [ "$gid" != "$CUR_USER_GID" ]; then
  echo "CUR_USER_GID (${CUR_USER_GID}) does't match gid (${gid}), adjusting..."
  groupmod -o -g "$gid" jenkins
  JENKINS_UIDGID_CHANGED=true
fi

echo '-------------------------------------'
echo 'jenkins GID/UID'
echo '-------------------------------------'
echo "User uid:    $(id -u jenkins)"
echo "User gid:    $(id -g jenkins)"
echo "uid/gid changed: ${JENKINS_UIDGID_CHANGED}"
echo "-------------------------------------"

# fix file permissions
if [ "${JENKINS_UIDGID_CHANGED,,}" == "true" ]; then
  echo "updating file uid/gid ownership"
  chown -R jenkins:jenkins /home/jenkins
fi

exec /usr/local/bin/jenkins-agent "$@"
