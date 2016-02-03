[indent=4]
uses
    SDL
    Bosco
    Bosco.ECS

class RenderPositionSystem : DarkMatter implements ISystem, ISetWorld, IExecuteSystem
    _renderer : unowned Renderer
    _group: Group

    construct(renderer : Renderer)
        _renderer = renderer

    def setWorld(world:World)
        _group = world.getGroup(Matcher.AllOf({Components.ResourceComponent, Components.PositionComponent}))

    def execute()
        for entity in _group.getEntities()
            // TODO: Shouldn't need try/catch inside of a loop...
            try
                var res = (ResourceComponent)entity.getComponent(Components.ResourceComponent)
                var pos = (PositionComponent)entity.getComponent(Components.PositionComponent)
                res.image.render(_renderer, pos.x, pos.y)

            except e:Exception
                print e.message
