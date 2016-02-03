[indent=4]
uses
    SDL
    Bosco
    Bosco.ECS

class ViewManagerSystem : DarkMatter implements ISystem, ISetWorld

    _renderer : unowned Renderer
    _group: Group

    construct(renderer : Renderer)
        _renderer = renderer

    /**
     * Listen for resources to be added
     * and then load them in from the file
     */
    def setWorld(world:World)
        _group = world.getGroup(Matcher.AllOf({Components.ResourceComponent}))
        _group.onEntityAdded.add(onEntityAdded)

    /**
     *  OnEntityAdded event:
     */
    def onEntityAdded(g : Group, e : Entity, i : int, c : IComponent)

        var res = (ResourceComponent)c
        res.image = Image.fromFile(_renderer, res.path)
        if res.image == null do print "Failed to load %s", res.path
