# rpmbuild过程
rpmbuild依据SPEC文件来从源码构建rpm包，spec文件主要包含以下信息：

## spec文件内容
    Summary: GNU indent
    Name: indent
    Version: 2.2.6
    Release: 2
    Source0: %{name}-%{version}.tar.gz
    License: GPL
    Group: Development/Tools
    BuildRoot: %{_builddir}/%{name}-root
    %description    
    %prep
    %build	
    %install
    %clean
    %files
    %doc

* _builddir是/usr/src/redhat/BUILD
* BuildRoot指定%install的目标路径,下文可通过${RPM_BUILD_ROOT}得到这个设好的值
* BuildRoot下的文件就是是最后放入RPM包的文件

## rpmbuild主要工作
%prep
在/usr/src/redhat/SOURCES/寻找Source指定的压缩包，然后解压到/usr/src/redhat/BUILD/目录中

%build
进入/usr/src/redhat/BUILD/mypack-1.0
执行你指定的指令(比如./configure, make)

%install
进入/usr/src/redhat/BUILD/mypack-1.0
执行你的指令,如make DESTDIR=$RPM_BUILD_ROOT install

%clean
打包完成后进入
执行你的指令
## spec实例

    Summary: GNU indent
    Name: indent
    Version: 2.2.6
    Release: 2
    Source0: %{name}-%{version}.tar.gz
    License: GPL
    Group: Development/Tools
    BuildRoot: %{_builddir}/%{name}-root
    %description
    The GNU indent program reformats C code to any of a variety of
    formatting standards, or you can define your own.
    %prep
    %setup -q
    %build
    ./configure
    make
    %install
    rm -rf $RPM_BUILD_ROOT
    make DESTDIR=$RPM_BUILD_ROOT install
    %clean
    rm -rf $RPM_BUILD_ROOT
    %files
    %defattr(-,root,root)
    /usr/local/
    %doc /usr/local/info/indent.info
    %doc %attr(0444,root,root) /usr/local/man/man1/indent.1
    %doc COPYING AUTHORS README NEWS

xsconfig.spec:

    Summary:        XSConfig
    Name:           xsconfig
    Version:        1.0
    Release:        2
    License:        GPL
    Group:          System Environment/Base
    Source0:        %{name}-%{version}.tar.bz2
    BuildRoot:      %{_tmppath}/%{name}-%{version}
    %description
    XSConfig contains some config files and scripts to support the XS installation.
    %prep
    %setup -q
    echo "hello"
    %build
      #do nothing
    %install
    rm -rf ${RPM_BUILD_ROOT}
    mkdir -p ${RPM_BUILD_ROOT}
    #tar xf ${RPM_SOURCE_DIR}/%{name}-%{version}.tar.bz2 -C %{_builddir}
    cp -vra %{_builddir}/%{name}-%{version}/* ${RPM_BUILD_ROOT}
    rm -rf ${RPM_BUILD_ROOT}/ChangeLog

    %clean
    rm -rf $RPM_BUILD_ROOT

    %files
    %defattr(-,root,root)
    /
