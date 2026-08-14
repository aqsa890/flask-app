pipeline{
    agent { label "dev" };
        stages{
            stage("Cloning/Pulling Stage"){
                steps{
                    echo "Cloning code"
                    git url: "https://github.com/aqsa890/flask-app.git" ,branch: "main" 
                }
            }
            stage("Build"){
                steps{
                    echo "Building the 2 tier flask app from Dockerfile"
                    sh "docker build -t myflask-app:v1.0.0 ."
                }
            }
            stage("Test"){
                steps{
                    echo "Testing"
                }
            }
            stage("Push to Docker HUB"){
                steps{
                    echo "Pushing image"
                    withCredentials([usernamePassword(
                        credentialsId:"dockerHubCreds",
                        passwordVariable: "dockerHubPass",
                        usernameVariable: "dockerHubUser"
                        )
                        ]){
                        sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                        sh "docker image tag myflask-app:v1.0.0 ${env.dockerHubUser}/myflask-app:v1.0.0"
                        sh "docker push ${env.dockerHubUser}/myflask-app:v1.0.0"
                        }
                }
            }
            stage("Deploy"){
                steps{
                    echo "Deploying"
                    sh "docker compose up -d --build flask-app"
                }
            }
        }
}
