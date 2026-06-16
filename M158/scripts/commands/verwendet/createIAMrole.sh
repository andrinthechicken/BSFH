# Vertrauensrichtlinie erstellen
cat > /tmp/trust.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "ec2.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
EOF

# Role anlegen
aws iam create-role \
  --role-name EC2-S3-ReadOnly \
  --assume-role-policy-document file:///tmp/trust.json

# S3-Lesezugriff anhängen
aws iam attach-role-policy \
  --role-name EC2-S3-ReadOnly \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Instance Profile anlegen
aws iam create-instance-profile \
  --instance-profile-name EC2-S3-ReadOnly

# Role zum Profile hinzufügen
aws iam add-role-to-instance-profile \
  --instance-profile-name EC2-S3-ReadOnly \
  --role-name EC2-S3-ReadOnly

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.