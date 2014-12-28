
## 2014-12-27

* ** 每天向领导反馈进度，避免走弯路，其他事情花了多少时间** ；
* 要有一定的计划，目标，方向，策略；
* 这是非常好的一次机会，一定要好好表现；
* 首先要尽全力，态度要端正，要积极主动（不能有消极情绪，要敢打敢拼，能力有问题是可以改善的）；
* 想办法和外面的人交流沟通，找别人求助（首先要明确自己的问题，并能够很好的表达自己的问题；其次是要找合适的人求助；求助人的时候要谦虚，让人家感到被尊重）；

* 找重点，排优先级，要专注，找到原始模型，这样有主干，然后外围的东西补全；
* 本身的工作量较大，找重点，找代表；
* 做好分类，把几块有代表性的分析好；

## TODO LIST

* copper 涉及的 opestack 项目梳理
* Openstack 孵化项目分析关注点 RO，CI；
* 所有 Openstack 相关的项目整理成excel；
* MANO 文档 prolicy 相关分析，copper wiki 有相关点列表；

---

## Copper 分析
[Copper](https://wiki.opnfv.org/requirements_projects/virtual_infrastructure_deployment_policies)
项目目标：虚拟化基础设施提供"部署策略"（如亲和性，隔离（e.g.控制/用户面分离））
Contributor: AT&T ericsson HP NEC ZTE HuangZhipeng(HW)
	

可能用到的上有Openstack项目

- Congress 这个是重点（目前代码一直在更新，没有有相应的例会，zhipengh512）

https://wiki.openstack.org/wiki/Congress
https://etherpad.openstack.org/p/par-kilo-congress-design-session 内容比较新

设计文档：
[Overall design doc](https://docs.google.com/a/vmware.com/document/d/1f2xokl9Tc47aV67KEua0PBRz4jsdSDLXth7dYe-jz6Q/edit)
[Data integration design doc](https://docs.google.com/document/d/1K9RkQuBSPN7Z2TmKfok7mw3E24otEGo8Pnsemxd5544/edit)

[API design doc](https://goo.gl/1E5MeY)
数据模型
* Policies
Policies 描述用户想要在云中执行的逻辑。 Each ‘policy’ includes properties of the policy (e.g. ‘owner’), and a collection of rules declared using the policy language grammar.

- GBP(Group-based Policy Abstractions for Neutron) -> 网络相关基于Group的策略机制，ODL有实现GBP不过没有与Openstack对接，（cisco提的？邮件列表中有相关的讨论）可以找杨文革做一下简单交流
- Volume Affinity -> Volume 调度的亲和性，不是我们关注的重点
- OpenStack NFV team
