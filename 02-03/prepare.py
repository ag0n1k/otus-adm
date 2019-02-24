# region Classes

class VagrantSSHConfig(object):
    def __init__(self):
        self.Host = None
        self.HostName = None
        self.IdentitiesOnly = None
        self.IdentityFile = None
        self.LogLevel = None
        self.PasswordAuthentication = None
        self.Port = None
        self.StrictHostKeyChecking = None
        self.User = None
        self.UserKnownHostsFile = None
        self.InventoryFile = None


class AnsibleConfigDefaults(object):
    def __init__(self):
        self.group_name = 'defaults'
        self.inventory = "inventory/hosts"
        self.remote_user = "vagrant"
        self.retry_files_enabled = "false"
        self.roles_path = "roles"
        self.remote_tmp = "$HOME/.ansible/tmp"
        self.local_tmp = "$HOME/.ansible/tmp"
        self.forks = 10
        self.internal_poll_interval = 0.05
        self.gathering = "smart"
        self.gather_subset = "all"
        self.gather_timeout = 60
        self.host_key_checking = "false"
        self.timeout = 30


class AnsibleConfigPrivilege(object):
    def __init__(self):
        self.group_name = 'privilege_escalation'
        self.become_method = "sudo"


class AnsibleConfigSSH(object):
    def __init__(self):
        self.group_name = 'ssh_connection'
        self.ssh_args = """-C                                    \\
                                  -o ControlMaster=auto                 \\
                                  -o ControlPersist=60s                 \\
                                  -o UserKnownHostsFile=/dev/null       \\
                                  -o GSSAPIAuthentication=no            \\
                                  -o PreferredAuthentications=publickey \\
                                  -o ConnectTimeout=20
        """
        self.control_path = "%(directory)s/%%h-%%p-%%r"
        self.pipelining = "false"
# endregion


def generate_config(cmd=None, inventory_file='inventory/test'):
    print('-- Parse ssh config from vagrant...')
    try:
        if not cmd:
            cmd = ['vagrant', 'ssh-config']
        from subprocess import Popen, PIPE
        vagrant_config = VagrantSSHConfig()
        command_ = Popen(cmd, stdout=PIPE)
        for line in command_.stdout.readlines():
            try:
                line = str(line.decode('utf-8')).replace('\n', '').strip()
                key, value = line.split(' ')
                vagrant_config.__dict__.update({key: value})
            except ValueError:
                pass
        vagrant_config.InventoryFile = inventory_file
        return vagrant_config
    except Exception as ex:
        print('Could not parse config, passing: {}'.format(ex.args))
    return None


def write_inventory(config, mode='w', group='test', template_group='[{group}]\n',
                    template_string='{hostname}\tansible_host={host}\tansible_port={port}\n'):
    print('-- Write inventory file...')
    try:
        if not config:
            raise FileNotFoundError
        with open(config.InventoryFile, mode) as f:
            f.write(template_group.format(group=group))
            f.write(template_string.format(hostname=config.Host, host=config.HostName, port=config.Port))
    except Exception as ex:
        print('Could not save inventory, passing: {}'.format(ex.args))
        pass


def generate_cfg(config=VagrantSSHConfig(), additional_config=dict()):
    print('-- Prepare ansible.cfg information...')
    ansible_config_default = AnsibleConfigDefaults()
    ansible_config_privilege = AnsibleConfigPrivilege()
    ansible_config_ssh = AnsibleConfigSSH()
    ansible_config_default.private_key_file = config.IdentityFile
    ansible_config_default.inventory = config.InventoryFile
    return [ansible_config_default, ansible_config_privilege, ansible_config_ssh]


def write_config(config, ansible_cfg_path='ansible.cfg', mode='w', template_group='[{group}]\n',
                 template_string='{key: <32}= {value}\n'):
    print('-- Write ansible.cfg information...')
    with open(ansible_cfg_path, mode) as f:
        f.write(template_group.format(group=config.group_name))
        for key, value in config.__dict__.items():
            if key == 'group_name':
                continue
            f.write(template_string.format(key=key, value=value))
        f.write('\n')


def main():
    cfg = generate_config()
    write_inventory(config=cfg)

    config_groups = generate_cfg(config=cfg)

    write_config(config=config_groups[0], mode='w', ansible_cfg_path='ansible.cfg')
    write_config(config=config_groups[1], mode='a', ansible_cfg_path='ansible.cfg')
    write_config(config=config_groups[2], mode='a', ansible_cfg_path='ansible.cfg')

    print('-- Ansible-vagrant prepare complete.')


if __name__ == '__main__':
    main()
