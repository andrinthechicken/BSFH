aws ec2 describe-instances \
  --instance-ids i-03591854416e0b917 \
  --region us-east-1 \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.