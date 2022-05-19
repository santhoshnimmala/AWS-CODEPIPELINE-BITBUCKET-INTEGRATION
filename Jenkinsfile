pipeline {
    agent any
    stages {
        stage('Copy to s3') {
            steps {
                withAWS(credentials: 'aws', region: 'eu-central-1') {
                   s3Upload(file:'component_infra', bucket:'artifacts.build.eu-central-1.ccoe.luxoft.com', path:'${env.BRANCH_NAME}')
                    
                }
            }
        }
    }
}
