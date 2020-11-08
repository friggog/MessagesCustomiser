ADDITIONAL_CFLAGS = -fobjc-arc

TWEAK_NAME = CustomMessagesColour
CustomMessagesColour_FILES = Tweak.xm UIImage+ImageEffects.m
CustomMessagesColour_FRAMEWORKS = UIKit MessageUI CoreGraphics QuartzCore Accelerate AssetsLibrary
CustomMessagesColour_PRIVATE_FRAMEWORKS = PhotosUI ChatKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += mcprefs
include $(THEOS_MAKE_PATH)/aggregate.mk