#!groovy

import groovy.json.JsonSlurper
import java.net.URL

pipeline {
    agent none
    options {
        timeout(time: 1, unit: 'DAYS')
        disableConcurrentBuilds()
    }
    stages {
        stage("Init") {
            agent any
            steps { echo step 1 }
        }
        stage("Run App Security Scan") {
            agent any 
            steps { echo step 3 }
        }
        stage("Build and Register Image") {
            agent any
            steps { echo step 4 }
        }
        stage("Deploy Image") {
            agent any
            steps { echo deploy step 1 }
        }
        stage("Test App") {
            agent any
            steps { echo test step }
        }
    }
}

