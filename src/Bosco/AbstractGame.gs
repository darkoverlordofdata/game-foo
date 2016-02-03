[indent=4]
uses SDL

namespace Bosco
    class AbstractGame : DarkMatter

        name : string
        width : int
        height : int
        running : bool
        window : Window
        renderer : Renderer

        def OnExecute() : int
            if OnInit() == false
                return -1

            e : Event
            while running
                while Event.poll(out e) != 0
                    OnEvent(e)
                OnLoop()
                OnRender()

            OnCleanup()
            return 0

        def virtual OnEvent(e: Event)
            pass

        def virtual OnLoop()
            pass

        def virtual OnRender()
            pass

        def virtual OnCleanup()
            pass

        /**
         * Initialize SDL
         */
        def virtual OnInit() : bool

            if SDL.init(SDL.InitFlag.VIDEO) < 0
                print "SDL could not initialize! SDL Error: %s", SDL.get_error()
                return false

            if SDLImage.init(SDLImage.InitFlags.PNG) < 0
                print "SDL_image could not initialize! SDL_image Error: %s", SDLImage.get_error()
                return false

            if !SDL.Hints.set(Hints.RENDER_SCALE_QUALITY, "1")
                print "Warning: Linear texture filtering not enabled!"

            window = Window.create(name, Window.POS_CENTERED, Window.POS_CENTERED, width, height, Window.Flags.SHOWN)
            if window == null
                print "Window could not be created! SDL Error: %s", SDL.get_error()
                return false

            renderer = Renderer.create_renderer(window, -1, Renderer.Flags.ACCELERATED | Renderer.Flags.PRESENTVSYNC)
            if renderer == null
                print "Renderer could not be created! SDL Error: %s", SDL.get_error()
                return false

            renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE)
            return true
