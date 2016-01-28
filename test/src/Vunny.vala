public delegate bool DelegateTest();

public class Test: Object {
  public Test(string name, DelegateTest func) {
    this.name = name;
    this.func = func;
  }
  public string name;
  public unowned DelegateTest func;
}
public class Vunny : Object {

  protected int pass=0;
  protected int fail=0;
  protected string name = "";
  protected Should should;
  private Test[] tests = {};

	public Vunny () {
    should = new Should();
	}

  public void describe(string name) {
    this.name = name;
  }
  public void start() {

  }

  public void end() {

  }

  public void it(string name, DelegateTest func) {
    tests+= new Test(name, func);
  }

  public void run() {
    pass = 0;
    fail = 0;
    start();
    bool test;

    stdout.printf("\n--------------------------------\n");
    for (var i=0; i<tests.length; i++) {
      (test = tests[i].func()) ? pass++ : fail ++;
      if (!test) {
        stdout.printf("FAILED> %s\n", tests[i].name);
      }
    }
    end();
    stdout.printf("Pass: %d\n", pass);
    stdout.printf("Fail: %d\n", fail);
  }
}

public class Should {
  public bool eq(Value a, Value b) {
    bool test = false;
    Type t = a.type();
    if (a.type_name() == b.type_name()) {
      if (t.is_a(typeof(string))) {
        test =  (a.get_string() == b.get_string());
      }
      else if (t.is_a(typeof(bool))) {
        test =  (a.get_boolean() == b.get_boolean());
      }
      else if (t.is_a(typeof(int))) {
        test =  (a.get_int() == b.get_int());
      }
      else if (t.is_a(typeof(long))) {
        test =  (a.get_long() == b.get_long());
      }
      else if (t.is_a(typeof(char))) {
        test =  (a.get_char() == b.get_char());
      }
      else if (t.is_a(typeof(double))) {
        test =  (a.get_double() == b.get_double());
      }
      else if (t.is_a(typeof(float))) {
        test =  (a.get_float() == b.get_float());
      }
    }
    return test;
  }
  public bool ne(Value a, Value b) {
    bool test = false;
    Type t = a.type();
    if (a.type_name() == b.type_name()) {
      if (t.is_a(typeof(string))) {
        test =  (a.get_string() != b.get_string());
      }
      else if (t.is_a(typeof(bool))) {
        test =  (a.get_boolean() != b.get_boolean());
      }
      else if (t.is_a(typeof(int))) {
        test =  (a.get_int() != b.get_int());
      }
      else if (t.is_a(typeof(long))) {
        test =  (a.get_long() != b.get_long());
      }
      else if (t.is_a(typeof(char))) {
        test =  (a.get_char() != b.get_char());
      }
      else if (t.is_a(typeof(double))) {
        test =  (a.get_double() != b.get_double());
      }
      else if (t.is_a(typeof(float))) {
        test =  (a.get_float() != b.get_float());
      }
    }
    return test;
  }
}
