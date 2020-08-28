
## refs:
##   https://github.com/cloudbees/jnlp-slave-with-java-build-tools-dockerfile/blob/master/Dockerfile
##   https://github.com/cloudbees/java-build-tools-dockerfile/blob/master/Dockerfile
##
FROM jenkins/inbound-agent as builder

FROM media.dettonville.int:5000/cicd-build-tools
LABEL maintainer="Lee Johnson <ljohnson@dettonville.org>"

#################################################
# Inspired by
# https://github.com/cloudbees/jnlp-slave-with-java-build-tools-dockerfile
# https://github.com/cloudbees/java-build-tools-dockerfile/blob/master/Dockerfile
# https://github.com/SeleniumHQ/docker-selenium/blob/master/Base/Dockerfile
# https://github.com/bibinwilson/jenkins-docker-slave
# https://medium.com/@prashant.vats/jenkins-master-and-slave-with-docker-b993dd031cbd
#################################################

COPY --from=builder /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=builder /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

USER root

ARG user=jenkins

RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
RUN chmod 644 /usr/share/jenkins/agent.jar \
      && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

USER ${user}

ENTRYPOINT ["jenkins-agent"]
