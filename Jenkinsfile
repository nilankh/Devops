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
                    withCredentials([string(credentialsId: 'k-token', variable: 'K_TOKEN')]) {
                        sh '''
                            kubectl config set-cluster my-cluster --server=https://k8s:6443 --insecure-skip-tls-verify=true
                            kubectl config set-credentials jenkins --token=$K_TOKEN
                            kubectl config set-context jenkins-context --cluster=my-cluster --user=jenkins
                            kubectl config use-context jenkins-context

                            kubectl apply -f definition.yaml
                        '''
                    }
                }
            }

        }
    }