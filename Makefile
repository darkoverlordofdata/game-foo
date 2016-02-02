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

TST=test/src/Vunny.gs \
		test/src/Should.gs \
		test/src/Test.gs \
		test/src/To.gs \
		test/TestFX.gs

APP=src/Game.vala

DEMO=test/Game.gs \
			test/Components.gs \
			test/Entities.gs \
			test/MovementSystem.gs \
			test/RenderSystem.gs

#
# source code for this project
#
SOURCES=src/DarkMatter.vala \
			src/Utils/UUID.vala \
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
			src/Bosco/ECS/Entity.gs \
			src/Bosco/ECS/Group.gs \
			src/Bosco/ECS/Matcher.gs \
			src/Bosco/ECS/World.gs \
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

test: test/$(BIN)/$(NAME)
test/$(BIN)/$(NAME): $(SOURCES) $(TST)
	-mkdir -p test/$(BIN)
	cp -R --force $(RESOURCES) test/$(BIN)
	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(TST) -o test/$(BIN)/$(NAME)
	test/$(BIN)/$(NAME)
	rm --force test/$(BIN)/$(NAME)

demo: demo/$(BIN)/$(NAME)
demo/$(BIN)/$(NAME): $(SOURCES) $(DEMO)
	-mkdir -p demo/$(BIN)
	cp -R --force $(RESOURCES) demo/$(BIN)
	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(DEMO) -o demo/$(BIN)/$(NAME)

run: $(BIN)/$(NAME)
	$(BIN)/$(NAME)

clean:
	rm -rf $(BIN)/*.o

debug: debug/$(BIN)/$(NAME)
debug/$(BIN)/$(NAME): $(SOURCES) $(TST)
	-mkdir -p test/$(BIN)
	cp -R --force $(RESOURCES) test/$(BIN)
	$(VC) $(DEBUG) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(TST) -o test/$(BIN)/$(NAME)
	env GTK_THEME=elementary:light nemiver test/$(BIN)/$(NAME)
	rm --force test/$(BIN)/$(NAME)
	rm -rf src/*.c
	rm -rf src/**/*.c
	rm -rf src/**/**/*.c

# install:
# 	cp -f bin/webkat /usr/local/bin
# 	-mkdir /usr/local/share/icons
# 	cp -fr src/icon.png /usr/local/share/icons/webkat.png
#
# uninstall:
# 	rm -f /usr/local/bin/webkat
# 	rm -f /usr/local/share/icons/webkat.png
