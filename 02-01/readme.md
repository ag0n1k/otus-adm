# First step with Ansible

### Task:

Provision nginx to server with Ansible role:
- use module yum/apt
- use template with jinja2 
- after install nginx must be in enabled mode in systemd
- use handler with notify for start nginx after install
- site listen on - 8080 port, use variable for that
- \*Additional All made in Ansible role

### Description:

##### How to:

```
$ vagrant up
# setup ssh port at inventory that produced by vagrant (2202, 2200, ...)

$ ansible-playbook playbooks/site.yml
# Answer will be at screen
# or check that site is avaliable at: http://192.168.11.101:8080/
```