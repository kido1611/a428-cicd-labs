node {
  def app

  //docker.image('node:16-buster-slim').inside('-p 3000:3000') {
  stage('Build') {
    checkout scm // memastikan jenkins melakukan fetch/pull code terlebih dahulu

    app = docker.build("abduzzy/react-app")
    //sh 'npm install'
  }
  stage('Test') {
    docker.image('abduzzy/react-app').inside() {
      sh './jenkins/scripts/test.sh'
    }
  }
  //}
  stage('Manual Approval') {
    input message: 'Lanjutkan ke tahap Deploy? (Tekan tombol "Proceed" untuk melanjutkan)'
  }
  stage('Deploy') {
    docker.image('abduzzy/react-app').inside() {
      sh './jenkins/scripts/deliver.sh'
      sleep time: 1, unit: 'MINUTES'
      sh './jenkins/scripts/kill.sh'
    }

    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
      app.push("${env.BUILD_NUMBER}")
      app.push("latest")
    }

//TODO: build docker image
//TODO: push docker image
//TODO: do action to AWS
//1. ssh server
//2. docker compose pull
//3. docker compose stop
//4. docker compose up -d

  }
}
