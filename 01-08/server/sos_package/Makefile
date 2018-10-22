#
# Makefile for sos system support tools
#

NAME    = sosreport
VERSION := $(shell echo `awk '/^Version:/ {print $$2}' sosreport.spec`)
MAJOR   := $(shell echo $(VERSION) | cut -f 1 -d '.')
MINOR   := $(shell echo $(VERSION) | cut -f 2 -d '.')
RELEASE := $(shell echo `awk '/^Release:/ {gsub(/\%.*/,""); print $2}' sosreport.spec`)

SUBDIRS = sos sos/plugins sos/policies
PYFILES = $(wildcard *.py)

DIST_BUILD_DIR = dist-build
RPM_DEFINES = --define "_topdir %(pwd)/$(DIST_BUILD_DIR)" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir %{_topdir}" \
	--define "_sourcedir %{_topdir}"
RPM = rpmbuild
RPM_WITH_DIRS = $(RPM) $(RPM_DEFINES)
ARCHIVE_DIR = $(DIST_BUILD_DIR)/$(NAME)-$(VERSION)
DEB_ARCHIVE_DIR = $(DIST_BUILD_DIR)/$(NAME)report-$(VERSION)

SRC_BUILD = $(DIST_BUILD_DIR)/sdist

.PHONY: build
build:
	for d in $(SUBDIRS); do make -C $$d; [ $$? = 0 ] || exit 1 ; done

.PHONY: install
install:
	mkdir -p $(DESTDIR)/usr/sbin
	mkdir -p $(DESTDIR)/etc
	install -m755 sosreport $(DESTDIR)/usr/sbin/sosreport
	install -m644 $(NAME).conf $(DESTDIR)/etc/$(NAME).conf
	for d in $(SUBDIRS); do make DESTDIR=`cd $(DESTDIR); pwd` -C $$d install; [ $$? = 0 ] || exit 1; done

$(NAME)-$(VERSION).tar.gz: clean
	@mkdir -p $(ARCHIVE_DIR)
	@tar -cv sosreport sos sosreport.conf LICENSE README.md sosreport.spec Makefile | tar -x -C $(ARCHIVE_DIR)
	@tar Ccvzf $(DIST_BUILD_DIR) $(DIST_BUILD_DIR)/$(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION)

$(NAME)report_$(VERSION).orig.tar.gz: clean
	@mkdir -p $(DEB_ARCHIVE_DIR)
	@tar --exclude-vcs \
	     --exclude=.travis.yml \
	     --exclude=debian \
	     --exclude=$(DIST_BUILD_DIR) -cv . | tar -x -C $(DEB_ARCHIVE_DIR)
	@tar Ccvzf $(DIST_BUILD_DIR) $(DIST_BUILD_DIR)/$(NAME)report_$(VERSION).orig.tar.gz $(NAME)report-$(VERSION)
	@mv $(DIST_BUILD_DIR)/$(NAME)report_$(VERSION).orig.tar.gz .
	@rm -Rf $(DIST_BUILD_DIR)

clean:
	@rm -fv *~ .*~ changenew ChangeLog.old $(NAME)-$(VERSION).tar.gz sosreport.1.gz sos.conf.5.gz
	@rm -rf rpm-build
	@for i in `find . -iname *.pyc`; do \
		rm -f $$i; \
	done; \
	for d in $(SUBDIRS); do make -C $$d clean ; done

srpm: clean $(NAME)-$(VERSION).tar.gz
	$(RPM_WITH_DIRS) -ts $(DIST_BUILD_DIR)/$(NAME)-$(VERSION).tar.gz

rpm: clean $(NAME)-$(VERSION).tar.gz
	$(RPM_WITH_DIRS) -tb $(DIST_BUILD_DIR)/$(NAME)-$(VERSION).tar.gz


test:
	nosetests -v --with-cover --cover-package=sosreport
