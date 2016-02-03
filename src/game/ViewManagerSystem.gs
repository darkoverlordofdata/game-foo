[indent=4]
uses
    SDL
    Bosco
    Bosco.ECS

class ViewManagerSystem : DarkMatter implements ISystem, ISetWorld, IInitializeSystem, IExecuteSystem

    _renderer : unowned Renderer
    _group: Group

    construct(renderer : Renderer)
        _renderer = renderer

    def setWorld(world:World)
        _group = world.getGroup(Matcher.AllOf({Components.ResourceComponent}))
        _group.onEntityAdded.add(onEntityAdded)

    def execute()
        try
            for entity in _group.getEntities()
                var c = (ResourceComponent)entity.getComponent(Components.ResourceComponent)
                c.texture.render(_renderer, 0, 0)

        except e:Exception
            print e.message

    def initialize()
        pass

    /**
     *  OnEntityAdded event:
     */
    def onEntityAdded(g : Group, e : Entity, i : int, c : IComponent)

        var res = (ResourceComponent)c
        res.texture = Bosco.Texture.fromFile(_renderer, res.path)

        if res.texture == null
            print "Failed to load %s", res.path
