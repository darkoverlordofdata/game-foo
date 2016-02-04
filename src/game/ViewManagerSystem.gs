[indent=4]
uses
    SDL
    Bosco
    Bosco.ECS

class ViewManagerSystem : DarkMatter implements ISystem, IInitializeSystem, ISetWorld

    _renderer : unowned Renderer
    _group: Group
    _world: World

    construct(renderer : Renderer)
        _renderer = renderer

    def setWorld(world : World)
        _world = world

    /**
     * Listen for resources to be added
     * and then load them in from the file
     */
    def initialize()
        _group = _world.getGroup(Matcher.AllOf({Components.ResourceComponent}))
        _group.onEntityAdded.add(onEntityAdded)

    /**
     *  OnEntityAdded event:
     */
    def onEntityAdded(g : Group, e : Entity, i : int, c : IComponent)

        var res = (ResourceComponent)c
        res.image = Bosco.Texture.fromFile(_renderer, res.path)
        if res.image == null
            print "Failed to load %s", res.path
