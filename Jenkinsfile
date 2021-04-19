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
    stage('Checkout Version Control') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build imagename
        }
      }
    }

    stage('SonarQube Code Scan') {
      environment {
        SCANNER_HOME = tool 'sonarqube-scanner'
        ORGANIZATION = "Administrator"
        PROJECT_NAME = "flask-app-python"
      }
      steps {
        withSonarQubeEnv('sonar-qube') {
            sh "$SCANNER_HOME/bin/sonar-scanner \
            -Dsonar.java.binaries=build/classes/java/ \
            -Dsonar.projectKey=$PROJECT_NAME \
            -Dsonar.sources=."
        }
      }
    }

    stage("SonarQube Quality Gate") {
      steps {
        waitForQualityGate abortPipeline: true
        }
      }

    stage('Deploy Docker Image') {
      when {
        branch "develop"
           }
        steps {
          script {
            docker.withRegistry(ecrurl, ecrcredentials) {
              dockerImage.push("$BUILD_NUMBER")
              dockerImage.push('latest')
          }
        }
      }
    }

    stage('Remove Docker Images') {
      steps{
        sh "docker system prune -f --all"
      }
    }
  }

  post {
    success {
        setBuildStatus("Build succeeded", "SUCCESS");
    }
    failure {
        setBuildStatus("Build failed", "FAILURE");
    }
  }
}

if (currentBuild.getBuildCauses().toString().contains('BranchIndexingCause')) {
  print "INFO: Build skipped due to trigger being Branch Indexing"
  currentBuild.result = 'ABORTED'
  return
}

void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/petrus-fatu/ci-cd"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}
