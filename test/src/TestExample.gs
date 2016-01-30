[indent=4]
uses Utils
uses Bosco.ECS

init
    new TestExample().run()


class TestExample : Bunny.Vunny

    world:World

    /** Initialize tests */
    init
        describe("TestExample")
        test("Match 1 2 3", test_match)
        test("It's a UUID!", test_uuid)
        test("Hello World", test_world)

        world = new World({"PositionComponent", "MovementComponent", "ImageComponent"})

    /** Test the Match object */
    def test_match()
        m:Matcher = (Matcher)Matcher.AllOf({1, 2, 3})
        expect(m.toString()).to.equal("AllOf(1, 2, 3)")

    /** Test UUID generation */
    def test_uuid()
        expect(UUID.randomUUID()).to.match("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""")

    /** Test World creation */
    def test_world()
        expect(world.componentsCount).to.equal(3)

    /** Teardown */
    final
        world = null
