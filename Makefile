# build GameFoo

# vala compiler
VC=valac
# debug flag
VFLAGS=-g
# vala core libs
CORE=--pkg glib-2.0 \
		--pkg gobject-2.0
# vala SDL2 libs
SDL=--pkg sdl2 \
		--pkg SDL2_gfx \
		--pkg SDL2_image \
		--pkg SDL2_ttf
# source code for this project
SOURCES=src/Bosco.Texture.vala \
			src/Bosco.AbstractGame.vala \
			src/App.vala
# libs for the gcc compiler
CLIBS=-X -lm \
			-X -lSDL_gfx
# flags for the gcc compiler
CFLAGS=-X -I/usr/include/SDL

BIN=build
NAME=gamefoo
RESOURCES=resources

.PHONY: build

default: $(BIN)/$(NAME)

$(BIN)/$(NAME): $(SOURCES)
	-mkdir -p $(BIN)
	cp -R --force $(RESOURCES) $(BIN)
	$(VC) $(VFLAGS) $(CORE) $(SDL) $(CLIBS) $(CFLAGS) $(SOURCES) -o $(BIN)/$(NAME)


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
