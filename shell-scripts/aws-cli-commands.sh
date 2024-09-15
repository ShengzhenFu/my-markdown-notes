## create a private bucket


```bash
aws s3api create-bucket --bucket ${your-unique-bucket-name} --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 --acl private

```

