node {
  def app

  docker.image('node:16-buster-slim').inside('-p 3000:3000') {
    stage('Build') {
      checkout scm // memastikan jenkins melakukan fetch/pull code terlebih dahulu
      sh 'npm install'
    }
    stage('Test') {
      sh './jenkins/scripts/test.sh'
    }
    stage('Manual Approval') {
      input message: 'Lanjutkan ke tahap Deploy? (Tekan tombol "Proceed" untuk melanjutkan)'
    }
    stage('Deploy') {
      sh './jenkins/scripts/deliver.sh'
      sleep time: 1, unit: 'MINUTES'
      //sh './jenkins/scripts/delay.sh'
      sh './jenkins/scripts/kill.sh'

      app = docker.build("abduzzy/react-app")
      docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
        app.push("${env.BUILD_NUMBER}")
        app.push("latest")
      }
  
      //TODO: do action to AWS
    }
  }
}
