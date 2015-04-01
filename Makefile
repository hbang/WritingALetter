include theos/makefiles/common.mk

TWEAK_NAME = WritingALetter
WritingALetter_FILES = Tweak.xm $(wildcard *.m)
WritingALetter_FRAMEWORKS = AudioToolbox CoreGraphics QuartzCore UIKit
WritingALetter_LIBRARIES = cephei
WritingALetter_CFLAGS = -include Global.h

# SUBPROJECTS = prefs

include $(THEOS_MAKE_PATH)/tweak.mk
# include $(THEOS_MAKE_PATH)/aggregate.mk

after-stage::
	mkdir -p $(THEOS_STAGING_DIR)/Library/WritingALetter/Agents

after-install::
ifeq ($(RESPRING),0)
	install.exec "killall Preferences; sleep 0.2; sbopenurl prefs:root=WritingALetter"
else
	install.exec spring
endif
