using Utils;
using Bosco.ECS;

class TestExample : Bunny.Vunny {

  public TestExample() {

    describe("TestExample");

    it("Match 1, 2, 4", () => {

      Matcher m = (Matcher)Matcher.AllOf({1, 2, 4});
      return should.eq("AllOf(1, 2, 4)", m.toString());

    });

    it("is a UUID", () => {

      return should.re("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""", UUID.randomUUID());

    });

   }

   public static int main(string[] args) {
     new TestExample().run();
     return 0;
   }

}
