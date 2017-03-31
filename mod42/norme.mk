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

ifeq ($(FANCY_OUT),on)

# Fancy Out - Norminette
norme:
ifeq ($(OPSYS),Darwin)
	@printf "\e[33mChecking 42 Norme :\e[m\e[20D"
	@norminette $(ALLHEADER) $(ALLSRC) | awk 'BEGIN { FS=":"; filename="" }\
	 	$$1 == "Norme" { filename=$$2; }\
		$$1 ~ /Error .+/ { \
			if (filename != "") {\
				print "\n\033[1;31mErrors on :\033[0;36m"filename;\
				filename=""\
			} \
			sub("Error ","",$$1);\
			if ($$2 == " C++ comment") { print "\033[0;33m"$$1"\033[32m"$$2 }\
			else { print "\033[0;33m"$$1"\033[0m"$$2 }\
		}' > tmp_norme.txt
	@if [[ -s tmp_norme.txt ]]; then cat tmp_norme.txt; else printf "\\e[1;32mNo norme error on rt sources\\e[m\\n"; fi;
	@rm tmp_norme.txt
else
	@printf "\e[33mNo Norminette here\e[m\n"
endif

else

# Raw Out - Norminette
norme:
ifeq ($(OPSYS),Darwin)
	@norminette $(ALLHEADER) $(ALLSRC)
else
	@echo "No Norminette here"
endif

endif
