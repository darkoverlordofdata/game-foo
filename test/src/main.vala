public static int main(string[] args) {
  Test.init (ref args);
  // add any of your test cases here
  TestSuite.get_root().add_suite(new TestExample().get_suite());
  return Test.run ();
}
/*
using Utils;
class TestUUID : Object {
  public static int main(string[] args) {

      stdout.printf("--------------------------------\n\n\n");
      stdout.printf("UUID: %s\n", UUID.randomUUID());
      stdout.printf("\n\n--------------------------------\n");

      var m = new Bosco.ECS.Matcher();
      var x = new Bosco.ECS.Group(m);
      stdout.printf("Name: %s\n", x.get_type().name());
      stdout.printf("\n\n--------------------------------\n");

      bool isGroup = (x is Bosco.ECS.Group);
      bool isDark = (x is DarkMatter);
      bool isMatcher = (x is Bosco.ECS.Matcher);

      stdout.printf("isGroup = %s\n", isGroup?"true":"false");
      stdout.printf("isDark = %s\n", isDark?"true":"false");
      stdout.printf("isMatcher = %s\n", isMatcher?"true":"false");
      stdout.printf("\n\n--------------------------------\n");

      return 0;
  }

}*/
