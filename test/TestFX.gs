[indent=4]
uses
    Utils
    Bosco.ECS

init
    new TestExample().run()

enum Components
    PositionComponent
    MovementComponent
    ResourceComponent

[Compact]
class PositionComponent : DarkMatter implements IComponent
    x:double
    y:double
    z:double

[Compact]
class MovementComponent : DarkMatter implements  IComponent
    x:double
    y:double
    z:double

[Compact]
class ResourceComponent : DarkMatter implements IComponent
    path:string


class TestSystem : DarkMatter implements ISystem, ISetWorld, IInitializeSystem, IExecuteSystem
    group:Group

    def setWorld(world:World)
        group = world.getGroup(Matcher.AllOf({Components.ResourceComponent}))

    def execute()
        pass

    def initialize()
        try
            var e1 = group.getSingleEntity()
            if e1 != null
                print "entity name %s", e1.name

            for var e in group.getEntities()
                print "entity name %s", e.name
        except e:Error
            pass

class TestExample : Bunny.Vunny

    components: array of string = {
        "PositionComponent",
        "MovementComponent",
        "ResourceComponent"
    }
    world:World
    player:Entity
    sys:TestSystem

    /** Initialize tests */
    construct()
        describe("TestExample")
        test("Generic Array", test_array)
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


    def test_array()
        fred:GenericArray of GenericArray of Group = new GenericArray of GenericArray of Group
        expect(fred.length).to.equal(0)

    /** Test the Match object */
    def test_match()
        m:Matcher = (Matcher)Matcher.AllOf({1, 2, 3})
        print "|%s|", m.toString()
        expect(m.toString()).to.equal("AllOf(Position,Movement,Resource)")

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

        var mov = new MovementComponent()
        mov.x = 0
        mov.y = 0

        var res = new ResourceComponent()
        res.path = "resources/background.png"

        try
            player.addComponent(Components.PositionComponent, pos)
            player.addComponent(Components.MovementComponent, mov)
            player.addComponent(Components.ResourceComponent, res)

        except e:Exception
            print e.message

        finally
            expect(player.hasComponent(Components.MovementComponent)).to.equal(true)




    def test_system()
        sys = new TestSystem()
        world.add(sys)

    def test_initialize()
        world.initialize()

    def test_execute()
        world.execute()
