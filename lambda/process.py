import json
import urllib.parse

def lambda_handler(event, context):
    # Log the incoming event structure for troubleshooting
    print("Received event: " + json.dumps(event, indent=2))
    
    try:
        # Extract the bucket name and the uploaded file name from the S3 event metadata
        bucket = event['Records'][0]['s3']['bucket']['name']
        
        
        key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
        
        output_message = f"Image received: [{key}]"
        print(output_message)
        
        return {
            'statusCode': 200,
            'body': json.dumps(f"Successfully processed asset metadata for {key}")
        }
    except Exception as e:
        print(e)
        print(f"Error getting object {key} from bucket {bucket}. Make sure it exists and your bucket is in the same region as this function.")
        raise e