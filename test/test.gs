enum Components
    PositionComponent
    MovementComponent
    ImageComponent


class PositionComponent  : DarkMatter implements IComponent
    x:double
    y:double
    z:double

class MovementComponent  : DarkMatter implements  IComponent
    x:double
    y:double
    z:double

class ImageComponent  : DarkMatter implements IComponent
    path:string

class RenderingSystem : DarkMatter implements ISystem, ISetWorld, IInitializeSystem, IExecuteSystem
    world:World

    def setWorld(world:World)
        this.world = world

    def execute()
        pass

    def initialize()
        pass

class MovementSystem : DarkMatter implements ISystem, ISetWorld, IInitializeSystem, IExecuteSystem
    world:World

    def setWorld(world:World)
        this.world = world

    def execute()
        pass

    def initialize()
        pass
