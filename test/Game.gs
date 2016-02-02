[indent=4]
uses
    Bosco


init
    stdout.printf("Application started\n")
    var game = new Game()
    game.OnExecute()

class Game : AbstractGame

    const WALKING_ANIMATION_FRAMES:int = 4
    const SCREEN_WIDTH:int = 640
    const SCREEN_HEIGHT:int = 480
    frame:int = 0

    spriteClips:array of SDL.Rectangle = new array of SDL.Rectangle[4]
    spriteSheetTexture:Texture
    backgroundTexture:Texture

    construct()
        name = "GameFoo"
        width = SCREEN_WIDTH
        height = SCREEN_HEIGHT
        running = true

    /**
     *  OnLoop
     *
     * Process the physics
     */
    def override OnLoop()
        frame++
        if frame / WALKING_ANIMATION_FRAMES >= WALKING_ANIMATION_FRAMES
            frame = 0

    /**
     *  OnRender
     *
     * Render the screen
     */
    def override OnRender()
        renderer.set_draw_color(0xFF, 0xFF, 0xFF, SDL.Alpha.OPAQUE)
        renderer.clear()

        var currentClip = spriteClips[frame / WALKING_ANIMATION_FRAMES]
        spriteSheetTexture.render(renderer, (SCREEN_WIDTH - currentClip.w) / 2, (SCREEN_HEIGHT - currentClip.h) / 2, currentClip)
        backgroundTexture.render(renderer, 0, 0)
        renderer.present()

    /**
     *  OnInit
     *
     * load assets
     */
    def override OnInit():bool
        if super.OnInit()

            var imgInitFlags = SDLImage.InitFlags.PNG
            var initResult = SDLImage.init(imgInitFlags)
            if (initResult & imgInitFlags) != imgInitFlags
                stdout.printf("SDL_image could not initialize! SDL_image Error: %s\n", SDLImage.get_error())
                return false

            spriteSheetTexture = Texture.fromFile(renderer, "resources/foo.png")
            if spriteSheetTexture == null
                stdout.puts("Failed to load walking animation texture!\n")
                return false
            else
                spriteClips[0] = {0, 0, 64, 205}
                spriteClips[1] = {64, 0, 64, 205}
                spriteClips[2] = {128, 0, 64, 205}
                spriteClips[3] = {196, 0, 64, 205}

            backgroundTexture = Texture.fromFile(renderer, "resources/background.png")
            if backgroundTexture == null
                stdout.puts("Failed to load background texture image!\n")
                return false

        return true

    /**
     *  OnEvent
     *
     * Handle events
     */
    def override OnEvent(e:SDL.Event)
        if e.type == SDL.EventType.QUIT
            running = false

    /**
     *  OnCleanup
     *
     * release assets
     */
    def override OnCleanup()
        SDL.quit()
        SDLImage.quit()
