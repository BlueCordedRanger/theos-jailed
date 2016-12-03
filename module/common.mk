# Module paths
THEOS_JAILED_PATH := $(THEOS_MODULE_PATH)/jailed
THEOS_JAILED_BIN := $(THEOS_JAILED_PATH)/bin
THEOS_JAILED_LIB := $(THEOS_JAILED_PATH)/lib

# Shell scripts
export MESSAGES := $(THEOS_JAILED_BIN)/messages.sh
export STAGE := $(THEOS_JAILED_BIN)/stage.sh
export INSERT_DYLIB := $(THEOS_JAILED_BIN)/insert_dylib
export INFO_TEMPLATE := $(THEOS_JAILED_BIN)/info.txt
export INFO_SCRIPT := $(THEOS_JAILED_BIN)/info.sh
export IPA_SCRIPT := $(THEOS_JAILED_BIN)/ipa.sh
export EXO_SCRIPT := $(THEOS_JAILED_BIN)/exo.sh
export UPDATE_SCRIPT := $(THEOS_JAILED_BIN)/update

# Directories
export RESOURCES_DIR ?= Resources
export STAGING_DIR := $(THEOS_STAGING_DIR)
export PACKAGES_DIR := $(THEOS_PROJECT_DIR)/$(THEOS_PACKAGE_DIR_NAME)

# Resources
export IPA ?= $(strip $($(TWEAK_NAME)_IPA))
export DYLIB ?= $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib
export OUTPUT_NAME = $(TWEAK_NAME)$(_THEOS_INTERNAL_PACKAGE_VERSION).ipa

# Codesigning
export DEV_CERT_NAME ?= iPhone Developer
export ENTITLEMENTS ?= $(STAGING_DIR)/entitlements.xml
export PROFILE ?= *

# Cycript
export USE_CYCRIPT = $(call __theos_bool,$(or $($(TWEAK_NAME)_USE_CYCRIPT),$(DEBUG)))
export CYCRIPT ?= $(THEOS_JAILED_LIB)/Cycript.dylib

# CydiaSubstrate
export USE_SUBSTRATE = $(or $($(TWEAK_NAME)_USE_SUBSTRATE),$(_THEOS_TARGET_DEFAULT_USE_SUBSTRATE),$(_THEOS_TRUE))
export SUBSTRATE ?= $(THEOS_JAILED_LIB)/CydiaSubstrate.framework

# Extensify Exo
export EXO_STAGING_DIR = $(STAGING_DIR)/$(TWEAK_NAME)
export EXO_RESOURCES_DIR = $(EXO_STAGING_DIR)/ExoResources
export EXO_OUTPUT_NAME = $(TWEAK_NAME)$(_THEOS_INTERNAL_PACKAGE_VERSION).zip

# Miscellaneous
export TWEAK_NAME PRINT_FORMAT_MAKING PRINT_FORMAT_STAGE PRINT_FORMAT_ERROR
