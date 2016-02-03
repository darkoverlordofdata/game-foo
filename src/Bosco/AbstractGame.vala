using SDL;

namespace Bosco {
    public class AbstractGame : DarkMatter {

        protected Window window;
        protected Renderer renderer;
        protected string name;
        protected int width;
        protected int height;
        protected bool running;

        public int OnExecute() {
            if (OnInit() == false) {
                return -1;
            }

            Event e;
            while (running) {
                while (Event.poll(out e) != 0) {
                    OnEvent(e);
                }
                OnLoop();
                OnRender();
            }
            OnCleanup();
            return 0;
        }

        public virtual void OnEvent(Event e) {}
        public virtual void OnLoop() {}
        public virtual void OnRender() {}
        public virtual void OnCleanup() {}


        /**
         * Initialize SDL
         */
        public virtual bool OnInit() {
            if (SDL.init(SDL.InitFlag.VIDEO) < 0) {
                stdout.printf("SDL could not initialize! SDL Error: %s\n", SDL.get_error());
                return false;
            }

            if (SDLImage.init(SDLImage.InitFlags.PNG) < 0) {
                stdout.printf("SDL_image could not initialize! SDL_image Error: %s\n", SDLImage.get_error());
                return false;
            }

            if (!SDL.Hints.set(Hints.RENDER_SCALE_QUALITY, "1")) {
                stdout.puts("Warning: Linear texture filtering not enabled!");
            }

            window = Window.create(name, Window.POS_CENTERED, Window.POS_CENTERED, width, height, Window.Flags.SHOWN);
            if (window == null) {
                stdout.printf("Window could not be created! SDL Error: %s\n", SDL.get_error());
                return false;
            }

            renderer = Renderer.create_renderer(window, -1, Renderer.Flags.ACCELERATED | Renderer.Flags.PRESENTVSYNC);
            if (renderer == null) {
                stdout.printf("Renderer could not be created! SDL Error: %s\n", SDL.get_error());
                return false;
            }

            renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);

            return true;
        }
    }
}
