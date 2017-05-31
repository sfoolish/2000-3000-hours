## [10 COMMANDS EVERY CEPH ADMINISTRATOR SHOULD KNOW](http://tracker.ceph.com/projects/ceph/wiki/10_Commands_Every_Ceph_Administrator_Should_Know)

If you've just started working with Ceph, you already know there's a lot going on under the hood. To help you in your journey to becoming a Ceph master, here's a list of 10 commands every Ceph cluster administrator should know. Print it out, stick it to your wall and let it feed your Ceph mojo!

1. Check or watch cluster health: ceph status || ceph -w
If you want to quickly verify that your cluster is operating normally, use ceph status to get a birds-eye view of cluster status (hint: typically, you want your cluster to be active + clean). You can also watch cluster activity in real-time with ceph -w; you'll typically use this when you add or remove OSDs and want to see the placement groups adjust.

2. Check cluster usage stats: ceph df
To check a cluster’s data usage and data distribution among pools, use ceph df. This provides information on available and used storage space, plus a list of pools and how much storage each pool consumes. Use this often to check that your cluster is not running out of space.

3. Check placement group stats: ceph pg dump
When you need statistics for the placement groups in your cluster, use ceph pg dump. You can get the data in JSON as well in case you want to use it for automatic report generation.

4. View the CRUSH map: ceph osd tree
Need to troubleshoot a cluster by identifying the physical data center, room, row and rack of a failed OSD faster? Use ceph osd tree, which produces an ASCII art CRUSH tree map with a host, its OSDs, whether they are up and their weight.

5. Create or remove OSDs: ceph osd create || ceph osd rm
Use ceph osd create to add a new OSD to the cluster. If no UUID is given, it will be set automatically when the OSD starts up. When you need to remove an OSD from the CRUSH map, use ceph osd rm with the UUID.

6. Create or delete a storage pool: ceph osd pool create || ceph osd pool delete
Create a new storage pool with a name and number of placement groups with ceph osd pool create. Remove it (and wave bye-bye to all the data in it) with ceph osd pool delete.

7. Repair an OSD: ceph osd repair
Ceph is a self-repairing cluster. Tell Ceph to attempt repair of an OSD by calling ceph osd repair with the OSD identifier.

8. Benchmark an OSD: ceph tell osd. bench*
Added an awesome new storage device to your cluster? Use ceph tell to see how well it performs by running a simple throughput benchmark. By default, the test writes 1 GB in total in 4-MB increments.

9. Adjust an OSD’s crush weight: ceph osd crush reweight
Ideally, you want all your OSDs to be the same in terms of thoroughput and capacity...but this isn't always possible. When your OSDs differ in their key attributes, use ceph osd crush reweight to modify their weights in the CRUSH map so that the cluster is properly balanced and OSDs of different types receive an appropriately-adjusted number of I/O requests and data.

10. List cluster keys: ceph auth list
Ceph uses keyrings to store one or more Ceph authentication keys and capability specifications. The ceph auth list command provides an easy way to to keep track of keys and capabilities