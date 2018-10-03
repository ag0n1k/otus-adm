# Working with systemd

### Task:
- Create a service that will monitor some log for some phrase each 30 seconds. 
All variables must be set up in /etc/sysconfig directory
- Install spawn-fcgi from epel repo and create unit-file instead of init-file
- Change unit-file for apache httpd to get an opportunity to start several instances with different config files
- \* Download demo Atlassian Jira and rewrite main script to unit-file

## How to:

```bash
$ vagrant up
```