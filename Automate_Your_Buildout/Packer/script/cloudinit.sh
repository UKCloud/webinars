# Install Cloud-Init
#yum -y install cloud-init cloud-utils-growpart dracut-modules-growroot
yum -y install cloud-init cloud-utils cloud-utils-growpart 
 
mkdir -p /etc/cloud
cat > /etc/cloud/cloud.cfg <<EOF
user: root
disable_root: 0
ssh_pwauth:   0

cc_ready_cmd: ['/bin/true']
locale_configfile: /etc/sysconfig/i18n
mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
ssh_deletekeys:   0
ssh_genkeytypes:  ~
ssh_svcname:      sshd
syslog_fix_perms: ~

cloud_init_modules:
 - bootcmd
 - growpart
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - rsyslog
 - ssh

cloud_config_modules:
 - mounts
 - ssh-import-id
 - locale
 - set-passwords
 - timezone
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - keys-to-console
 - phone-home
 - final-message

growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false

resize_rootfs: True

# vim:syntax=yaml
EOF

mkinitrd --preload vmw_pvscsi /boot/initramfs-$(uname -r).img $(uname -r) --force