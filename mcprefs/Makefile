include $(THEOS)/makefiles/common.mk

ADDITIONAL_CFLAGS = -fobjc-arc

BUNDLE_NAME = MCPrefs
MCPrefs_FILES = MCPrefs.mm UIImage+ImageEffects.m
MCPrefs_INSTALL_PATH = /Library/PreferenceBundles
MCPrefs_FRAMEWORKS = UIKit CoreGraphics MobileCoreServices AssetsLibrary Accelerate QuartzCore MessageUI Social
MCPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MCPrefs.plist$(ECHO_END)
