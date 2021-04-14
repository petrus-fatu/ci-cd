#!groovy

import groovy.json.JsonSlurper
import java.net.URL

pipeline {
  agent any
    options {
        timeout(time: 1, unit: 'DAYS')
        disableConcurrentBuilds()
    }
  tools {
    'org.jenkinsci.plugins.docker.commons.tools.DockerTool' '1.17'
  }
  environment {
    DOCKER_CERT_PATH = credentials('id-for-a-docker-cred')
  }
  stages {
    stage('foo') {
      steps {
        sh "docker version" // DOCKER_CERT_PATH is automatically picked up by the Docker client
      }
    }
  }
}

