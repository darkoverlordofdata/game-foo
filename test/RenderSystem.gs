[indent=4]
uses
    Bosco
    Bosco.ECS

class RenderSystem : DarkMatter implements ISystem, ISetWorld, IInitializeSystem, IExecuteSystem
    world:World

    def setWorld(world:World)
        this.world = world

    def execute()
        pass

    def initialize()
        pass
