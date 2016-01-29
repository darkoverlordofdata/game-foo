[indent=4]
uses Utils
uses Bosco.ECS

init
    new TestExample().run()

class TestExample : Bunny.Vunny

    init
        describe("TestExample")
        add("Match 1 2 3", test_match)
        add("It's a UUID!", test_uuid)

    def test_match()
        m:Matcher = (Matcher)Matcher.AllOf({1, 2, 3})
        expect(m.toString()).to.equal("AllOf(1, 2, 3)")

    def test_uuid()
        expect(UUID.randomUUID()).to.match("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""")

    //def test_world()
        w:World = new World()
