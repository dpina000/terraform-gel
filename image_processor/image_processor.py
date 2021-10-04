import json
import urllib.parse
import boto3

print('Loading function')

s3 = boto3.resource('s3')

#we could compare if defined source bucket is the same as event
src_bucket = os.environ['bucket_a'
dst_bucket = os.environ['bucket_b']

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    obj = s3.Bucket( bucket ).Object( key ) 
    
    my_image = obj.get()['Body'].read()
    
    s3.Object(dst_bucket, key).put(Body=my_image,Metadata={})
