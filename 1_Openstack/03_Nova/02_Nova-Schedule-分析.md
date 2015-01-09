http://specs.openstack.org/openstack/nova-specs/priorities/kilo-priorities.html
Scheduler
This paves the way to pulling out the scheduler allowing for faster scheduler development while reducing the scope of nova to help with nova’s growth challenges

Juno 相关修改，sch-lib group-api, vm-em -> 原因 cell 调度，还不成熟，不够合理；
将调动器从nova代码中剥离出来，以加快调动器的开发并减少nova本身关注的范围从而降低nova代码膨胀带来的调整。
kilo 版本后基本具备gantt合入条件，做了哪些准备（sh-lib，object化，DB依赖减少...）