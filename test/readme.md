# Bunny Vunny
### Unit testing Framework for Vala

      /\ /\
      \/_\/
      ('.')
     (     )



# Usage

### Vala
```Vala
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
  }
  public static int main(string[] args) {
    new TestExample().run();
    return 0;
  }
}
```

### Genie
```genie
[indent=2]
uses
  Utils
  Bosco.ECS
  Gee

class TestExample : Bunny.Vunny
  init()
    describe("TestExample")
    test("Match 1, 2, 3", test_match)
    test("it's a UUID!", test_uuid)

  def test_match()
    var m = (Matcher)Matcher.AllOf({1, 2, 3})
    expect(m.toString()).to.equal("AllOf(1, 2, 3)")

  def test_uuid()
    expect(UUID.randomUUID()).to.match("""\w{6}-\w{4}-\w{4}-\w{4}-\w{12}""")

init
  new TestExample().run()
  return 0

```
