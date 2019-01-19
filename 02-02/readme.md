# Users and groups. Authorization and authentication

### Task:

- Deny login for all users except for admin group on holidays 
- Give root access to specific user

### Description:

The basic PAM modules can do much cool stuff, except the main one: 
manage access by groups and time at the same time.

pam_time.so works great but only with users.

pam_group.so works great but without time options.

One way to do it - use pam_script.so with the very bad documentation.

#### Important steps
1. To deny login - modify /etc/pam.d/login, for the tests used sshd
2. It is very important to inject custom rule before the others (i thought there is some logic inside)
3. It is very important to postfix your custom scripts by the type of the rule ( -> )
```text
  account -> *_acct
  auth    -> *_auth
  passwd  -> *_passwd
  ...
```
4. *.conf files must have empty line at the EOF

##### How to:

```bash
$ bash start.sh 
```

### Links
- https://github.com/jeroennijhof/pam_script
- https://pypi.org/project/workalendar/
- https://github.com/Ralnoc/pam-python
- https://www.ibm.com/developerworks/ru/library/l-pam/index.html#artrelatedtopics
- https://askubuntu.com/questions/879364/differentiate-interactive-login-and-non-interactive-non-login-shell
