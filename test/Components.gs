[indent=4]
uses
    Bosco
    Bosco.ECS

enum Components
    PositionComponent
    MovementComponent
    ImageComponent
    SpriteComponent
    AnimationComponent


class PositionComponent  : DarkMatter implements IComponent
    x:double
    y:double
    z:double

class MovementComponent  : DarkMatter implements  IComponent
    x:double
    y:double
    z:double

class ImageComponent : DarkMatter implements IComponent
    path:string

class SpriteComponent : DarkMatter implements IComponent
    texture:Texture

class AnimationComponent  : DarkMatter implements IComponent
    sprite:Texture
    frames:array of SDL.Rectangle
