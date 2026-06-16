chmod +x ~/wordpress-ec2-setup.sh

aws ec2 run-instances \
  --image-id ami-0c7217cdde317cfec \
  --instance-type t3.micro \
  --key-name wordpress-key \
  --iam-instance-profile Name=LabInstanceProfile \
  --user-data file://~/wordpress-ec2-setup.sh \
  --region us-east-1 \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=wordpress-server}]" \
  --query "Instances[0].InstanceId" \
  --output text

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.