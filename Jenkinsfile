pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    stages {
        stage('Test') {
                steps {
                    sh "go test ./..."
                }
            }
        stage('Build') {
            steps {
                sh '''
                    go build -o main main.go
                '''
            }
        }
        stage('Docker') {
            steps {
                sh '''
                    docker build -t helloapp .
                    docker tag helloapp ttl.sh/helloapp:2h
                    docker push ttl.sh/helloapp:2h
                '''
            }
        }
         stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'admin-id', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan -H docker >> ~/.ssh/known_hosts

                        ssh -i "$SSH_KEY" "$SSH_USER"@docker '

                            docker pull ttl.sh/helloapp:2h
                            docker stop helloapp || true
                            docker rm helloapp || true
                            docker run -d --name helloapp -p 4444:4444 ttl.sh/helloapp:2h
                        '
                    '''
                }
            }
        }
    }
}
