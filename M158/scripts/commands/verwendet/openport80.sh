aws ec2 authorize-security-group-ingress \
  --group-id sg-01dfed27ca2c4ee42 \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0 \
  --region us-east-1

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.