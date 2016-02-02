namespace Bosco {

    public class Texture : DarkMatter {
        private SDL.Texture texture;
        public int width {get; private set;}
        public int height {get; private set;}

        public static Texture? fromFile(SDL.Renderer renderer, string path) {
            Texture mt = new Texture();
            SDL.Surface loadedSurface = SDLImage.load(path);

            if (loadedSurface == null) {
                stdout.printf("Unable to load image %s! SDL_image Error: %s\n", path, SDLImage.get_error());
            } else {
                loadedSurface.set_colorkey(true, loadedSurface.format.map_rgb(0, 0xFF, 0xFF));

                mt.texture = SDL.Texture.create_from_surface(renderer, loadedSurface);
                if (mt.texture == null) {
                    stdout.printf("Unable to create texture from %s! SDL Error: %s\n", path, SDL.get_error());
                } else {
                    mt.width = loadedSurface.w;
                    mt.height = loadedSurface.h;
                }
            }

            return mt;
        }

        public void render(SDL.Renderer renderer, int x, int y, SDL.Rectangle? clip = null) {
            SDL.Rectangle renderQuad = {x, y, width, height};
            if (clip != null) {
                renderQuad.w = clip.w;
                renderQuad.h = clip.h;
            }
            renderer.copy(texture, clip, renderQuad);
        }

        public void set_color(uint8 red, uint8 green, uint8 blue) {
            texture.set_color_mod(red, green, blue);
        }

        public void set_blendmode(SDL.BlendMode blending) {
            texture.set_blendmode(blending);
        }

        public void set_alpha(uint8 alpha) {
            texture.set_alpha(alpha);
        }
    }
}
