# rpmbuild过程
rpmbuild依据SPEC文件来从源码构建rpm包，spec文件主要包含以下信息：


BuildRoot:      %{_tmppath}/%{name}-%{version}
RPM_BUILD_ROOT   BuildRoot
_builddir		/usr/src/redhat/BUILD

BuildRoot指定%install的目标路径,下文可通过${RPM_BUILD_ROOT}得到这个设好的值
BuildRoot下的文件就是是最后放入RPM包的文件

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
