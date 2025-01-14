#!/bin/bash 

if [ -z "$1" ]; then 
    echo -e "\e[31m Component name is required \n example usage is: \n\t bash create-server.sh componentName \e[0m"   
    exit 1 
fi 

COMPONENT=$1
ZONE_ID="Z00636481OT8FNJLH82AQ"

AMI_ID="$(aws ec2 describe-images --region us-east-1 --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')"
SGID="$(aws ec2 describe-security-groups   --filters Name=group-name,Values=B51-allow-all | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"
echo "AMI ID Used to launch instance is : $AMI_ID"
echo "SG ID Used to launch instance is : $SGID"
echo $COMPONENT

createServer() {
    PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SGID  --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"| jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

    sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/$COMPONENT/" route53.json > /tmp/dns.json 

    echo -n "Creating the DNS Record ********"
    aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file:///tmp/dns.json | jq 
}

if [ "$1" == "all" ]; then 
    for component in frontend1 catalogue cart user shipping payment mongodb1 mysql rabbitmq redis; do 
        COMPONENT=$component
        createServer
    done 
else 
        createServer 
fi 
