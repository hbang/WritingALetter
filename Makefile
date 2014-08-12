include theos/makefiles/common.mk

TWEAK_NAME = WritingALetter
WritingALetter_FILES = Tweak.xm $(wildcard *.m)
WritingALetter_FRAMEWORKS = AudioToolbox CoreGraphics QuartzCore UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-stage::
	mkdir -p $(THEOS_STAGING_DIR)/Library/WritingALetter/Agents

after-install::
	install.exec spring
