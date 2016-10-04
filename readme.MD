# asn-serve  

## To run locally  

Edit `start-singleuser.sh` change:  

``` 
exec jupyterhub-singleuser \ 
--port=8888 \ 
--ip=0.0.0.0 \
--user=$JPY_USER \
--cookie-name=$JPY_COOKIE_NAME \ 
--base-url=$JPY_BASE_URL \ 
--hub-prefix=$JPY_HUB_PREFIX \ 
--hub-api-url=$JPY_HUB_API_URL \ 
${notebook_arg} \   $@ 
```

to:

  ```
 exec jupyter notebook
  ```  

Set up your amazon bucket environment variables on your machine to include `AWSSECRETACCESSKEY` and `AWSACCESSKEYID`
  
or remove the line:  

```
 s3fs mogreps /usr/local/share/notebooks/data/mogreps -o iam_role=jade-secrets
```

  Then run:  

```
docker run -d \ 
-e AWSSECRETACCESSKEY=$AWSSECRETACCESSKEY \ 
-e AWSACCESSKEYID=$AWSACCESSKEYID \ 
-e AWS_SECRET_ACCESS_KEY=$AWSSECRETACCESSKEY \ 
-e AWS_ACCESS_KEY_ID=$AWSACCESSKEYID \ 
-p 8888:8888
--privileged
asn-serve
```

  If not mounting a s3 bucket such as mogreps (the line `s3fs mogreps /usr/...`) then `--privileged` isn't needed.

