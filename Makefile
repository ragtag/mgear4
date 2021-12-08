NAME = mgear
VERSION = 4.0.4.1
ITERATION = 1
PACKAGE = $(NAME)$(VERSION)
SUMMARY = mGear rig for Maya, Storm version

# MAINTAINER
FULL_USER = $(shell getent passwd $$USER | cut -d : -f 5)
USER = $(shell echo $$USER)
MAINTAINER = $(FULL_USER) <$(USER)@stormstudios.no>

# BASE FOLDERS
PACKAGE_ROOT = ./../rpm/$(PACKAGE)-$(ITERATION)
INSTALL_PATH = /sw/$(NAME)/$(PACKAGE)
PACKAGE_SW_DIR = $(PACKAGE_ROOT)$(INSTALL_PATH)

# NEEDS
PACKAGE_NEEDS_DIR = $(PACKAGE_ROOT)/etc/needs

# INSTALLERS ROOT
INSTALLERS_ROOT = /net/sw/dev/packages/installers/$(NAME)


install:
	install -d $(PACKAGE_SW_DIR)

	# Install needs
	install -d $(PACKAGE_NEEDS_DIR)
	install -m 644 need $(PACKAGE_NEEDS_DIR)/maya2018-$(PACKAGE)
	sed -i "s%NEEDS_MAYA_MODULE_PATH%$(INSTALL_PATH)%g" $(PACKAGE_NEEDS_DIR)/maya2018-$(PACKAGE)
	install -m 644 need $(PACKAGE_NEEDS_DIR)/maya2020-$(PACKAGE)
	sed -i "s%NEEDS_MAYA_MODULE_PATH%$(INSTALL_PATH)%g" $(PACKAGE_NEEDS_DIR)/maya2020-$(PACKAGE)
	install -m 644 need $(PACKAGE_NEEDS_DIR)/maya2022-$(PACKAGE)
	sed -i "s%NEEDS_MAYA_MODULE_PATH%$(INSTALL_PATH)%g" $(PACKAGE_NEEDS_DIR)/maya2022-$(PACKAGE)

	# Copy mGear across
	#unzip $(INSTALLERS_ROOT)/$(ARCHIVE) -d $(PACKAGE_SW_DIR)
	rsync -av --exclude='osx' --exclude='windows' --exclude='*.pyc'  ./release $(PACKAGE_SW_DIR)/.


rpm:
	cd $(PACKAGE_ROOT) && \
	fpm -s dir -t rpm --name $(PACKAGE) -v $(VERSION) --iteration $(ITERATION) \
	--package ./../ \
	--force \
	--maintainer "$(MAINTAINER)" \
	--vendor "Storm Studios" \
	--url "http://stormstudios.no" \
	--rpm-summary "$(SUMMARY)" \
	--rpm-auto-add-directories \
	--rpm-auto-add-exclude-directories /sw \
	--rpm-auto-add-exclude-directories /sw/$(NAME) \
	--rpm-auto-add-exclude-directories /etc/needs \
	--architecture native \
	--prefix / \
	sw \
	etc

uninstall:
	rm -rf $(PACKAGE_ROOT)
