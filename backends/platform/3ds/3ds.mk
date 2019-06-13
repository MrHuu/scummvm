include backends/platform/3ds/app/game.info

APP_AUTHOR      := ScummVM Team
APP_BANNER_AUDIO:= $(srcdir)/backends/platform/3ds/app/banner.wav
APP_RSF         := $(srcdir)/backends/platform/3ds/app/scummvm.rsf

ARCH     := -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft
CXXFLAGS += -std=gnu++11
ASFLAGS  += -mfloat-abi=hard
LDFLAGS  += -specs=3dsx.specs $(ARCH) -L$(DEVKITPRO)/libctru/lib -L$(DEVKITPRO)/portlibs/3ds/lib

MAKEROM_PARAMS := -elf $(EXECUTABLE) -rsf $(APP_RSF) -banner $(TARGET).bnr -icon $(TARGET).smdh -DAPP_UNIQUE_ID=$(APP_UNIQUE_ID)

ifneq ($(GAME),)
	APP_ROMFS		:= $(srcdir)/pkg/ROMFS
	MAKEROM_PARAMS	+= -DAPP_ROMFS="$(APP_ROMFS)" -D_GAME="$(TARGET)"
endif

.PHONY: clean_3ds

clean: clean_3ds

clean_3ds:
	$(RM) $(TARGET).3dsx
	$(RM) $(TARGET).cia

$(TARGET).smdh: $(APP_ICON)
	@smdhtool --create "$(APP_TITLE)" "$(APP_DESCRIPTION)" "$(APP_AUTHOR)" $(APP_ICON) $@
	@echo built ... $(notdir $@)

$(TARGET).3dsx: $(EXECUTABLE) $(TARGET).smdh
	@3dsxtool $< $@ --smdh=$(TARGET).smdh
	@echo built ... $(notdir $@)
	
$(TARGET).bnr: $(APP_BANNER_IMAGE) $(APP_BANNER_AUDIO)
	@bannertool makebanner -o $@ -i $(APP_BANNER_IMAGE) -a $(APP_BANNER_AUDIO)
	@echo built ... $(notdir $@)

.cia: $(TARGET).cia
	
$(TARGET).cia: $(EXECUTABLE) $(APP_RSF) $(TARGET).smdh $(TARGET).bnr
	@makerom -f cia -target t -exefslogo -o $@ $(MAKEROM_PARAMS)
	@echo built ... $(notdir $@)

#---------------------------------------------------------------------------------
# rules for assembling GPU shaders
#---------------------------------------------------------------------------------
define shader-as
	$(eval FILEPATH := $(patsubst %.shbin.o,%.shbin,$@))
	$(eval FILE := $(patsubst %.shbin.o,%.shbin,$(notdir $@)))
	picasso -o $(FILEPATH) $1
	bin2s $(FILEPATH) | $(AS) -o $@
	echo "extern const u8" `(echo $(FILE) | sed -e 's/^\([0-9]\)/_\1/' | tr . _)`"_end[];" > `(echo $(FILEPATH) | tr . _)`.h
	echo "extern const u8" `(echo $(FILE) | sed -e 's/^\([0-9]\)/_\1/' | tr . _)`"[];" >> `(echo $(FILEPATH) | tr . _)`.h
	echo "extern const u32" `(echo $(FILE) | sed -e 's/^\([0-9]\)/_\1/' | tr . _)`_size";" >> `(echo $(FILEPATH) | tr . _)`.h
endef

vpath %.v.pica $(srcdir)
vpath %.g.pica $(srcdir)
vpath %.shlist $(srcdir)

%.shbin.o : %.v.pica %.g.pica
	@echo $(notdir $^)
	@$(call shader-as,$^)

%.shbin.o : %.v.pica
	@echo $(notdir $<)
	@$(call shader-as,$<)

%.shbin.o : %.shlist
	@echo $(notdir $<)
	@$(call shader-as,$(foreach file,$(shell cat $<),$(dir $<)/$(file)))
