[indent=4]
uses
    Bosco
    Bosco.ECS

def createBackground():Entity
    var image = new ImageComponent()
    image.path = "resources/background.png"
    var pos = new PositionComponent()
    pos.x = 0
    pos.y = 0
    var sprite = new SpriteComponent()

    var entity = World.world.createEntity("background")
    entity.addComponent(ImageComponent, image)
    entity.addComponent(PositionComponent, pos)
    entity.addComponent(SpriteComponent, sprite)
    return entity


def createPlayer():Entity
    pass
