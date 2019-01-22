################################################################################################################
#!/bin/bash
# initial creation: 4.13.2018
# This script is intended to be run on a Linux like system. Cygwin will work as well.
# Get-Session-Token
# The running of this script generates a session token and temporary Keys, allowing for MFA applied to the AWS CLI
# Create shell script to get the session token and write it to the credentials file
# Token will have to be entered manually, in lieu of using the Google API to do so.
#
#Session Token work for AWS CLI MFA
#
#https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/
#Command: aws sts get-session-token --profile <yourprofilename> --serial-number <yourawsmfadeviceserialnumber> --token-code <yourdevicegeneratedcode> 
# {
#    "Credentials": {
#        "SecretAccessKey": "234123434",
#        "SessionToken": "34214342432413434",
#        "Expiration": "2018-04-07T07:26:21Z",
#        "AccessKeyId": "32412434234"
#    }
#}
#
# sbo 8.01.2018 - 	prompt for the profile first, which will render the mfa_serial available
#			running the get-session-token command leverages the user's typical credentials to get the session token and temp keys
#			prompt for the session token, and run the get-session-token 
# sbo 08.02.2018 -	prompts for the profile only if it hasn't been passed in from another script
#
# to do:			Existing scripts will need to evaluate the Expiration of the temporary credentials
#					to determine if they are still valid, or if the script should call the AWS Get Session Token script
################################################################################################################

##   Declare Functions   #####################################
# define funtion to prompt for AWS profile
aws_profile () {
	# If the AWS profile hasn't been exported in from another script, prompt for it
	if [ -z "$PROFILE" ]; then
		#Prompt for the profile
		read -p "AWS profile: " PROFILE
	fi

	AWS_ACCOUNT=`aws iam list-account-aliases --profile $PROFILE --output text | awk '{print $2}'`
	echo "AWS Account set to: "$AWS_ACCOUNT""
	
	
	# call the function mfa_device
	mfa_device
}

##   Declare Functions   #####################################
# define funtion to get the profile's mfa device serial number
mfa_device () {
	#Use the profile to get the mfa device serial number
	SERIAL=`aws iam list-mfa-devices --profile $PROFILE --output text | awk '{print $3}'`

	# call the function to get-mfa-token
	get-mfa-token

}

# define function to get-session-token
get-mfa-token () {

	echo
	#Prompt for the profile
	read -p "MFA Token: " TOKEN
	
	# call the function to get-session-token
	get-session-token
}

# define function to get-session-token
get-session-token () {

	echo 
	#aws sts get-session-token --serial-number $SERIAL --token-code $TOKEN --profile $PROFILE
	aws sts get-session-token --serial-number $SERIAL --token-code $TOKEN --profile $PROFILE --no-verify-ssl --output text > temp_creds
	# cat the temporary credentials and grab the second field and export it as the AWS_ACCESS_KEY_ID
	export AWS_ACCESS_KEY_ID=`cat temp_creds | awk '{print $2}'`
	# cat the temporary credentials and grab the fourth field and export it as the AWS_SECRET_ACCESS_KEY
	export AWS_SECRET_ACCESS_KEY=`cat temp_creds | awk '{print $4}'`
	# cat the temporary credentials and grab the fifth field and export it as the AWS_SESSION_TOKEN
	export AWS_SESSION_TOKEN=`cat temp_creds | awk '{print $5}'`

	# call the function to configure the temp credentials
	configure-temp-creds
}

# define function to write the temporary credentials to the AWS config and credentials files
configure-temp-creds () {
	echo Running aws config to configure the temp profile
	aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile $PROFILE-mfa
	aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile $PROFILE-mfa
	aws configure set aws_session_token $AWS_SESSION_TOKEN --profile $PROFILE-mfa
	aws configure set region us-east-1 --profile $PROFILE-mfa
	aws configure set output json --profile $PROFILE-mfa

	set-aws-context
}

set-aws-context() {
	echo Setting awscli context to $PROFILE-mfa
	export AWS_PROFILE=$PROFILE-mfa
}

# define function to clean things up
clean_up () {

	echo "Cleaning up variables"
#	unset PROFILE
	unset AWS_ACCOUNT
	unset SERIAL
	unset DATE
	unset ARN
	unset TOKEN
	unset AWS_ACCESS_KEY_ID
	unset AWS_SECRET_ACCESS_KEY
	unset AWS_SESSION_TOKEN
	rm temp_creds
	
	exit
}


##   Main   ####################################################################################################

# call the function dn_entry
aws_profile

# call the function to clean things up
clean_up
