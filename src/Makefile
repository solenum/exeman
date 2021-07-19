OBJS = bank0.asm
OBJS_NAME = bank0
OBJ_NAME = ld38

BDIR = build

ASM = rgbasm
LINK = rgblink
FIX = rgbfix

all : $(OBJS)
	$(ASM) -o$(BDIR)/$(OBJS_NAME).obj $(OBJS)
	$(LINK) -m$(BDIR)/$(OBJ_NAME).map -n$(BDIR)/$(OBJ_NAME).sym -o$(BDIR)/$(OBJ_NAME).gb $(BDIR)/$(OBJS_NAME).obj
	$(FIX) -p 0 -v $(BDIR)/$(OBJ_NAME).gb
	rm $(BDIR)/$(OBJS_NAME).obj