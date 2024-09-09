# envoy for v2ray

  create .env file and insert DESTINATION_ADDRESS and DESTINATION_PORT <br/>
  then run 
``` bash 
    export $(cat .env | xargs)    # Load the environment variables
    envsubst < envoy-template.yaml > envoy.yaml
```

then you can run 
``` bash
docker compose up -d
```