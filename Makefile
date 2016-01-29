# build GameFoo

# vala compiler
VC=valac

# vala flags
# -g debug
# -w
FLAGS=
DEBUG=-g --save-temps

#
# vala core libs
# reference the vala libs at /usr/share/vala/vapi
#
LIBS=--pkg glib-2.0 \
		--pkg gobject-2.0 \
		--pkg gee-1.0 \
		--pkg sdl2 \
		--pkg SDL2_gfx \
		--pkg SDL2_image \
		--pkg SDL2_ttf

TEST=test/src/Vunny.vala \
		test/src/TestExample.vala

APP=src/App.vala
#
# source code for this project
#
SOURCES=src/Utils/UUID.vala \
			src/Bosco/ECS/Exception.vala \
			src/Bosco/Events/EntityReleased.vala \
			src/Bosco/Events/ComponentReplaced.vala \
			src/Bosco/Events/EntityChanged.vala \
			src/Bosco/Events/WorldChanged.vala \
			src/Bosco/Events/GroupsChanged.vala \
			src/Bosco/Events/GroupChanged.vala \
			src/Bosco/Events/GroupUpdated.vala \
			src/Bosco/Interfaces/IComponent.vala \
			src/Bosco/Interfaces/ISystem.vala \
			src/Bosco/Interfaces/IMatcher.vala \
			src/Bosco/ECS/Entity.vala \
			src/Bosco/ECS/Group.vala \
			src/Bosco/ECS/Matcher.vala \
			src/Bosco/ECS/World.vala \
			src/Bosco/Texture.vala \
			src/Bosco/AbstractGame.vala


#
# c libs needed for the gcc compiler
#
CLIBS=-X -lm \
			-X -lSDL_gfx

#
# c flags needed for the gcc compiler
#
CFLAGS=-X -w \
			-X -I/usr/include/SDL

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
$(BIN)/$(NAME): $(SOURCES) $(APP)
	-mkdir -p $(BIN)
	cp -R --force $(RESOURCES) $(BIN)
	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(APP) -o $(BIN)/$(NAME)


run: $(BIN)/$(NAME)
	$(BIN)/$(NAME)

clean:
	rm -rf $(BIN)/*.o

debug: debug/$(BIN)/$(NAME)
debug/$(BIN)/$(NAME): $(TEST)
	-mkdir -p test/$(BIN)
	cp -R --force $(RESOURCES) test/$(BIN)
	$(VC) $(DEBUG) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(TEST) -o test/$(BIN)/$(NAME)
	env GTK_THEME=elementary:light nemiver test/$(BIN)/$(NAME)
	rm --force test/$(BIN)/$(NAME)
	rm -rf src/*.c
	rm -rf src/**/*.c
	rm -rf src/**/**/*.c

test: test/$(BIN)/$(NAME)
test/$(BIN)/$(NAME): $(TEST)
	-mkdir -p test/$(BIN)
	cp -R --force $(RESOURCES) test/$(BIN)
	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(TEST) -o test/$(BIN)/$(NAME)
	test/$(BIN)/$(NAME)
	rm --force test/$(BIN)/$(NAME)

# install:
# 	cp -f bin/webkat /usr/local/bin
# 	-mkdir /usr/local/share/icons
# 	cp -fr src/icon.png /usr/local/share/icons/webkat.png
#
# uninstall:
# 	rm -f /usr/local/bin/webkat
# 	rm -f /usr/local/share/icons/webkat.png
