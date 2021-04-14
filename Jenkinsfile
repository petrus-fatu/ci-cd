#!groovy

import groovy.json.JsonSlurper
import java.net.URL

pipeline {

  environment {
    imagename = "ci-cd/test"
    dockerImage = ''
  }

  agent any
    options {
      timeout(time: 1, unit: 'DAYS')
       disableConcurrentBuilds()
    }

  stages {
    stage('Checkout SCM') {
      steps {
        checkout scm
      }
    }

    stage('Building image') {
      steps {
        script {
          dockerImage = docker.build imagename
        }
      }
    }

    stage('Remove Unused docker image') {
      steps{
      sh "docker rmi $imagename:$BUILD_NUMBER"
      sh "docker rmi $imagename:latest"
      }
    }
  }
}
