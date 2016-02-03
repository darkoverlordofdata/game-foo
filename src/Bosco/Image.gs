/**
 * Image.gs
 *
 * Wrapper for SDLImage surface
 *
 *
 */
[indent=4]
namespace Bosco

    class Image : DarkMatter
        texture : SDL.Texture
        width : int
        height : int

        def static fromFile(renderer : SDL.Renderer, path : string) : Image?
            var mt = new Image()
            var loadedSurface = SDLImage.load(path)

            if loadedSurface == null
                print "Unable to load image %s! SDL_image Error: %s", path, SDLImage.get_error()
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
