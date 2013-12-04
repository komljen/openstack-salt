#!/usr/bin/env bash
#===============================================================================
#
# AUTHOR: Alen Komljen <alen.komljen@live.com>
#
#===============================================================================
fixed_range_v4="{{ salt['pillar.get']('nova:network:custom:private_ip_range') }}"
bridge_interface="{{ salt['pillar.get']('nova:network:flat_network_bridge') }}"
network_size="{{ salt['pillar.get']('nova:network:custom:private_network_size') }}"
floating_ip_range="{{ salt['pillar.get']('nova:network:floating_ip_range') }}"
floating_pool="{{ salt['pillar.get']('nova:network:floating_pool') }}"
public_interface="{{ salt['pillar.get']('nova:network:public_interface') }}"
#-------------------------------------------------------------------------------
nova-manage network create --fixed_range_v4=${fixed_range_v4}                  \
                           --bridge_interface=${bridge_interface}              \
                           --num_networks=1 --label=private                    \
                           --network_size=${network_size} --multi_host=T

nova-manage floating create --ip_range=${floating_ip_range}                    \
                            --pool=${floating_pool}                            \
                            --interface=${public_interface}
#===============================================================================
