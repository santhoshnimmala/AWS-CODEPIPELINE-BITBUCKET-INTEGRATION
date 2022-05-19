pipeline {
    agent any
    stages {
        stage('Copy to s3') {
            steps {
                withAWS(credentials: 'aws', region: 'eu-central-1') {
                   sh 'env.BRANCH_NAME'
                   sh 'ls'
                    
                }
            }
        }
    }
}
