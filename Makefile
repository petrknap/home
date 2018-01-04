ansible-installation:
	apt-get update
	apt-get install software-properties-common
	apt-add-repository ppa:ansible/ansible
	apt-get update
	apt-get install ansible

ansible-playbook:
	ansible-playbook --ask-become-pass ${ARGS}

workstation:
	make ansible-playbook ARGS="workstation.yml"
