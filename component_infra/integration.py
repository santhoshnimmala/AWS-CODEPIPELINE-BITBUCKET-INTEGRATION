import json
import os 
import boto3

s3_client = boto3.client('s3')

def handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    body = json.loads(event['body'])
    projectName= body['repository']['project']['key']
    
    repoName= body['repository']['name']
    branch= body['changes'][0]['ref']['displayId']
    project_url=os.environ.get('project_url')
    s3_bucket=os.environ.get('s3_bucket')
    token=os.environ.get('token')

    header=f"Authorization: Bearer {token}"
    target=f"{project_url}/rest/api/latest/projects/{projectName}/repos/{repoName}/archive?at=refs/heads/{branch}&format=zip"
    output=f'{branch}.zip'
    print(header,target,output)
    os.system(f'curl -L --header "{header}" "{target}" -o "/tmp/{output}"')

    response = s3_client.upload_file(f"/tmp/{output}",s3_bucket , output)
    return {
        "statusCode": 200,
        "body": response
    }