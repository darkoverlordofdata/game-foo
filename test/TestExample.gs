[indent=4]
uses
    Utils
    Bosco.ECS

init
    new TestExample().run()

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

enum Components
    PositionComponent
    MovementComponent
    ImageComponent

class TestExample : Bunny.Vunny

    components: array of string = {"PositionComponent", "MovementComponent", "ImageComponent"}
    world:World
    player:Entity

    /** Initialize tests */
    construct()
        describe("TestExample")
        test("Match 1 2 3", test_match)
        test("Create world", test_world)
        test("Make player entity", test_player)
        test("Add player components", test_components)

    /** Setup */
    init
        world = new World(components)

    /** Teardown */
    final
        world = null


    /** Test the Match object */
    def test_match()
        m:Matcher = (Matcher)Matcher.AllOf({1, 2, 3})
        expect(m.toString()).to.equal("AllOf(1, 2, 3)")

    /** Test World creation */
    def test_world()
        expect(world.componentsCount).to.equal(components.length)

    def test_player()
        player = world.createEntity("player");
        expect(player.id).to.match("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""")

    def test_components()
        var pos = new PositionComponent()
        pos.x = 10
        pos.y = 20
        var delta = new MovementComponent()
        var sprite = new ImageComponent()

        try
            player.addComponent(Components.PositionComponent, pos)
            player.addComponent(Components.MovementComponent, delta)
            player.addComponent(Components.ImageComponent, sprite)
            expect(player.name).to.equal("player")

        except e:Exception
            stdout.printf(e.message)
