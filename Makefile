# build GameFoo

# vala compiler
VC=valac

# vala flags
# -g debug
FLAGS=-g

#
# vala core libs
# reference the vala libs at /usr/share/vala/vapi
#
LIBS=--pkg glib-2.0 \
		--pkg gobject-2.0 \
		--pkg sdl2 \
		--pkg SDL2_gfx \
		--pkg SDL2_image \
		--pkg SDL2_ttf

#
# source code for this project
#
SOURCES=src/Bosco.Texture.vala \
			src/Bosco.AbstractGame.vala \
			src/App.vala

#
# c libs needed for the gcc compiler
#
CLIBS=-X -lm \
			-X -lSDL_gfx

#
# c flags needed for the gcc compiler
#
CFLAGS=-X -I/usr/include/SDL

#
# Folder for finished binaries
#
BIN=build
.PHONY: build

#
# Application NAME
#
NAME=gamefoo

#
# Resouce location
#
RESOURCES=resources


default: $(BIN)/$(NAME)
$(BIN)/$(NAME): $(SOURCES)
	-mkdir -p $(BIN)
	cp -R --force $(RESOURCES) $(BIN)
	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) -o $(BIN)/$(NAME)


run: $(BIN)/$(NAME)
	$(BIN)/$(NAME)

clean:
	rm -rf $(BIN)/*.o

# install:
# 	cp -f bin/webkat /usr/local/bin
# 	-mkdir /usr/local/share/icons
# 	cp -fr src/icon.png /usr/local/share/icons/webkat.png
#
# uninstall:
# 	rm -f /usr/local/bin/webkat
# 	rm -f /usr/local/share/icons/webkat.png
