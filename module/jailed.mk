# Disable codesigning (we'll sign the dylib later)
TARGET_CODESIGN =

# Use the internal generator instead of CydiaSubstrate
_THEOS_TARGET_DEFAULT_USE_SUBSTRATE = 0

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MODULE_PATH)/jailed/rules.mk
