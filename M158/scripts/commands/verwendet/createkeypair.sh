aws ec2 create-key-pair \
  --key-name wordpress-key \
  --region us-east-1 \
  --query "KeyMaterial" \
  --output text > ~/wordpress-key.pem

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.