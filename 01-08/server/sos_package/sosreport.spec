%{!?python_sitelib: %define python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

Summary: A set of tools to gather troubleshooting information from a system with
Name: sosreport
Version: 0.3
Release: 1%{?dist}
Source0: https://dmpkit.io/breeves/sos/releases/sosreport-%{version}.tar.gz
Group: Applications/System
License: Cleverdata Inc.
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildArch: noarch
BuildRequires: python-devel
BuildRequires: gettext
BuildRequires: python-six
Requires: libxml2-python
Requires: rpm-python
Requires: tar
Requires: bzip2
Requires: xz
Requires: python-six
Requires: python-futures

%description
Sos is a set of tools that gathers information about system
hardware and configuration. The information can then be used for
diagnostic purposes and debugging. Sos is commonly used to help
support technicians and developers.

%prep
%setup -q

%build
make

%install
rm -rf ${RPM_BUILD_ROOT}
make DESTDIR=${RPM_BUILD_ROOT} install
%find_lang %{name} || echo 0

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
%defattr(-,root,root,-)
%{_sbindir}/sosreport
%{python_sitelib}/*
%config(noreplace) %{_sysconfdir}/%{name}.conf