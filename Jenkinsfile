#!groovy

import groovy.json.JsonSlurper
import java.net.URL

pipeline {
  agent any
    options {
        timeout(time: 1, unit: 'DAYS')
        disableConcurrentBuilds()
    }
  environment {
    DOCKER_CERT_PATH = credentials('ecr-usage-credentials')
  }
  stages {
    stage('testing') {
      steps {
        sh "ls -l" // DOCKER_CERT_PATH is automatically picked up by the Docker client
      }
    }
  }
}

