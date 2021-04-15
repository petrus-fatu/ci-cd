pipeline {

  environment {
    imagename = "flask-apps"
    dockerImage = ''
    ecrurl = "https://182952452433.dkr.ecr.us-east-2.amazonaws.com"
    ecrcredentials = "ecr:us-east-2:ecr-usage-credentials"
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

    stage('Build image') {
      steps {
        script {
          dockerImage = docker.build imagename
        }
      }
    }



    stage('Deploy image') {
      steps{
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')
          }
        }
      }
    }


    stage('Remove Unused docker image') {
      steps{
        sh "docker system prune --all"
      }
    }
  }
}

pipeline {

  environment {
    imagename = "ci-cd/test"
    dockerImage = ''
    ecrurl = "https://182952452433.dkr.ecr.us-east-2.amazonaws.com"
    ecrcredentials = "ecr:us-east-2:ecr-usage-credentials"
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

    stage('Build image') {
      steps {
        script {
          dockerImage = docker.build imagename
        }
      }
    }

    stage('SonarQube code scan') {
      steps {
        script {
          sonarScanner('category-service')
        }
      }
    }

    stage('Deploy image') {
      steps{
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')
          }
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

def sonarScanner(projectKey) {
  def scannerHome = tool 'sonarqube-scanner'
  withSonarQubeEnv("sonarqube") {
    if(fileExists("sonar-project.properties")) {
      sh "${scannerHome}/bin/sonar-scanner"
      }
    else {
      sh "${scannerHome}/bin/sonar-scanner \
        -Dsonar.projectKey=${projectKey} \
        -Dsonar.java.binaries=build/classes \
        -Dsonar.java.libraries=**/*.jar \
        -Dsonar.projectVersion=${BUILD_NUMBER}"
        }
      }
  timeout(time: 10, unit: 'MINUTES') {
    waitForQualityGate abortPipeline: true
  }
}