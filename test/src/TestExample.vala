using Utils;
using Bosco.ECS;
using Gee;

/*public enum Hashable {
  UNKNOWN = 0;

  public static HashTable<unowned string, Hashable> to_hash_table() {
		HashTable<unowned string, Hashable> table = new HashTable<unowned string, Hashable> (str_hash, str_equal);
        EnumClass enumc = (EnumClass) typeof (Hashable).class_ref();
		foreach (unowned EnumValue val in enumc.values) {
			table.insert (val.value_nick, (Hashable) val.@value);
		}
		return table;
	}
}

public enum Components {
  PositionComponent,
  MovementComponent,
  ImageComponent
}*/
class TestExample : Bunny.Vunny {


  public TestExample() {

    describe("TestExample");

    it("Match 1, 2, 3", () => {

      Matcher m = (Matcher)Matcher.AllOf({1, 2, 3});
      return should.eq("AllOf(1, 2, 3)", m.toString());

    });

    it("it's a UUID!", () => {

      return should.re("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""", UUID.randomUUID());

    });


    /*it("Hello World!", () => {

      var world = new World((EnumClass) typeof(Components).class_ref(), 3);
      return should.eq(3, world.componentsCount);

    });*/

   }

   public static int main(string[] args) {
     new TestExample().run();
     return 0;
   }

}
