pipeline {
    agent { label "dev" }

    stages {

        stage("Cloning/Pulling Stage") {
            steps {
                echo "Cloning code"

                git url: "https://github.com/aqsa890/flask-app.git",
                    branch: "main"
            }
        }

        stage("Build") {
            steps {
                echo "Building the 2 tier flask app from Dockerfile"

                sh "docker build -t myflask-app:v1.0.0 ."
            }
        }

        stage("Test") {
            steps {
                echo "Testing"
            }
        }

        stage("Push to Docker HUB") {
            steps {
                echo "Pushing image"

                withCredentials([
                    usernamePassword(
                        credentialsId: "dockerHubCreds",
                        passwordVariable: "dockerHubPass",
                        usernameVariable: "dockerHubUser"
                    )
                ]) {

                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"

                    sh "docker image tag myflask-app:v1.0.0 ${env.dockerHubUser}/myflask-app:v1.0.0"

                    sh "docker push ${env.dockerHubUser}/myflask-app:v1.0.0"
                }
            }
        }

        stage("Deploy") {
            steps {
                echo "Deploying"

                sh "docker compose up -d --build flask-app"
            }
        }
    }

    post {

        success {
            script {
                emailext(
                    from: 'cutilicious1947@gmail.com',
                    to: 'rkkhan0750@gmail.com',
                    subject: "SUCCESS: Flask App CI/CD Pipeline - Build #${BUILD_NUMBER}",
                    body: """
Hello,

The Flask App CI/CD pipeline has completed successfully.

Build Details:
------------------------------
Project     : Flask App
Build No.   : #${BUILD_NUMBER}
Status      : SUCCESS
Branch      : ${env.GIT_BRANCH}
Commit      : ${env.GIT_COMMIT}
Job         : ${env.JOB_NAME}
Build URL   : ${env.BUILD_URL}

The application was successfully built, tested, pushed to Docker Hub,
and deployed successfully.

Regards,
Jenkins CI/CD Pipeline
""".stripIndent()
                )
            }
        }

        failure {
            script {
                emailext(
                    from: 'cutilicious1947@gmail.com',
                    to: 'rkkhan0750@gmail.com',
                    subject: 'Build Failure - Flask App CI/CD',
                    body: 'Build failed for Flask App CI/CD Pipeline. Please check the Jenkins console output.'
                )
            }
        }
    }
}
