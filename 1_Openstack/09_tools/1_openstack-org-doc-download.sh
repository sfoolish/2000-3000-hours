#!/usr/bin/env bash

INSTALL_DOCS="
http://docs.openstack.org/trunk/install-guide/install/yum/openstack-install-guide-yum-trunk.pdf
http://docs.openstack.org/trunk/install-guide/install/apt/openstack-install-guide-apt-trunk.pdf
"

CONFIG_RUN_DOCS="
http://docs.openstack.org/high-availability-guide/high-availability-guide.pdf
http://docs.openstack.org/image-guide/image-guide.pdf
http://docs.openstack.org/trunk/config-reference/config-reference-trunk.pdf
http://docs.openstack.org/admin-guide-cloud/admin-guide-cloud.pdf
http://docs.openstack.org/ops/oreilly-openstack-ops-guide.pdf
http://docs.openstack.org/security-guide/security-guide.pdf
"

CLI_DOCS="
http://docs.openstack.org/cli-reference/cli-reference.pdf
http://docs.openstack.org/user-guide-admin/admin-user-guide-trunk.pdf
http://docs.openstack.org/user-guide/user-guide.pdf
http://docs.openstack.org/api/quick-start/api-quick-start-onepager.pdf
"

DEV_API_DOCS="
http://docs.openstack.org/api/openstack-block-storage/2.0/openstack-blockstorage-devguide-2.0.pdf
http://docs.openstack.org/api/openstack-block-storage/1.0/openstack-blockstorage-devguide-1.0.pdf
http://docs.openstack.org/api/openstack-compute/2/bk-compute-devguide-2.pdf
http://docs.openstack.org/api/openstack-identity-service/2.0/identity-dev-guide-2.0.pdf
http://docs.openstack.org/api/openstack-network/2.0/openstack-network.pdf
http://docs.openstack.org/api/openstack-image-service/2.0/openstack-image-service.pdf
http://docs.openstack.org/api/openstack-image-service/1.1/openstack-image-service.pdf
http://docs.openstack.org/api/openstack-object-storage/1.0/os-objectstorage-devguide-1.0.pdf
"

docs=$DEV_API_DOCS


for i in $docs
do
	wget $i
done

