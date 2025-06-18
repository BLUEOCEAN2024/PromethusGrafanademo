pipeline {
    agent any

    tools {
        maven 'M3' // Must be configured in Jenkins Global Tools
    }

    environment {
        DOCKER_IMAGE = 'hellojenkins-demo'
        DOCKER_REPO = 'chancf89-dev'
        OPENSHIFT_SERVER = 'https://api.rm1.0a51.p1.openshiftapps.com:6443'
        OPENSHIFT_PROJECT = 'chancf89-dev'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/BLUEOCEAN2024/PromethusGrafanademo.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    sh "docker tag ${DOCKER_IMAGE} docker.io/${DOCKER_REPO}/${DOCKER_IMAGE}"

                    withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_REPO} --password-stdin"
                    }

                    sh "docker push docker.io/${DOCKER_REPO}/${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to OpenShift') {
            steps {
                withCredentials([string(credentialsId: 'openshift-token', variable: 'OC_TOKEN')]) {
                    sh """
                    oc login ${OPENSHIFT_SERVER} --token=${OC_TOKEN}
                    oc project ${OPENSHIFT_PROJECT}
                    oc set image deployment/${DOCKER_IMAGE} ${DOCKER_IMAGE}=docker.io/${DOCKER_REPO}/${DOCKER_IMAGE} --record
                    """
                }
            }
        }
    }
}