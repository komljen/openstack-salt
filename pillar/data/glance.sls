glance:
  db:
    password: pk0Dwb11H7c5pjMvfKi4Lg==
  service:
    backlog: 4096
    debug: False
    default_store: file
    filesystem_store_datadir: /var/lib/glance/images/
    flavor: keystone
    image_cache_dir: /var/lib/glance/image-cache/
    log_file: /var/log/glance/api.log
    notifier_strategy: rabbit
    password: iVskifwDQMAaPLciY/GitQ==
    rbd_store_ceph_conf: /etc/ceph/ceph.conf
    rbd_store_chunk_size: 8
    rbd_store_pool: images
    rbd_store_user: glance
    registry_client_protocol: http
    show_image_direct_url: False
    sql_idle_timeout: 3600
    verbose: False
    workers: 2
  registry:
    log_file: /var/log/glance/registry.log
    api_limit_max: 1000
    limit_param_default: 25
