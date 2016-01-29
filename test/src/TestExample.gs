[indent=4]
uses Utils
uses Bosco.ECS

init
    new TestExample().run()

class TestExample : Bunny.Vunny


    init
        describe("TestExample")
        test_case("Match 1 2 3", test1)
        test_case("It's a UUID!", test2)

    def test1():bool
        m:Matcher = (Matcher)Matcher.AllOf({1, 2, 3})
        return should.eq("AllOf(1, 2, 3)", m.toString())

    def test2():bool
        return should.re("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""", UUID.randomUUID())
