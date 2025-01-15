# Set up logging
import json
import os
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Import Boto 3 for AWS Glue
import boto3
client = boto3.client('glue')

# Variables for the job: 
glueCrawlerJobName = "my_demo_glue_crawler"

# Define Lambda function
def lambda_handler(event, context):
    logger.info('## INITIATED BY S3 DROP EVENT: ')
    try:
       client.start_crawler(Name='my_demo_glue_crawler')
    except Exception as e:
        print(e)
        print('Error starting crawler')
        raise e
    logger.info('## STARTED GLUE CRAWLER JOB: ' + glueCrawlerJobName)
    logger.info('## GLUE JOB RUN ID: ' + response['JobRunId'])
    return response