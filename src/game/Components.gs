[indent=4]
uses
    Bosco
    Bosco.ECS

enum Components
    PositionComponent
    MovementComponent
    ResourceComponent
    SpriteComponent
    AnimationComponent


[Compact]
class PositionComponent  : DarkMatter implements IComponent
    x:double
    y:double
    z:double

[Compact]
class MovementComponent  : DarkMatter implements  IComponent
    x:double
    y:double
    z:double

[Compact]
class ResourceComponent : DarkMatter implements IComponent
    path:string
    texture:Texture

[Compact]
class AnimationComponent  : DarkMatter implements IComponent
    sprite:Texture
    frames:array of SDL.Rectangle
