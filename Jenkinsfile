pipeline {
    agent any

    environment {
        NODE_HOME = tool name: 'NodeJS 22', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
        PATH = "${env.NODE_HOME}/bin:${env.PATH}"
        DOCKER_IMAGE = "nodeapp:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nilankh/Devops.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy to Target (Node.js app)') {
            steps {
                sh '''
                    pkill -f "node index.js" || true
                    nohup node index.js > app.log 2>&1 & disown
                '''
            }
        }

        stage('Deploy to Docker') {
            steps {
                sh '''
                    docker stop nodeapp || true
                    docker rm nodeapp || true
                    docker run -d --rm -p 4444:4444 --name nodeapp nodeapp:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                writeFile file: 'deployment.yaml', text: """
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeapp-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nodeapp
  template:
    metadata:
      labels:
        app: nodeapp
    spec:
      containers:
      - name: nodeapp
        image: nodeapp:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 4444
---
apiVersion: v1
kind: Service
metadata:
  name: nodeapp-service
spec:
  selector:
    app: nodeapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 4444
"""
                sh '''
                    kubectl apply -f deployment.yaml
                '''
            }
        }
    }
}
