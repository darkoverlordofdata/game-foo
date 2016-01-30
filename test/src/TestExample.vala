using Utils;
using Bosco.ECS;
using Gee;

class TestExample : Bunny.Vunny {

  public TestExample() {

    describe("TestExample");

    test("Match 1, 2, 3", () => {

      var m = (Matcher)Matcher.AllOf({1, 2, 3});
      expect(m.toString()).to.equal("AllOf(1, 2, 3)");
    });

    test("it's a UUID!", () => {

      expect(UUID.randomUUID()).to.match("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""");
    });

    test("Hello World", () => {

      var world = new World({"PositionComponent", "MovementComponent", "ImageComponent"});

    });

  }

  public static int main(string[] args) {
    new TestExample().run();
    return 0;
  }

}
