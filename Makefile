include theos/makefiles/common.mk

TWEAK_NAME = WritingALetter
WritingALetter_FILES = Tweak.xm $(wildcard *.m)
WritingALetter_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall Preferences; sleep 0.2; sblaunch com.apple.Preferences; sleep 1; cycript -p Preferences alerttest.cy" || install.exec "sleep 1; cycript -p Preferences alerttest.cy"
