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
         stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'admin-id', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan -H 3.92.24.77 >> ~/.ssh/known_hosts

                        ssh -i "$SSH_KEY" "$SSH_USER"@3.92.24.77 'sudo systemctl stop main.service || true'

                        scp -i "$SSH_KEY" main "$SSH_USER"@3.92.24.77:
                        scp -i "$SSH_KEY" main.service "$SSH_USER"@3.92.24.77:

                        ssh -i "$SSH_KEY" ubuntu@3.92.24.77 '
                            sudo mv ~/main.service /etc/systemd/system/main.service
                            sudo systemctl daemon-reload
                            sudo systemctl enable --now main.service
                            sudo systemctl enable main.service
                            sudo systemctl restart main.service
                        '
                    '''
                }
            }
        }
    }
}