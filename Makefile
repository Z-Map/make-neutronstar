#               [ MakeNeutronStar ]                   _______________________  #
#---*==========={=================}=============*----|                       |-#
#   |            AAA         KKKK    KKKK       |    |  By : _Map_           | #
#   |           AAAAA        KEEE   KKKK        |    |  License :            | #
#   |          AAA AAA       KEKK  KKKK         |    |  The Unlicense        | #
#   |         AAA   AAA      KEKKOKKKK          |    \_______________________| #
#   |        AAAAAAAAAAA     KEEO OMK           |                              #
#   |       AAAAAAAAAAAAA    KEKKOKKKK          |                              #
#   |      AAAAA     AAAAA   KEKK  KKKK         |                              #
#   |     AAAAA       AAAAA  KEEE   KKKK        |                              #
#   |    AAAAA   LIB   AAAAA KKKK    KKKK       |                              #
#   *===========================================*                              #

#------------------------------------------------------------------------------#
#                              Setup                                           #
#------------------------------------------------------------------------------#

# Project var
NAME		= libft.a
HEADERS		= include includes
SOURCES		= mem lst str format parse io wstr unicode printf math
MKLIBS		= #libft/libft.a libdraw/libdraw.a minilibx/libmlx.a
LIBSHEADERS	=
LIBS		= #m bsd
LIBSDIRS	=

# Environnement var
SRC_ROOT	= off
LIBSDIR		= libs/
OPSYS		= $(shell uname -s)
FANCY_OUT	= on
CHRONOS_NAZI_MODE = on

ifndef config
	config=release
endif

ifndef LOGNAME
	LOGNAME=$(USER)
endif

# Compilation var
ifndef CC
	CC=clang
endif

ifndef LC
	LC=ar
endif
ifeq ($(CHRONOS_NAZI_MODE)_$(CC),on_clang)
	CFLAGS=-Wextra -Werror -Weverything
else
	CFLAGS=-Wextra -Werror -Wall -Wpadding
endif

LFLAGS		= -rcs

ifeq ($(config),release)
	CFLAGS	+= -O2
	OBJDIR	= release
endif

ifeq ($(config),debug)
	CFLAGS	+= -O1 -g3 -fsanitize=address -fno-omit-frame-pointer -fno-optimize-sibling-calls
	OBJDIR	= debug
endif

ifeq ($(config),opti)
	CFLAGS	+= -Ofast
	OBJDIR	= opti
endif

BUILDIR		= build/$(OBJDIR)
TARGETDIR	= .
PROJECTPATH	= $(CURDIR)

# Render var
RENDERDIR		=
RENDER_BY		= qloubier
RENDER_EMAIL	= marvin@student.42.fr

# Messages

LINE_LEN			= 80
MSG_COMPILE_LIB		= Creating :
MSG_COMPILE_EXE		= Compiling :
MSG_COMPILE_OBJ		= Compiling :
MSG_COMPILE_DONE	= is done !
MSG_CLEAN_OBJECTS	= Clean Objects files
MSG_CLEAN_LIB		= Clean Library file
MSG_CLEAN_EXE		= Clean Executable

#===============================================================================
# intern var
ifeq ($(FANCY_OUT),on)
	SILENT=@
else
	SILENT=
endif

I_CFLAGS_OBJS=
ifeq ($(shell printf "$(NAME)" | tail -c2),.a)
	I_MSG_COMPILE	= $(MSG_COMPILE_LIB)
	I_MSG_CLEAN		= $(MSG_CLEAN_LIB)
	BUILDTYPE		= lib
	I_REAL_NAME		= $(NAME:%.a=%)
else
ifeq ($(shell printf "$(NAME)" | tail -c3),.so)
	I_MSG_COMPILE	= $(MSG_COMPILE_LIB)
	I_MSG_CLEAN		= $(MSG_CLEAN_LIB)
	BUILDTYPE		= dynalib
	I_REAL_NAME		= $(NAME:%.so=%)
	I_CFLAGS_OBJS	+= -fPIC
else
	I_MSG_COMPILE	= $(MSG_COMPILE_EXE)
	I_MSG_CLEAN		= $(MSG_CLEAN_EXE)
	BUILDTYPE		= exe
	I_REAL_NAME		= $(NAME)
endif
endif
ifeq ($(strip $(RENDERDIR)),)
	RENDERDIR		= $(BUILDIR)/$(I_REAL_NAME)
endif
I_DATE=$(shell date "+%Y/%m/%d")
I_TIME=$(shell date "+%H:%M:%S")
I_NAME_LEN=$(shell printf "$(NAME)" | wc -c)
I_MSGC_LEN=$(shell printf "$(I_MSG_COMPILE)" | wc -c)
I_MSGO_LEN=$(shell printf "$(MSG_COMPILE_OBJ)" | wc -c)
I_WIP_LEN=$(shell echo "$(LINE_LEN) - 13" | bc)
I_OK_LEN=$(shell echo "$(LINE_LEN) - 6" | bc)
I_MSG_START_WIP=\\e[$(LINE_LEN)D%-$(I_WIP_LEN).$(I_WIP_LEN)b
I_MSG_END_WIP=\\e[m[\\e[33min progress\\e[m]\\e[$(LINE_LEN)D
I_MSG_START_OK=\\e[$(LINE_LEN)D%-$(I_OK_LEN).$(I_OK_LEN)b
I_MSG_END_OK=\\e[m[\\e[32mok\\e[m]\\n
OBBUDIR=$(PROJECTPATH)/$(BUILDIR)
OBBUWC=$(shell echo "$(OBBUDIR)/" | wc -c)
OBBUDIRS=$(BUILDIR) $(OBBUDIR) $(shell for dir in $(SOURCES); do printf "$(OBBUDIR)/$$dir "; done)
ALLINC=$(HEADERS) $(LIBSHEADERS)
INCFLAGS=$(shell echo "-I$(ALLINC)" | sed "s/ \(.\)/ -I\1/g")
ifeq ($(SRC_ROOT),on)
	ALLHEADER=$(shell find *.h -type f 2> /dev/null; for dir in $(HEADERS); do find $$dir/*.h -type f 2> /dev/null; done)
	ALLSRC=$(shell find *.c -type f 2> /dev/null; for dir in $(SOURCES); do find $$dir/*.c -type f 2> /dev/null; done)
else
	ALLHEADER=$(shell for dir in $(HEADERS); do find $$dir/*.h -type f 2> /dev/null; done)
	ALLSRC=$(shell for dir in $(SOURCES); do find $$dir/*.c -type f 2> /dev/null; done)
endif
ALLOBJ=$(shell for oname in $(ALLSRC:.c=.o); do printf "$(OBBUDIR)/$$oname "; done)
ifndef ALLOBJ_GUARD
	ALLOBJ_GUARD=off
endif
ALLLIBSDIRS=$(shell for lib in $(MKLIBS); do dirname "$(LIBSDIR)$$lib"; done) $(LIBSDIRS)
ALLLIBS=$(shell for lib in $(MKLIBS); do basename "$$lib" | head -c-3 | tail -c+4; printf " "; done)$(LIBS)
LIBSFLAGS=$(shell echo "-L$(ALLLIBSDIRS)" | sed "s/ \(.\)/ -L\1/g" | sed "s/^-L *$$/ /g") $(shell echo "-l$(ALLLIBS)" | sed "s/ \(.\)/ -l\1/g" | sed "s/^-l *$$/ /g")
ALLCFLAGS=$(CFLAGS) $(INCFLAGS)
I_MKFLIB=$(shell for lib in $(MKLIBS); do dirname "$(LIBSDIR)$$lib" | xargs -0 printf "%s"; done)
I_MKNSLIB=$(shell for lib in $(MKLIBS); do make -si -C "$(LIBSDIR)$$lib" neutronstar-check | xargs -0 printf "%s"; done)
# ALLDEP=$(ALLOBJ:.o=.d)

RENDER_SUBDIRS=$(shell for dir in $(SOURCES) $(HEADERS); do printf "$(RENDERDIR)/$$dir "; done)
RENDER_SRC=$(shell for cname in $(ALLSRC); do printf "$(RENDERDIR)/$$cname "; done)
RENDER_HEADERS=$(shell for hname in $(ALLHEADER); do printf "$(RENDERDIR)/$$hname "; done)
RENDER_OBVAR=$(shell for oname in $(ALLOBJ); do basename $$oname; done)

NS_DIR	= $(CURDIR)

#------------------------------------------------------------------------------#
#                             Compile Rules                                    #
#------------------------------------------------------------------------------#

# PHONY rules
.PHONY: neutronstar clean fclean re all\
		norme render
		$(SILENT)$(MAKE) clean

# Generic rules
all: $(TARGETDIR)/$(NAME)

install:
	@echo "$(I_MKNSLIB)"

clean:
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)       $(I_MSG_END_WIP)" "\e[33m$(MSG_CLEAN_OBJECTS) \e[mfor \e[1m\e[35m$(NAME)"
endif
	$(SILENT)rm -rf $(OBBUDIR)
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)         $(I_MSG_END_OK)" "\e[31m$(MSG_CLEAN_OBJECTS) \e[mfor \e[1m\e[35m$(NAME)"
endif

fclean: clean
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)       $(I_MSG_END_WIP)" "\e[33m$(I_MSG_CLEAN) \e[mfor \e[1m\e[35m$(NAME)"
endif
	$(SILENT)rm -rf $(TARGETDIR)/$(NAME)
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)         $(I_MSG_END_OK)" "\e[31m$(I_MSG_CLEAN) \e[mfor \e[1m\e[35m$(NAME)"
endif

re: fclean
ifeq ($(SILENT),@)
	$(SILENT)$(MAKE) -s all
else
	$(MAKE) all
endif

neutronstar-check:
	echo "ns"

include modASCIIart/neutronstar.mk

$(ALLSRC):

# Compilation rules
$(TARGETDIR)/$(NAME): $(OBBUDIRS) $(ALLOBJ)
ifeq (ALLOBJ_GUARD,on)
ifeq ($(SILENT),@)
	$(SILENT)$(MAKE) -s $@ ALLOBJ_GUARD=off
else
	@$(MAKE) $@ ALLOBJ_GUARD=off | grep "$(CC) -o"
endif
else
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)    $(I_MSG_END_WIP)" "\e[33m$(I_MSG_COMPILE) \e[1m\e[35m$(NAME)"
endif
ifeq ($(BUILDTYPE),lib)
	$(SILENT)$(LC) $(LFLAGS) $@ $(ALLOBJ)
else
ifeq ($(BUILDTYPE),dynalib)
	$(SILENT)$(CC) $(ALLOBJ) -shared -o $@ $(ALLCFLAGS) $(LIBSFLAGS)
else
	$(SILENT)$(CC) $(ALLOBJ) -o $@ $(ALLCFLAGS) $(LIBSFLAGS)
endif
endif
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)    $(I_MSG_END_OK)" "\e[1m\e[36m$(NAME)\e[m $(MSG_COMPILE_DONE)"
endif
endif

$(ALLOBJ): $(OBBUDIR)/%.o: %.c
ifeq ($(ALLOBJ_GUARD),off)
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)$(I_MSG_END_WIP)" "\e[33m$(MSG_COMPILE_OBJ) \e[35m$<"
endif
	$(SILENT)$(CC) -o $@ -c $< $(ALLCFLAGS) $(I_CFLAGS_OBJS)
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)$(I_MSG_END_OK)" "\e[36m$< \e[m$(MSG_COMPILE_DONE)"
endif
endif

$(OBBUDIRS):
	$(SILENT)mkdir -p $@
