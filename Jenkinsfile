pipeline {
    agent any
    
    environment {
        APP_PORT = "${BRANCH_NAME == 'main' ? '3000' : '3001'}"
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
        
        stage('Update Logo') {
            steps {
                script {
                    sh '''
                        echo "Current branch: ${BRANCH_NAME}"
                        if [ "${BRANCH_NAME}" = "main" ]; then
                            echo "Copying main logo..."
                            cp -v logos/main-logo.svg src/logo.svg
                        else
                            echo "Copying dev logo..."
                            cp -v logos/dev-logo.svg src/logo.svg
                        fi
                        
                        echo "Final logo in src directory:"
                        ls -la src/logo.svg
                    '''
                }
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
        
        stage('Build Docker Image') {
            steps {
                script {
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
}