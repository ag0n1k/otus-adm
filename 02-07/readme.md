# Monitoring and Alerting

### Task:

- Configure monitoring:
- Create dashboard with 4 screens
  - Memory
  - Processor
  - Disk
  - Network 

- Configure zabbix
- Configure Prometheus - Grafana

### Description:

For this task were created 3 roles:
- Prometheus based on documentation
- node-exporter based on @cloudalchemy
- grafana forked from @cloudalchemy 

The roles node-exporter and grafana needs to be fixed based on another conventions.
Also dashboard must be made by self.

##### How to:

```bash
vagrant up
python prepare.py                           # parse vagrant config (creates ansible.cfg and inventory)
ansible-galaxy install -r requirements.yml  # install dependencies
ansible-playbook playbooks/site.yml         # installs prometheus,node-exporter and grafana
```

Then go to `192.168.11.101:3000` login with `admin/password` and choose dashboard.

## Links:
- https://github.com/cloudalchemy
- https://grafana.com/dashboards/9096
