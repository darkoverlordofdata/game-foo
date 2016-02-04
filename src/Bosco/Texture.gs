/**
 * Image.gs
 *
 * Wrapper for SDLImage surface
 *
 *
 */
[indent=4]
namespace Bosco

    class Texture : DarkMatter
        texture : SDL.Texture
        width : int
        height : int

        def static fromRenderedText(renderer : SDL.Renderer, font : SDLTTF.Font, text : string, color : SDL.Color) : Texture?
            var mt = new Texture()
            var textSurface = font.render(text, color)

            if textSurface == null
                print "Unable to render text surface! SDL_ttf Error: %s", SDLTTF.get_error()
                return null
            else
                mt.texture = SDL.Texture.create_from_surface(renderer, textSurface)
                if mt.texture == null
                    print "Unable to create texture from rendered text! SDL Error: %s", SDL.get_error()
                    return null
                else
                    mt.width = textSurface.w
                    mt.height = textSurface.h
            return mt



        def static fromFile(renderer : SDL.Renderer, path : string) : Texture?
            var mt = new Texture()
            var loadedSurface = SDLImage.load(path)

            if loadedSurface == null
                print "Unable to load image %s! SDL_image Error: %s", path, SDLImage.get_error()
                return null
             else
                loadedSurface.set_colorkey(true, loadedSurface.format.map_rgb(0, 0xFF, 0xFF))

                mt.texture = SDL.Texture.create_from_surface(renderer, loadedSurface)
                if mt.texture == null
                    print "Unable to create texture from %s! SDL Error: %s", path, SDL.get_error()
                 else
                    mt.width = loadedSurface.w
                    mt.height = loadedSurface.h
            return mt

        def render(renderer : SDL.Renderer, x : int, y : int, clip : SDL.Rectangle? = null)
            renderQuad : SDL.Rectangle = {x, y, width, height}
            if clip != null
                renderQuad.w = clip.w
                renderQuad.h = clip.h
            renderer.copy(texture, clip, renderQuad)
