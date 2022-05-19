pipeline {
    agent any
    stages {
        stage('Copy to s3') {
            steps {
                withAWS(credentials: 'aws', region: 'eu-central-1') {
                    s3Upload(file:'AWS-CODEPIPELINE-BITBUCKET-INTEGRATION', bucket:'AWS-CODEPIPELINE-BITBUCKET-INTEGRATION', path:'${env.BRANCH_NAME}')
                    
                }
            }
        }
    }
}
