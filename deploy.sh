# !/bin/bash
# tag $SHA to docker image so kubernetes can apply new images when there's something changed
docker build -t tuandl/multi-client:latest -t tuandl/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t tuandl/multi-worker:latest -t tuandl/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker build -t tuandl/multi-server:latest -t tuandl/multi-server:$SHA -f ./server/Dockerfile ./server

docker push tuandl/multi-client:latest
docker push tuandl/multi-server:latest
docker push tuandl/multi-worker:latest

docker push tuandl/multi-client:$SHA
docker push tuandl/multi-server:$SHA
docker push tuandl/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=tuandl/multi-server:$SHA
kubectl set image deployments/client-deployment client=tuandl/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=tuandl/multi-worker:$SHA