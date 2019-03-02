# LDAP. Central authorization and authentication

### Task:

- Install FreeIPA
- Create playbook that configures client
- All access via LDAP
- Configure authorization by ssh-keys 

### Description:

Simple installation of freeipa server and client roles,
some tasks, such as configure hosts, ipa_user, tests over ssh key connectivity 
also there is a freeipa playbook sample that not so simple to use,
see the links

#### Important steps

- IPA server requires memory. At least 1,9 Free RAM
- There is an issue in ipa_user module, see the ##note
- Pause module in use, see the ##todo

### How to

```bash
bash start.sh 
```

### Links

- https://github.com/freeipa/ansible-freeipa
- https://github.com/freeipa/ansible-freeipa/wiki/Workshop-ansible-freeipa
- https://access.redhat.com/solutions/71663
