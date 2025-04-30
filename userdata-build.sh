#!/bin/bash
sudo yum -y update
sudo yum -y install git java-1.8.0-openjdk maven aws-cli

cd /home/ec2-user
git clone https://github.com/CeeyIT-Solutions/JavaWeb3.git
cd JavaWeb3
mvn package

# Upload WAR to S3
aws s3 cp target/*.war s3://build-bucket-java-artifacts-devx2025/javaweb3.war

