---
## AWS 试用

* [How Do I Get Started with the Free Usage Tier?](http://docs.aws.amazon.com/gettingstarted/latest/awsgsg-intro/gsg-aws-free-tier.html)

### AWS 试用限额过量告警设置

AWS 很多的收费都是按实际的资源使用量来收费的。并且提供一年的免费试用。我们可以通过设置资费告警来及时获知资源的过量使用。

设置方法参见：http://docs.aws.amazon.com/gettingstarted/latest/awsgsg-intro/gsg-aws-billing-alert.html

### 登入 AWS 虚拟机

1. 安照 web 页面里的提示，创建 key-pair 并下载 private key 文件；
2. 修改 private key 文件权限为只读： chmod 400 sf-mac.pem ；
3. 从  [AWS EC2 Console](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-1&#Instances:) 中获取 虚拟机的 public DNS，ubuntu系统的默认用户明是 ubuntu ；
4. ssh -i sf-mac.pem ubuntu@ec2-54-255-145-110.ap-southeast-1.compute.amazonaws.com 
4. ssh -o ServerAliveInterval=60  -i ~/.ssh/sf-mac.pem ubuntu@ec2-54-255-145-110.ap-southeast-1.compute.amazonaws.com 

(如果 ssh 登入有问题，可以通过加选项 -v ，来打印更详细的错误信息。)

REF: [Connecting to Your Linux/Unix Instances Using SSH](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

### scp 从 AWS 虚拟机中拷贝文件到本地

	$ scp -i ~/.ssh/sf-mac.pem ubuntu@ec2-54-255-145-110.ap-southeast-1.compute.amazonaws.com:~/go1.3.windows-386.zip ./


