MODULES=systemd bin lib
include build_rules/branch.mk
include build_rules/features/deploy/debian.mk

.PHONY: all
all: build deploy-debian

TESTS=$(wildcard tests/*.bats)

build:
	@cp -Rv systemd/$(BUILD_DIR)/* $(BUILD_DIR)/
	@cp -Rv bin/$(BUILD_DIR)/* $(BUILD_DIR)/
	@cp -Rv lib/$(BUILD_DIR)/* $(BUILD_DIR)/
	@mkdir -p $(BUILD_DIR)/usr/share/dhcp_listener
	@touch $(BUILD_DIR)/usr/share/dhcp_listener/subscribers
