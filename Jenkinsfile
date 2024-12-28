pipeline {
    agent any
    
    environment {
        // Dynamic port assignment based on branch
        APP_PORT = "${BRANCH_NAME == 'main' ? '3000' : '3001'}"
        // Dynamic image name based on branch
        DOCKER_IMAGE = "${BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'}"
    }
    
    tools {
        nodejs 'NodeJS 7.8.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        
        stage('Update Logo') {
            steps {
                script {
                    // Copy appropriate logo based on branch
                    if (BRANCH_NAME == 'main') {
                        sh 'cp logos/main-logo.svg public/logo.svg'
                    } else {
                        sh 'cp logos/dev-logo.svg public/logo.svg'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with branch-specific tag
                    sh """
                        docker build -t ${DOCKER_IMAGE} \
                        --build-arg PORT=${APP_PORT} .
                    """
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing container for the current environment only
                    sh """
                        CONTAINER_NAME="${BRANCH_NAME}-app"
                        if docker ps -a | grep \$CONTAINER_NAME; then
                            docker stop \$CONTAINER_NAME
                            docker rm \$CONTAINER_NAME
                        fi
                        
                        docker run -d \
                            --name \$CONTAINER_NAME \
                            -p ${APP_PORT}:${APP_PORT} \
                            ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }
    
    post {
        failure {
            echo 'Pipeline failed! Sending notifications...'
        }
        success {
            echo 'Pipeline succeeded! Application deployed successfully.'
        }
    }
}