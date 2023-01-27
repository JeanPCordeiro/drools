ifndef VERBOSE
.SILENT:
endif

include Makefile.vars

info:
	printf "\033c"
	echo 
	echo 
	echo " \033[0;32mInstall KIE WorkBench and Server on K3S Kubernetes Cluster\033[0m"
	echo 
	echo "Usage" 
	echo "	make \033[0;33mssh_set\033[0m"
	echo "	make \033[0;33mssh_test\033[0m"
	echo "	make \033[0;33mk3s_config\033[0m"
	echo "	make \033[0;33mk3s_drools_install\033[0m"
	echo "	make \033[0;33mk3s_drools_uninstall\033[0m"
	echo "	make \033[0;33mk3s_drools_test\033[0m"
	echo

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
	rm -fr ~/.kube
	mkdir ~/.kube
	scp root@${MASTER1}:/etc/rancher/k3s/k3s.yaml ~/.kube/config
	sudo sed -i 's/127.0.0.1/${MASTER1}/g'  ~/.kube/config
	kubectl get nodes -o=wide

k3s_drools_install:
	cat drools.yaml | envsubst '$${DOMAIN}' | kubectl apply -f -

k3s_drools_uninstall:
	cat drools.yaml | envsubst '$${DOMAIN}' | kubectl delete -f -

k3s_drools_test:
#	curl -s -u 'kieserver:kieserver1!' https://kie-server.drools.lean-sys.com/kie-server/services/rest/server
#	echo "Result"
#	curl -s -u 'kieserver:kieserver1!' -d " {\"Driver\" : {\"Points\" : 10}, \"Violation\" : {\"Type\" : \"speed\", \"Actual Speed\" : 135, \"Speed Limit\" : 100}}" -H "accept: application/json" -H "content-type: application/json" -X POST "https://kie-server.drools.lean-sys.com/kie-server/services/rest/server/containers/traffic-violation_1.0.0-SNAPSHOT/dmn/models/Traffic Violation" | jq .
#	echo "Result"
	curl -s -u 'kieserver:kieserver1!' -d " {\"Conducteur\" : {\"Points\" : 2}, \"Infraction\" : {\"Type\" : \"Vitesse\", \"Vitesse\" : 125, \"Vitesse_Limite\" : 100}}" -H "accept: application/json" -H "content-type: application/json" -X POST "https://kie-server.drools.lean-sys.com/kie-server/services/rest/server/containers/Permis_Conduire_1.0.0-SNAPSHOT/dmn/models/Regles_Permis_Conduire" | jq .
	curl -s -u 'kieserver:kieserver1!' -d " {\"Conducteur\" : {\"Points\" : 2}, \"Infraction\" : {\"Type\" : \"Stationnement\"}}" -H "accept: application/json" -H "content-type: application/json" -X POST "https://kie-server.drools.lean-sys.com/kie-server/services/rest/server/containers/Permis_Conduire_1.0.0-SNAPSHOT/dmn/models/Regles_Permis_Conduire" | jq .