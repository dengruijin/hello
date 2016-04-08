#anaconda磁盘分区
 _自定义分区_ _多磁盘选择_ _root-label
##overview
在installdata初始化(instClass.setInstallData)时将调用installclass的setDefaultPartitioning函数来设置系统安装时所用的默认分区方案。
一个分区用元组表示，例如：

    autorequests  = 
    [("/", fs_type, size, size, 1, 1, 0),
     (None,'ext3',4096, 4096, 1, 0, 0, ) ] 
autoparts这个列表中每一个元组代表一个分区，然后根据每一个元组调用partRequests.PartitionSpec创建一个PartitionSpec对象，值得注意的是，虽然默认每个元组只有7个元素，但是可以根据自己需要添加元素，只要能传给PartitionSpec即可。PartitionSpec是一个类，表示一个分区。
##phyxs中的分区
###1.分区参数与三个小问题
phyxs有自己的installclass: installclasses/phyxs.py,有自己的setDefaultPartitioning方法，其中的autorequests 中每个元组后面添加了三个元组，分别表示preexisting, fs_label, disk_drive:

    autorequests = 
    [ ("/", ext3, 4096, 4096, 1, 1, 0, 0, label, hda),
       (None, ext3, 4096, 4096, 1, 0, 0, 1, None, hda) ]

那么为什么要添加这三个参数，分别是为了解决三个问题，来保持与XenServer一致：
* __backup分区问题__: xenserver的backup分区是没有挂载的，只是一个空闲分区所以我们必须将挂载点设为None,但是anaconda在分区之前将执行sanityCheckRequest检查参数，若mountpoint=None,将执行如下检查:
    
        if (fstype and fstype.isMountable() and (not preexisting or format)):    return error...        
所以如果fstype是可挂载的，必须preexisting=1且format=0才能通过检查,所以添加了_preexisting_参数。可是为什么不直接将fstype设为None，不是更省事吗？因为如果autorequests将fstypt设为None,在创建PartitionSpec对象时将给他赋值为默认的fstype.     
* __根分区Label__: XenServer的根分区的label默认是,root-xxxxxxxx，(x表示随机字母)例如：root-cdfgmnhg，为了设置label,所以在autorequests中加了fslabel参数.fslabel是如何生成的呢？见如下代码：

        rootfs_label = 
        "root-%s" % "".join([random.choice(string.ascii_lowercase) \
                                    for x in range(8)])

* __根分区位置__: 当存在多个磁盘时，XenServer要选择一个磁盘作为primary-disk，即根分区所在的磁盘，也要选择一个或多个磁盘作为guset-disks, 所以根分区必须位于primary-disk上。而在anaconda中默认是放在所选磁盘集合中的第一个磁盘上面，所以需要这里在autorequests中添加了drive参数来指定这个分区所在的磁盘。

###2.多磁盘是如何选择的
XenServer需要进行两次磁盘选择，一次选择primary-disk,一次选择guest-disks，primary-disk只能有一个磁盘，guest-disks可以有多个磁盘。
而anaconda只有一次选择磁盘的步骤，它可以是多个磁盘，所以我们将这个选择的结果作为guest-disks存放在anaconda.id.phycfg['guest-disks']中，disks，primary-disk的选择则需要自己添加一个界面来完成(见disksel_text.py和disksel_gui.py),结果放在anaconda.id.phycfg['primary-disk']。
如果一个磁盘n/dev/sda既是primary-disk也是guest-disk(事实上也常是这样的)，那么将/dev/sda3作为SR分区使用。
包安装完成后配置时需要将作为SR的磁盘或分区写入/etc/firstboot.d/data/deffault-storeage.conf文件中，例如['/dev/sda3','/dev/sdb','/dev/sdc']
###3.储存库(SR)类型的配置
XenServer存储卡有两种格式可供选择，分别是'lvm'和'ext3'，只需在选择磁盘的界面中添加SR类型选择的控件即可，我们将选择结果放入anaconda.id.phycfg['sr-type'],例如：  

    anaconda.id.phycfg['sr-type'] = 'ext3'
包安装完成后配置时需要将其写入/etc/firstboot.d/data/deffault-storeage.conf文件中.
