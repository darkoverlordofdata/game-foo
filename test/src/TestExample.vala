class TestExample : VUnit {

  public TestExample() {
    // assign a name for this class
    base("TestExample");
    // add test methods
    add_test("test_example", test_example);
   }

   public override void set_up () {
     // setup your test
   }

   public void test_example() {
     // add your expressions
     // assert(expression);
   }

   public override void tear_down () {
     // tear down your test
   }
}
