#!/bin/bash
export NAME=firstclusterkub.k8s.local
export KOPS_STATE_STORE=s3://kv045kops
kops create cluster --zones eu-central-1a ${NAME} --master-size=t2.micro --node-size=t2.micro --master-volume-size=8 --node-volume-size=8
sleep 10
kops get cluster --name ${NAME} -oyaml > cluster.yaml
cat <<__EOF__>>~/cluster.yaml
  fileAssets:
    - content: |
        {
            "insecure-registries" : ["100.100.100.100:5000"]
        }
      name: insecure-registries
      path: /etc/docker/daemon.json
      roles:
      - Master
      - Node
__EOF__
sleep 5
kops replace -f cluster.yaml
#kops update cluster ${NAME} --yes
