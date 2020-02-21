CC := gcc
MODULES := src includes

LIBS		:= #-Llibft -lft
INCLUDE		:= -Iincludes #-Ilibft/includes
OBJFLAGS	:= -Wall -Werror -Wextra -c $(INCLUDE)
LINKFLAGS	:=
#CFLAGS		+= -g -fsanitize=address

MODNAME := module.mk
SRC :=

HOST_TYPE :=

ifeq ($(HOSTTYPE),)
	HOST_TYPE := $(shell uname -m)_$(shell uname -s)
else
	HOST_TYPE := $(HOSTTYPE)
endif

NAME := ft_otool

include $(patsubst %,%/$(MODNAME),$(MODULES))

OBJ :=  $(patsubst %.c,%.o,$(filter %.c,$(SRC)))
DEP :=	$(patsubst %.c,%.d,$(filter %.c,$(SRC)))

all: $(NAME)

-include $(DEP)

$(NAME): $(OBJ)
	$(CC) $(LINKFLAGS) $(OBJ)  -o $@

%.d : %.c
	@./depend.sh $*.o $(OBJFLAGS) $< > $@
	@printf '\t%s' "$(CC) $(OBJFLAGS) -o $*.o $<" >> $@
	@echo $@ >> all.log

clean:
	make clean -C libft
	rm -f $(OBJ)
	rm -f $(shell cat all.log)
	@rm -f all.log

clean_nolib:
	rm -f $(OBJ)
	rm -f $(shell cat all.log)
	@rm -f all.log

fclean: clean_nolib
	rm -f $(NAME)

re: clean_nolib all

.PHONY: all clean fclean re
