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
    x:int
    y:int

[Compact]
class MovementComponent  : DarkMatter implements  IComponent
    x:int
    y:int

[Compact]
class ResourceComponent : DarkMatter implements IComponent
    path:string
    image:Texture

[Compact]
class AnimationComponent  : DarkMatter implements IComponent
    frames:array of SDL.Rectangle
