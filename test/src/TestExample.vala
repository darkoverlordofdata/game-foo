using Utils;
using Bosco.ECS;

class TestExample : Vunny {

  public TestExample() {
    describe("TestExample");

    it("A) Match 1, 2, 4", () => {

      Matcher m = (Matcher)Matcher.AllOf({1, 2, 4});
      return should.eq(m.toString(), "AllOf(1, 2, 4)");
    });

    it("B) Match 1, 2, 4", () => {

      Matcher m = (Matcher)Matcher.AllOf({1, 2, 4});
      return should.eq(m.toString(), "xAllOf(1, 2, 4)");
    });

   }

   public static int main(string[] args) {
     new TestExample().run();
     return 0;
   }

}
