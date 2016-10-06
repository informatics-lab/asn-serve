# asn-serve  

## To run locally  

Set up your amazon bucket environment variables on your machine to include `AWSSECRETACCESSKEY` and `AWSACCESSKEYID`
  
or remove the line:  

```
 s3fs mogreps /usr/local/share/notebooks/data/mogreps -o iam_role=jade-secrets
```

from `Dockerfile`

Build the container:

`docker build . -t asn-serve`

  Then run:  

```
docker run -d \
-e AWSSECRETACCESSKEY=$AWSSECRETACCESSKEY \
-e AWSACCESSKEYID=$AWSACCESSKEYID \
-e AWS_SECRET_ACCESS_KEY=$AWSSECRETACCESSKEY \
-e AWS_ACCESS_KEY_ID=$AWSACCESSKEYID \
-e DEPLO_ENV="local" \
-p 8888:8888 \
--privileged \
asn-serve
```

  If not mounting a s3 bucket such as mogreps (the line `s3fs mogreps /usr/...` in `readme.MD`) then `--privileged` isn't needed.
