[indent=4]
uses
    Bosco
    Bosco.ECS

def createBackground():Entity

    var res = new ResourceComponent()
    res.path = "resources/background.png"
    res.image = null

    var pos = new PositionComponent()
    pos.x = 0
    pos.y = 0

    var entity = World.instance.createEntity("background")
    try
        entity.addComponent(Components.ResourceComponent, res)
        entity.addComponent(Components.PositionComponent, pos)
    except e:Exception
        print e.message
    return entity
