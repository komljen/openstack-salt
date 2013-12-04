#!/usr/bin/env bash
#===============================================================================
#
# AUTHOR: Alen Komljen <alen.komljen@live.com>
#
#===============================================================================
region="{{ salt['pillar.get']('keystone:service:region') }}"
keystone_host="{{ salt['network.ip_addrs']('eth0')[0] }}"
admin_pass="{{ salt['pillar.get']('keystone:service:admin_password') }}"
nova_pass="{{ salt['pillar.get']('nova:service:password') }}"
glance_pass="{{ salt['pillar.get']('glance:service:password') }}"
cinder_pass="{{ salt['pillar.get']('cinder:service:password') }}"
keystone_token="{{ salt['pillar.get']('keystone:service:admin_token') }}"
keystone_port="{{ salt['pillar.get']('keystone:service:admin_port') }}"
#-------------------------------------------------------------------------------
function get_id ()
{
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}

export SERVICE_TOKEN=${keystone_token}
export SERVICE_ENDPOINT=http://${keystone_host}:${keystone_port}/v2.0
#-------------------------------------------------------------------------------
echo "Create tenants ..."
tenant_cloud=$(get_id keystone tenant-create                                   \
                               --name cloud                                    \
                               --description "Cloud Tenant")

tenant_admin=$(get_id keystone tenant-create                                   \
                               --name admin                                    \
                               --description "Admin Tenant")

tenant_service=$(get_id keystone tenant-create                                 \
                               --name service                                  \
                               --description "Service Tenant")

keystone tenant-list

echo "Create users ..."
user_admin=$(get_id keystone user-create                                       \
                               --tenant-id $tenant_admin                       \
                               --name admin                                    \
                               --pass $admin_pass)

user_nova=$(get_id keystone user-create                                        \
                               --tenant-id $tenant_service                     \
                               --name nova                                     \
                               --pass $nova_pass)

user_glance=$(get_id keystone user-create                                      \
                               --tenant-id $tenant_service                     \
                               --name glance                                   \
                               --pass $glance_pass)

user_cinder=$(get_id keystone user-create                                      \
                               --tenant-id $tenant_service                     \
                               --name cinder                                   \
                               --pass $cinder_pass)

keystone user-list

echo "Create roles ..."
role_admin=$(get_id keystone role-create --name admin)
role_member=$(get_id keystone role-create --name Member)

keystone role-list

echo "Grant the roles to the users in created tenants ..."
keystone user-role-add --user-id $user_admin                                   \
                       --tenant-id $tenant_admin                               \
                       --role-id $role_admin

keystone user-role-add --user-id $user_admin                                   \
                       --tenant-id $tenant_cloud                               \
                       --role-id $role_admin

keystone user-role-add --user-id $user_admin                                   \
                       --tenant-id $tenant_admin                               \
                       --role-id $role_member

keystone user-role-add --user-id $user_nova                                    \
                       --tenant-id $tenant_service                             \
                       --role-id $role_admin

keystone user-role-add --user-id $user_glance                                  \
                       --tenant-id $tenant_service                             \
                       --role-id $role_admin

keystone user-role-add --user-id $user_cinder                                  \
                       --tenant-id $tenant_service                             \
                       --role-id $role_admin

echo "Define services ..."
service_keystone=$(get_id keystone service-create                              \
                                   --name keystone                             \
                                   --type identity                             \
                                   --description "Identity Service")

service_nova=$(get_id keystone service-create                                  \
                                 --name nova                                   \
                                 --type compute                                \
                                 --description "Compute Service")

service_cinder=$(get_id keystone service-create                                \
                                   --name cinder                               \
                                   --type volume                               \
                                   --description "Volume Service")

service_glance=$(get_id keystone service-create                                \
                                 --name glance                                 \
                                 --type image                                  \
                                 --description "Image Service")

keystone service-list

echo "Define endpoint for each service ..."
keystone endpoint-create                                                       \
         --region $region                                                      \
         --service-id $service_keystone                                        \
         --publicurl "http://${keystone_host}:5000/v2.0"                       \
         --internalurl "http://${keystone_host}:5000/v2.0"                     \
         --adminurl "http://${keystone_host}:${keystone_port}/v2.0"

keystone endpoint-create                                                       \
         --region $region                                                      \
         --service-id $service_nova                                            \
         --publicurl "http://${keystone_host}:8774/v2/%(tenant_id)s"           \
         --internalurl "http://${keystone_host}:8774/v2/%(tenant_id)s"         \
         --adminurl "http://${keystone_host}:8774/v2/%(tenant_id)s"

keystone endpoint-create                                                       \
         --region $region                                                      \
         --service-id $service_cinder                                          \
         --publicurl "http://${keystone_host}:8776/v1/%(tenant_id)s"           \
         --internalurl "http://${keystone_host}:8776/v1/%(tenant_id)s"         \
         --adminurl "http://${keystone_host}:8776/v1/%(tenant_id)s"

keystone endpoint-create                                                       \
         --region $region                                                      \
         --service-id $service_glance                                          \
         --publicurl "http://${keystone_host}:9292/v2"                         \
         --internalurl "http://${keystone_host}:9292/v2"                       \
         --adminurl "http://${keystone_host}:9292/v2"
#===============================================================================
