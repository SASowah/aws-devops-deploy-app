#!/bin/bash
sudo yum -y update
sudo yum -y install java-1.8.0-openjdk wget aws-cli

cd /home/ec2-user

# Download and extract Tomcat
wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.94/bin/apache-tomcat-7.0.94.tar.gz
tar xvf apache-tomcat-7.0.94.tar.gz
sudo chown -R ec2-user:ec2-user apache-tomcat-7.0.94

# Download WAR file from S3
aws s3 cp s3://build-bucket-java-artifacts-devx2025/javaweb3.war /home/ec2-user/apache-tomcat-7.0.94/webapps/

# Create systemd service
sudo tee /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat
After=syslog.target network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/apache-tomcat-7.0.94
ExecStart=/home/ec2-user/apache-tomcat-7.0.94/bin/catalina.sh run
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Tomcat
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Write success log
echo "Tomcat deployment finished successfully" > /home/ec2-user/deploy-success.txt
