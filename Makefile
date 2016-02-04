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

APP=src/game/Components.gs \
		src/game/Entities.gs \
		src/game/MovementSystem.gs \
		src/game/RenderPositionSystem.gs \
		src/game/ViewManagerSystem.gs \
		src/game/Game.gs


#
# source code for this project
#
SOURCES=src/DarkMatter.vala \
			src/Utils/UUID.vala \
			src/Bosco/ECS/Exception.vala \
			src/Bosco/Events/EntityReleased.gs \
			src/Bosco/Events/ComponentReplaced.gs \
			src/Bosco/Events/EntityChanged.gs \
			src/Bosco/Events/WorldChanged.gs \
			src/Bosco/Events/GroupsChanged.gs \
			src/Bosco/Events/GroupChanged.gs \
			src/Bosco/Events/GroupUpdated.gs \
			src/Bosco/Interfaces/IComponent.vala \
			src/Bosco/Interfaces/ISystem.vala \
			src/Bosco/Interfaces/IMatcher.vala \
			src/Bosco/ECS/Entity.gs \
			src/Bosco/ECS/Group.gs \
			src/Bosco/ECS/Matcher.gs \
			src/Bosco/ECS/World.gs \
			src/Bosco/Timer.gs \
			src/Bosco/Texture.gs \
			src/Bosco/AbstractGame.gs

OLD=src/DarkMatter.vala \
		old/Game.vala \
		old/AbstractGame.vala \
		old/Texture.vala

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

# default: $(BIN)/$(NAME)
# $(BIN)/$(NAME): $(OLD)
# 	-mkdir -p $(BIN)
# 	cp -R --force $(RESOURCES) $(BIN)
# 	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(OLD) -o $(BIN)/$(NAME)

test: test/$(BIN)/$(NAME)
test/$(BIN)/$(NAME): $(SOURCES) $(TST)
	-mkdir -p test/$(BIN)
	cp -R --force $(RESOURCES) test/$(BIN)
	$(VC) $(FLAGS) $(LIBS) $(CLIBS) $(CFLAGS) $(SOURCES) $(TST) -o test/$(BIN)/$(NAME)
	test/$(BIN)/$(NAME)
	rm --force test/$(BIN)/$(NAME)

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
