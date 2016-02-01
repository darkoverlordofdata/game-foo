[indent=4]
uses
    Utils
    Bosco.ECS

init
    new TestExample().run()

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




class TestExample : Bunny.Vunny

    components: array of string = {"PositionComponent", "MovementComponent", "ImageComponent"}
    world:World
    player:Entity
    sys:MovementSystem

    /** Initialize tests */
    construct()
        describe("TestExample")
        test("Match 1 2 3", test_match)
        test("Create world", test_world)
        test("Make player entity", test_player)
        test("Add player components", test_component)
        test("Create System", test_system)
        test("Initialize System", test_initialize)
        test("Execute System", test_execute)

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

    def test_component()
        var pos = new PositionComponent()
        pos.x = 10
        pos.y = 20

        try
            player.addComponent(Components.PositionComponent, pos)
            expect(player.hasComponent(Components.PositionComponent)).to.equal(true)

        except e:Exception
            stdout.printf(e.message)



    def test_system()
        sys = new MovementSystem()
        world.add(sys)

    def test_initialize()
        world.initialize()

    def test_execute()
        world.execute()
