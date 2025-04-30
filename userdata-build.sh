#!/bin/bash
sudo yum -y update
sudo yum -y install git java-1.8.0-openjdk maven aws-cli

cd /home/ec2-user
git clone https://github.com/CeeyIT-Solutions/JavaWeb3.git >> build.log 2>&1
cd JavaWeb3
mvn package >> ../build.log 2>&1

# Upload WAR to S3
aws s3 cp target/*.war s3://build-bucket-java-artifacts-devx2025/javaweb3.war >> ../build.log 2>&1

# Write EC2 metadata for audit
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo "Build Server Launched" > /home/ec2-user/metadata.txt
echo "Instance ID: $INSTANCE_ID" >> /home/ec2-user/metadata.txt
echo "AZ: $AZ" >> /home/ec2-user/metadata.txt
echo "Public IP: $PUBLIC_IP" >> /home/ec2-user/metadata.txt
