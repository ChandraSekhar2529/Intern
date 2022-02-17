import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodbTable = "StudentsData2"
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(dynamodbTable)

getMethod  = "GET"
postMethos = "POST"
deleteMethod = "DELETE"

def lambda_handler(event, context):
    logger.info(event)
    httpMethod = event["httpMethod"]
    k = 0
    if httpMethod == getMethod:
        response = getRecords() 
        k = 1
    elif httpMethod == postMethos:
        response = saveRecord(json.loads(event["body"]))
        k = 2
    elif httpMethod == deleteMethod:
        responseBody =json.loads(event["body"])
        response = deleteRecord(responseBody["StudentId"])
        k = 3
    else:
        response = buildResponse(404 ,"Not Found")
        k = 4
    
    print(k)
    return response
    
def getRecords():
    try:
        response = table.scan()
        result = response["Items"]
        
        
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey =response["LastEvaluatedKey"])
            result.extend(response['Items'])
        
       
        body = {

            "Records" : response
        }
        return buildResponse(200,body)
        
        
    except Exception as e:
        # logger.exception(e)
        print(e)

        
    
        
def saveRecord(requestBody):
    try:
        table.put_item(Item = requestBody)
        body = {
            "Operation": "PUT",
            "Message" : "SUCCESS",
            "Item" : requestBody
        }
        return buildResponse(200, body)
    except Exception as e:
        # logger.exception(e)
        print(e)
        
        
        
def deleteRecord(studentId):
    try:
        response = table.delete_item(
            Key = {
                 'StudentId':studentId
            },
            ReturnValues =  'ALL_OLD'
        )
        
        body = {
                "Operation" : "DELETE",
                "Message" : "SUCCESS",
                "DeletedItem" : response
        }
        return buildResponse(200, body)
        
    except Exception as e:
        # logger.exception(e)
        print(e)
        
        
        
        
def buildResponse(statusCode , body= None):
    response = {
        'statusCode' :statusCode,
        'headers':{
            'Content-Type' : 'application/json',
            'Access-Control-Allow-Origin' : '*'
        }
    }
    
    if body is not None:
        response["body"] = json.dumps(body)
        
    return response
   
