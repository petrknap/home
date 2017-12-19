ansible-installation:
	apt-get update
	apt-get install software-properties-common
	apt-add-repository ppa:ansible/ansible
	apt-get update
	apt-get install ansible

ansible-run:
	ansible-playbook --ask-become-pass ${ARGS}
