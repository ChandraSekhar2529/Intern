provider "aws"{
	region ="us-west-2"
}

resource "aws_s3_bucket" "myBucket"{
	bucket_prefix= var.bucket_prefix
	acl = var.acl
	tags= var.tags
}


resource "aws_iam_policy" "jsonencode"{
	name = "tf-jsonencode"
	policy = jsonencode({

	    "Version": "2012-10-17"
 	    "Statement"= [
 	        {
          	  "Effect"= "Allow",
           					
          	  "Action"=[ "s3:ListBucket"],
           					
     		   "Resource"= [
        		
        			aws_s3_bucket.myBucket.arn
      		    ]
     		

       		  },
		  {
          	    "Effect"= "Allow",
           					
          	    "Action"=[ "s3:GetObject",
				"s3:PutObject"
 			],
           					
     		    "Resource"= [
        		
        			"${aws_s3_bucket.myBucket.arn}/*"
      		             ]
     						 
       		    }
    				        
              ] 
	})

}





