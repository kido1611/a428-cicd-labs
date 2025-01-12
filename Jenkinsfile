node {
  def app

  def remote = [:]
  remote.name = "aws-server"
  remote.allowAnyHosts = true

  docker.image('node:16-buster-slim').inside('-p 3000:3000') {
    stage('Build') {
      checkout scm // memastikan jenkins melakukan fetch/pull code terlebih dahulu

      sh 'npm install'
    }
    stage('Test') {
      sh './jenkins/scripts/test.sh'
    }
  }
  stage('Manual Approval') {
    input message: 'Lanjutkan ke tahap Deploy? (Tekan tombol "Proceed" untuk melanjutkan)'
  }
  stage('Deploy') {
    // Harus dihapus di production. Ditaambahkan karena sesuai dengan submission 1
    docker.image('node:16-buster-slim').inside('-p 3000:3000') {
      sh './jenkins/scripts/deliver.sh'
      sleep time: 1, unit: 'MINUTES'
      sh './jenkins/scripts/kill.sh'
    }

    // Build docker image for production
    app = docker.build('abduzzy/react-app')
    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
      app.push("${env.BUILD_NUMBER}")
      app.push("latest")
    }

    // Untuk memastikan docker image terbaru sudah ada di docker hub
    sleep time: 10, unit: 'SECONDS'

    withCredentials([sshUserPrivateKey(credentialsId: 'aws-server', keyFileVariable: 'identity',  usernameVariable: 'userName'), string(credentialsId: 'server-ip', variable: 'ip')]) {
      remote.host = ip 
      remote.user = userName
      remote.identityFile = identity

      sshCommand remote: remote, command: 'docker compose pull'
      // memastikan docker image terbaru sudah diambil
      sshCommand remote: remote, command: 'docker image pull abduzzy/react-app:latest'

      sshCommand remote: remote, command: 'docker compose down'
      sshCommand remote: remote, command: 'docker compose up -d'
    }
  }
}
