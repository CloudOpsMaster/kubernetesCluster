
## How to use eks cluster

#### [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
#### https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
#### [Install kubectl](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
####
#### terraform init
#### terraform plan
#### terraform apply
#### aws configure
#### terraform output
#### aws eks --region us-west-1 update-kubeconfig --name education-eks-"from output"
#### kubectl get nodes
#### kubectl get pods --all-namespaces
### Dasboard UI
#### kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
#### kubectl apply -f sa-dash.yaml
### Getting a Bearer Token
#### kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

#### kubectl proxy
### Kubectl will make Dashboard available at 
#### http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


#### kubectl -n kubernetes-dashboard delete serviceaccount admin-user
#### kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

