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
                sh "go build -o main main.go"
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'admin', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan -H target >> ~/.ssh/known_hosts

                        ssh -i "$SSH_KEY" "$SSH_USER"@target 'sudo systemctl stop main.service || true'

                        scp -i "$SSH_KEY" main "$SSH_USER"@target:
                        scp -i "$SSH_KEY" main.service "$SSH_USER"@target:

                        ssh -i "$SSH_KEY" "$SSH_USER"@target '
                            sudo mv ~/main.service /etc/systemd/system/main.service
                            sudo systemctl daemon-reload
                            sudo systemctl enable main.service
                            sudo systemctl restart main.service
                        '
                    '''
                }
            }
        }
    }
}
