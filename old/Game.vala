using Bosco;

delegate void MyDelegate();

public class Game : AbstractGame {

    private const int WALKING_ANIMATION_FRAMES = 4;
    private const int SCREEN_WIDTH = 640;
    private const int SCREEN_HEIGHT = 480;

    private int frame = 0;

    private SDL.Rectangle spriteClips[4];
    private Texture spriteSheetTexture;
    private Texture backgroundTexture;

    Game() {
        name = "GameFoo";
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
        running = true;
    }

    /**
     *  OnLoop
     *
     * Process the physics
     */
    public override void OnLoop() {

        frame++;
        if (frame / WALKING_ANIMATION_FRAMES >= WALKING_ANIMATION_FRAMES)
            frame = 0;

    }

    /**
     *  OnRender
     *
     * Render the screen
     */
    public override void OnRender() {
        //Clear screen
        renderer.set_draw_color(0xFF, 0xFF, 0xFF, SDL.Alpha.OPAQUE);
        renderer.clear();

        SDL.Rectangle currentClip = spriteClips[frame / WALKING_ANIMATION_FRAMES];
        spriteSheetTexture.render(renderer, (SCREEN_WIDTH - currentClip.w) / 2, (SCREEN_HEIGHT - currentClip.h) / 2, currentClip);

        backgroundTexture.render(renderer, 0, 0);

        renderer.present();

    }

    /**
     *  OnInit
     *
     * load assets
     */
    public override bool OnInit() {
        if (base.OnInit()) {

            int imgInitFlags = SDLImage.InitFlags.PNG;
            int initResult = SDLImage.init(imgInitFlags);
            if ((initResult & imgInitFlags) != imgInitFlags) {
                stdout.printf("SDL_image could not initialize! SDL_image Error: %s\n", SDLImage.get_error());
                return false;
            }


            spriteSheetTexture = Texture.fromFile(renderer, "resources/foo.png");
            if (spriteSheetTexture == null) {
                stdout.puts("Failet to load walking animation texture!\n");
                return false;
            } else {
                spriteClips[0] = {0, 0, 64, 205};
                spriteClips[1] = {64, 0, 64, 205};
                spriteClips[2] = {128, 0, 64, 205};
                spriteClips[3] = {196, 0, 64, 205};
            }

            backgroundTexture = Texture.fromFile(renderer, "resources/background.png");
            if (backgroundTexture == null) {
                stdout.puts("Failet to load background texture image!\n");
                return false;
            }

        }
        return true;
    }

    /**
     *  OnEvent
     *
     * Handle events
     */
    public override void OnEvent(SDL.Event e) {
        if (e.type == SDL.EventType.QUIT) {
            running = false;
        }
    }

    /**
     *  OnCleanup
     *
     * release assets
     */
    public override void OnCleanup() {
        SDL.quit();
        SDLImage.quit();
    }


    public static int main(){

        var game = new Game();
        game.OnExecute();
        return 0;
    }


}
