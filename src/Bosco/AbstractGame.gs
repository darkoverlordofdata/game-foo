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

        prop readonly delta : double
        prop readonly ticks : int

        _lasttick : int
        _frametimes : array of int = {0,0,0,0,0,0,0,0,0,0}
        _frametimelast : int = 0
        _framecount : int = 0
        _framespersecond : double = 0.0
        _frameticklast : int
        _framedelta : double = 0.0
        _framefont: SDLTTF.Font



        def OnExecute() : int
            if OnInit() == false
                return -1

            e : Event
            while running
                while Event.poll(out e) != 0
                    OnEvent(e)
                _ticks = (int)SDL.Timer.get_ticks()
                _delta = (_ticks - _lasttick)/1000.0
                _lasttick = _ticks
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

            if SDLTTF.init() == -1
                print "SDL_ttf could not initialize! SDL_ttf Error: %s", SDLTTF.get_error()
                return false

            _frameticklast = _frametimelast = (int)SDL.Timer.get_ticks()
            _framefont = SDLTTF.Font.open("resources/Starjedi.ttf", 16)
            if _framefont == null
                print "Failed to load font!, SDL_ttf Error: %s", SDLTTF.get_error()

            return true

        def fpsTexture() : Bosco.Texture
            count : int
            // frametimesindex is the position in the array. It ranges from 0 to 10.
            // This value rotates back to 0 after it hits 10.
            var frametimesindex = _framecount % 10
            // save the frame time value
            _frametimes[frametimesindex] = ticks - _frametimelast
            // save the last frame time for the next fpsthink
            _frametimelast = ticks
            // increment the frame count
            _framecount++
            if _framecount < 10
                count = _framecount
            else
                count = 10

            // add up all the values and divide to get the average frame time.
            _framespersecond = 0
            for var i = 0 to (count-1)
                _framespersecond += _frametimes[i]
            _framespersecond /= count
            // now to make it an actual frames per second value...
            _framespersecond = 1000.0 / _framespersecond

            _framedelta = (ticks - _frameticklast)/1000.0
            // if frametimesindex == 0
            var s = "%2.2f".printf(_framespersecond)
            _frameticklast = ticks
            return Bosco.Texture.fromRenderedText(renderer, _framefont, s.substring(0, 5), {0, 0, 0})
