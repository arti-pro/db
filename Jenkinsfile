pipeline {
    agent any

    parameters {
        string(name: 'staging_server', defaultValue: 'localhost', description: 'Staging Server')
    }

    environment {
        IMAGE_NAME = 'db-arti-pro'
        CONTAINER_NAME = 'db-arti-pro-container'
        JENKINS_SPRING_DATASOURCE_PASSWORD = credentials('JENKINS_SPRING_DATASOURCE_PASSWORD')
        JENKINS_SPRING_DATASOURCE_USERNAME = credentials('JENKINS_SPRING_DATASOURCE_USERNAME')
    }

    stages {
        stage('Docker Build and Run') {
            steps {
                script {
                    echo 'Building Docker image'
                    sh "docker build --no-cache -t ${IMAGE_NAME} ."


                    echo 'Stopping any existing container'
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    sh """
                        docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 5435:5432 \
                        -e POSTGRES_USER=${JENKINS_SPRING_DATASOURCE_USERNAME} \
                        -e POSTGRES_PASSWORD=${JENKINS_SPRING_DATASOURCE_USERNAME} \
                        -e POSTGRES_MULTIPLE_DATABASES="arti-pro",keycloak,grafana \
                        -v postgres_data:/var/lib/postgresql/data \
                        ${IMAGE_NAME}
                    """
                }
            }
            post {
                success {
                    echo 'Deployment successful'
                }
                failure {
                    echo 'Deployment failed'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up dangling Docker images'
            sh 'docker image prune -f'

            echo 'Cleaning up untagged Docker images'
            sh 'docker images | awk \'/<none>/ {print $3}\' | xargs -r docker rmi -f'
        }
    }
}
