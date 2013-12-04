nova:
  db:
    password: 626KIYcwYfxg9eEAzXwfNQ==
  network:
    allow_same_net_traffic: False
    auto_assign_floating_ip: False
    dhcpbridge: /usr/bin/nova-dhcpbridge
    dhcpbridge_flagfile: /etc/nova/nova.conf
    dmz_cidr: 169.254.169.254/32
    dns_server: 8.8.8.8
    ec2_private_dns_show_ip: True
    flat_injected: True
    flat_interface: eth1
    flat_network_bridge: br100
    floating_ip_range: 192.168.100.0/24
    floating_pool: nova
    force_dhcp_release: True
    multi_host: True
    network_manager: nova.network.manager.FlatDHCPManager
    public_interface: eth2
    send_arp_for_ha: True
    custom:
      private_ip_range: 10.0.0.0/24
      private_network_size: 256
      public_gateway: 192.168.100.1
      public_ip_count: 10
      public_netmask: 255.255.255.0
  compute:
    block_migration_flag: VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_NON_SHARED_INC
    compute_driver: libvirt.LibvirtDriver
    connection_type: libvirt
    cpu_allocation_ratio: 13.0
    iscsi_helper: tgtadm
    libvirt_images_type: qcow2
    libvirt_images_volume_group: nova_local
    libvirt_lvm_snapshot_size: 1000
    libvirt_snapshot_compression: True
    libvirt_snapshots_directory: $instances_path/snapshots
    libvirt_sparse_logical_volumes: False
    libvirt_type: kvm
    libvirt_use_virtio_for_bridges: True
    max_instances_per_host: 20
    ram_allocation_ratio: 1.5
    reserved_host_memory_mb: 512
    custom:
      drive: /dev/sdb
      drive_size: 15G
      drive_type: ssd
    libvirtd:
      max_client_requests: 20
      max_clients: 20
      max_requests: 20
      max_workers: 20
      min_workers: 5
      prio_workers: 5
  service:
    allow_admin_api: True
    api_paste_config: /etc/nova/api-paste.ini
    auth_strategy: keystone
    base_dir_name: _base
    cache_images: True
    enabled_apis: ec2,osapi_compute,metadata
    force_raw_images: False
    image_service: nova.image.glance.GlanceImageService
    instance_name_template: vm-%08x
    instances_path: $state_path/instances
    lock_path: /var/lock/nova
    logdir: /var/log/nova
    metadata_listen: 0.0.0.0
    novnc_enable: True
    osapi_compute_workers: 37
    password: 6wiAOPJPpHgZfgphdpm+Gg==
    rootwrap_config: /etc/nova/rootwrap.conf
    scheduler_driver: nova.scheduler.filter_scheduler.FilterScheduler
    state_path: /var/lib/nova
    use_deprecated_auth: false
    verbose: False
    volume_api_class: nova.volume.cinder.API
