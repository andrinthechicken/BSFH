aws ssm send-command \
  --instance-ids "i-03591854416e0b917" \
  --document-name "AWS-RunShellScript" \
  --parameters commands=[BEFEHL] \
  --region us-east-1 \
  --query "Command.CommandId" \
  --output text