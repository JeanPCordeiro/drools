ifndef VERBOSE
.SILENT:
endif

export MASTER1 ?= vmi1053342.contaboserver.net
export DOMAIN ?= lean-sys.com

info:
	printf "\033c"
	echo 
	echo 
	echo " \033[0;32m k3s Cluster and Stack Install\033[0m"
	echo 
	echo "Usage" 
	echo "	make \033[0;33mset_ssh\033[0m"
	echo "	make test_ssh"
	echo "	make test_ansible"
	echo
	echo

all : ssh_set ssh_test k3s_config k3s_drools

ssh_set:
	echo 'StrictHostKeyChecking no' > ~/.ssh/config
	rm -f ~/.ssh/known_hosts
	rm -f ~/.ssh/id_rsa*
	ls ~/.ssh/
	ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
	ssh-copy-id root@${MASTER1}

ssh_test:
	ssh root@${MASTER1} uptime

k3s_config:
	scp root@${MASTER1}:/etc/rancher/k3s/k3s.yaml _k3s.yaml
	sudo sed -i 's/127.0.0.1/${MASTER1}/g' _k3s.yaml
	cat _k3s.yaml | envsubst > k3s.yaml
	rm _k3s.yaml
	sudo mv k3s.yaml /etc/k3s.yaml
	sudo chmod +r /etc/k3s.yaml
	rm -fr ~/.kube
	mkdir ~/.kube 
	cp /etc/k3s.yaml ~/.kube/config

k3s_drools:
	cat drools.yaml | envsubst '$${DOMAIN}' | kubectl apply -f -

drools_test:
	echo "List DMN"
	curl -u 'kieserver:kieserver1!' -H "accept: application/json" -X GET "https://kie-server.drools.lean-sys.com/kie-server/services/rest/server/containers/traffic-violation_1.0.0-SNAPSHOT/dmn"
	echo
	echo "Execute Model"
	curl -u 'kieserver:kieserver1!' -H "accept: application/json" -H "content-type: application/json" -X POST "https://kie-server.drools.lean-sys.com/kie-server/services/rest/server/containers/traffic-violation_1.0.0-SNAPSHOT/dmn" -d "{ \"model-namespace\" : \"https://kiegroup.org/dmn/_03DAAFDA-EF0E-492C-A752-7946B9646137\", \"model-name\" : \"Traffic Violation\", \"dmn-context\" : {\"Driver\" : {\"Points\" : 10}, \"Violation\" : {\"Type\" : \"speed\", \"Actual Speed\" : 135, \"Speed Limit\" : 100}}}"
	echo
	