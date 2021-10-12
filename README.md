
### How to use eks cluster

#####  [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
#####  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
#####  [Install kubectl](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
##### 
#####  terraform init
#####  terraform plan
#####  terraform apply
#####  aws configure
#####  terraform output
#####  aws eks --region us-west-1 update-kubeconfig --name education-eks-"from output"
#####  kubectl get nodes
#####  kubectl get pods --all-namespaces
#### Dasboard UI
##### kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
##### kubectl apply -f sa-dash.yaml
#### Getting a Bearer Token
##### kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

##### kubectl proxy
#### Kubectl will make Dashboard available at 
##### http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


##### kubectl -n kubernetes-dashboard delete serviceaccount admin-user
##### kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user



##### kubectl run app-kuber-1 --image=bokovets/kuber:0.1 --port=8000
#### kubectl exec -it app-kuber-1 -- /bin/bash

##### kubectl exec -it app-kuber-1 --container app-kuber-1 --  /bin/bash
##### kubectl apply -f kuber-pod.yaml

##### kubectl get pod app-kuber-2 -o yaml
##### kubectl port-forward app-kuber-1 11111:8000
##### kubectl logs app-kuber-1
#####  kubectl get po --show-labels
##### kubectl delete po app-kuber-2

##### kubectl create deployment kuber-ctl-app --image=bokovets/kuber --port=8000 -replicas=3
##### kubectl delete -n default deployment kuber-ctl-app