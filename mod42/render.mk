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

# 42 target

$(RENDER_SUBDIRS):
	$(SILENT)mkdir -p $@

rerender: unrender
	@$(MAKE) render SILENT=$(SILENT)

unrender:
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)       $(I_MSG_END_WIP)" "\e[33mDelete\e[m \e[1m\e[35m$(RENDERDIR)"
endif
	$(SILENT)rm -rf $(RENDERDIR)
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)         $(I_MSG_END_OK)" "\e[31mDelete\e[m \e[1m\e[35m$(RENDERDIR)"
endif

render: $(RENDERDIR)/Makefile $(RENDERDIR)/auteur
	@#echo "$(RENDERDIR)"

$(RENDERDIR)/auteur:
	@echo "$(RENDER_BY)" > $(RENDERDIR)/auteur

$(RENDERDIR)/Makefile: $(RENDER_SUBDIRS) $(RENDER_HEADERS) $(RENDER_SRC) Makefile
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)    $(I_MSG_END_WIP)" "\e[33mStart rendering \e[37m\e[1m$@"
endif
	@printf "# **************************************************************************** #\n\
#                                                                              #\n\
#                                                         :::      ::::::::    #\n\
#    Makefile                                           :+:      :+:    :+:    #\n\
#                                                     +:+ +:+         +:+      #\n\
#    By: %-42.42s +#+  +:+       +#+         #\n\
#                                                 +#+#+#+#+#+   +#+            #\n\
#    Created: %-39.39s  #+#    #+#              #\n\
#    Updated: %-39.39s ###   ########.fr        #\n\
#                                                                              #\n\
# **************************************************************************** #\n\n\
NAME=$(NAME)\n\
CC=$(CC)\n\
CFLAGS=$(CFLAGS)\n\
CFLAGS_OBJ=$(I_CFLAGS_OBJS)\n\
INCFLAGS=$(INCFLAGS)\n\
LIBFLAGS=$(LIBSFLAGS)\n\
OBJ=" \
"$(RENDER_BY) <$(RENDER_EMAIL)>" "$(I_DATE) $(I_TIME) by $(RENDER_BY)" \
"$(I_DATE) $(I_TIME) by $(RENDER_BY)"  > $(RENDERDIR)/Makefile
	@sh -c 'for oname in $(RENDER_OBVAR); do echo "$$oname \\" >> $(RENDERDIR)/Makefile; done'
	@printf "\n\n.PHONY: clean fclean re all\n\t\$$(MAKE) clean\n\nall: \$$(NAME)\n\n" >> $(RENDERDIR)/Makefile
	@sh -c 'for oname in $(ALLSRC); do $(CC) -MM $$oname $(ALLCFLAGS) $(LIBSFLAGS) >> $(RENDERDIR)/Makefile;\
echo "	\$$(CC) -o \$$@ -c \$$< \$$(CFLAGS) \$$(CFLAGS_OBJ) \$$(INCFLAGS) " >> $(RENDERDIR)/Makefile; done'
ifeq ($(BUILDTYPE),lib)
	@printf "\n\$$(NAME): \$$(OBJ)\n\t$(LC) $(LFLAGS) \$$(NAME) \$$(OBJ)" >> $(RENDERDIR)/Makefile
else
ifeq ($(BUILDTYPE),dynalib)
	@printf "\n\$$(NAME): \$$(OBJ)\n\t\$$(CC) \$$(OBJ) -shared -o \$$@ \$$(CFLAGS) \$$(INCFLAGS) \$$(LIBFLAGS)" >> $(RENDERDIR)/Makefile
else
	@printf "\n\$$(NAME): \$$(OBJ)\n\t\$$(CC) \$$(OBJ) -o \$$@ \$$(CFLAGS) \$$(INCFLAGS) \$$(LIBFLAGS)" >> $(RENDERDIR)/Makefile
endif
endif
	@printf "\n\nclean:\n\trm -rf \$$(OBJ)\n\nfclean: clean\n\trm -rf \$$(NAME)\n\nre: fclean all\n\n" >> $(RENDERDIR)/Makefile
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)  $(I_MSG_END_OK)" "\e[1;36m$@ \e[mrendered !"
else
	@echo "Makefile rendered"
endif

$(RENDER_SRC): $(RENDERDIR)/%.c: %.c
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)$(I_MSG_END_WIP)" "\e[35m$< \e[33mbeing copied"
endif
	$(SILENT)cp $< $@
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)$(I_MSG_END_OK)" "\e[36m$< \e[mCopied !"
endif

$(RENDER_HEADERS): $(RENDERDIR)/%.h: %.h
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_WIP)$(I_MSG_END_WIP)" "\e[35m$< \e[33mbeing copied"
endif
	$(SILENT)cp $< $@
ifeq ($(FANCY_OUT),on)
	@printf "$(I_MSG_START_OK)$(I_MSG_END_OK)" "\e[36m$< \e[mcopied !"
endif
