## fission install

https://github.com/fission/fission/blob/master/INSTALL.md

```bash
kubectl get pods --output=wide
kubectl create -f https://github.com/fission/fission/releases/download/nightly20170705/fission-rbac.yaml
kubectl create -f https://github.com/fission/fission/releases/download/nightly20170705/fission-nodeport.yaml

yum install -y lsof
lsof -ni :31313
export FISSION_URL=http://192.168.122.101:31313
export FISSION_ROUTER=192.168.122.101:31314
curl -Lo fission https://github.com/fission/fission/releases/download/nightly20170705/fission-cli-linux && chmod +x fission && sudo mv fission /usr/local/bin/
fission env create --name nodejs --image fission/node-env
curl https://raw.githubusercontent.com/fission/fission/master/examples/nodejs/hello.js > hello.js
fission function create --name hello --env nodejs --code hello.js
fission route create --method GET --url /hello --function hello
curl http://$FISSION_ROUTER/hello

kubectl create -f https://raw.githubusercontent.com/fission/fission/master/fission-logger.yaml
fission function logs --name hello
vim hello.js
fission function pods --name hello
kubectl create -f https://raw.githubusercontent.com/fission/fission-ui/master/docker/fission-ui.yaml
lsof -ni :31319
```

### [Fission compile](https://github.com/fission/fission/blob/master/Compiling.md)

```
## setup golang
sudo curl -O https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
sudo tar -xvf go1.8.linux-amd64.tar.gz
sudo mv go /usr/local
export PATH=$PATH:/usr/local/go/bin
mkdir $HOME/work
export GOPATH=$HOME/work
export PATH=$PATH:$GOPATH/bin

## test golang
mkdir -p work/src/github.com/user/hello
cat << EOF > work/src/github.com/user/hello/hello.go
package main
import "fmt"
func main() {
    fmt.Printf("hello, world\n")
}
EOF
go install github.com/user/hello

## install glide
sudo add-apt-repository -y ppa:masterminds/glide && sudo apt-get update
sudo apt-get install -y glide

## build fission
go get github.com/fission/fission
cd $HOME/work/src/github.com/fission/fission/
glide install
pushd fission-bundle/
./build.sh
./fission-bundle -h
```
