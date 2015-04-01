include theos/makefiles/common.mk

BUNDLE_NAME = WritingALetter
WritingALetter_FILES = $(wildcard *.x) $(wildcard *.m)
WritingALetter_INSTALL_PATH = /Library/PreferenceBundles
WritingALetter_FRAMEWORKS = UIKit
WritingALetter_PRIVATE_FRAMEWORKS = Preferences
WritingALetter_LIBRARIES = cepheiprefs
WritingALetter_CFLAGS = -include ../Global.h

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WritingALetter.plist$(ECHO_END)
