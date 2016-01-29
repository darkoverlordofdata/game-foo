/**
 *
 *     ___
 *    | _ )_  _ _ _  _ _ _  _
 *    | _ \ || | ' \| ' \ || |
 *    |___/\_,_|_||_|_||_\_, |
 *     __   __           |__/
 *     \ \ / /  _ _ _  _ _ _  _
 *      \ V / || | ' \| ' \ || |
 *       \_/ \_,_|_||_|_||_\_, |
 *                         |__/
 *
 *
 * Simple Testing Framework for Vala/Genie
 *  by Dark Overlord of Data
 *
 *  Copyright 2016 Bruce Davidson
 */
namespace Bunny {
  /** @type Signature of Test function */
  public delegate bool DelegateTest();
  public delegate void DelegateExpect();

  /** @class Test - name & func of each test */
  public class Test: Object {
    public Test(string name, DelegateTest func) {
      this.name = name;
      this.func = func;
    }
    public string name;
    public unowned DelegateTest func;
  }

  /**
   *  Vunny - Vala Unit Testing
   * inspired by Chai
   */
  public class Vunny : Object {

    public static bool result;
    protected int pass=0;
    protected int fail=0;
    protected string name = "";
    protected Should should;
    private Test[] tests = {};

  	public Vunny () {
      should = new Should();
  	}

    /** describe these tests */
    public void describe(string name) {
      this.name = name;
    }

    /** override for setup code */
    public void start() {}

    /** override for teardown code */
    public void end() {}

    /** add a test */
    public void it(string name, DelegateTest func) {
      tests+= new Test(name, func);
    }

    public Expectation expect(Value actual) {
      return new Expectation(actual);
    }

    public void test(string name, DelegateExpect func) {
      tests+= new Test(name, () => {
        func();
        return Vunny.result;
      });
    }
    /** add a test */
    public void add(string name, DelegateExpect func) {
      tests+= new Test(name, () => {
        func();
        return Vunny.result;
      });
    }

    /** run all the tests */
    public void run() {
      pass = 0;
      fail = 0;

      stdout.printf("---------------------------------\n");
      stdout.printf("| bunny vunny test suite v0.0.1 |\n");
      stdout.printf("---------------------------------\n");
      stdout.printf("\n\t%s\n---------------------------------\n", name);

      start();
      foreach (var test in tests) {
        if (test.func()) {
          pass++;
          stdout.printf("PASS <=> %s\n", test.name);
        } else {
          fail++;
          stdout.printf("FAIL <=> %s\n", test.name);
        }
      }
      end();

      stdout.printf("---------------------------------\n");
      stdout.printf("  <====> Pass: %d\n", pass);
      stdout.printf("  <====> Fail: %d\n\n", fail);
    }
  }

  public class Expectation {
    public Value actual;
    public To to;

    public Expectation(Value actual) {
      this.actual = actual;
      to = new To(this);
    }
  }

  /**
   * To - an Expectation wrapper for Should
   */
  public class To {
    public Expectation parent;
    public Should should;
    private bool invert = false;
    //public bool test = false;

    public To(Expectation parent) {
      this.parent = parent;
      should = new Should();
    }

    public To not() {
      invert = true;
      return this;
    }

    public void equal(Value expected) {
      var test = should.eq(parent.actual.get_string(), expected.get_string());
      Vunny.result = (invert) ? !test : test;
    }

    public void gt(Value expected) {
      var test = should.gt(parent.actual.get_string(), expected.get_string());
      Vunny.result = (invert) ? !test : test;
    }

    public void ge(Value expected) {
      var test = should.ge(parent.actual.get_string(), expected.get_string());
      Vunny.result = (invert) ? !test : test;
    }

    public void lt(Value expected) {
      var test = should.lt(parent.actual.get_string(), expected.get_string());
      Vunny.result = (invert) ? !test : test;
    }

    public void le(Value expected) {
      var test = should.le(parent.actual.get_string(), expected.get_string());
      Vunny.result = (invert) ? !test : test;
    }

    public void match(Value expected) {
      var test = should.match(parent.actual.get_string(), expected.get_string());
      Vunny.result = (invert) ? !test : test;
    }
  }
  /**
   * Should - Test Comparison Wrapper
   *
   */
  public class Should {

    /**
     *  re - Regular Expression
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool match(string actual, string expected) {
      bool result = false;

      try {
        Regex r = new Regex(expected);
        result = r.match(actual);
      } catch (RegexError e) {
    		stdout.printf ("Error %s\n", e.message);
    	}
      return result;
    }

    /**
     *  eq - check equality
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool eq(Value actual, Value expected) {
      bool test = false;
      Type t = expected.type();
      if (expected.type_name() == actual.type_name()) {
        if (t.is_a(typeof(string))) {
          test =  (expected.get_string() == actual.get_string());
        }
        else if (t.is_a(typeof(bool))) {
          test =  (expected.get_boolean() == actual.get_boolean());
        }
        else if (t.is_a(typeof(int))) {
          test =  (expected.get_int() == actual.get_int());
        }
        else if (t.is_a(typeof(long))) {
          test =  (expected.get_long() == actual.get_long());
        }
        else if (t.is_a(typeof(char))) {
          test =  (expected.get_char() == actual.get_char());
        }
        else if (t.is_a(typeof(double))) {
          test =  (expected.get_double() == actual.get_double());
        }
        else if (t.is_a(typeof(float))) {
          test =  (expected.get_float() == actual.get_float());
        }
      }
      return test;
    }

    /**
     *  ne - check inequality
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool ne(Value actual, Value expected) {
      bool test = false;
      Type t = expected.type();
      if (expected.type_name() == actual.type_name()) {
        if (t.is_a(typeof(string))) {
          test =  (expected.get_string() != actual.get_string());
        }
        else if (t.is_a(typeof(bool))) {
          test =  (expected.get_boolean() != actual.get_boolean());
        }
        else if (t.is_a(typeof(int))) {
          test =  (expected.get_int() != actual.get_int());
        }
        else if (t.is_a(typeof(long))) {
          test =  (expected.get_long() != actual.get_long());
        }
        else if (t.is_a(typeof(char))) {
          test =  (expected.get_char() != actual.get_char());
        }
        else if (t.is_a(typeof(double))) {
          test =  (expected.get_double() != actual.get_double());
        }
        else if (t.is_a(typeof(float))) {
          test =  (expected.get_float() != actual.get_float());
        }
      }
      return test;
    }
    /**
     *  le - check less than or equal
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool le(Value actual, Value expected) {
      bool test = false;
      Type t = expected.type();
      if (expected.type_name() == actual.type_name()) {
        if (t.is_a(typeof(string))) {
          test =  (expected.get_string() <= actual.get_string());
        }
        else if (t.is_a(typeof(int))) {
          test =  (expected.get_int() <= actual.get_int());
        }
        else if (t.is_a(typeof(long))) {
          test =  (expected.get_long() <= actual.get_long());
        }
        else if (t.is_a(typeof(char))) {
          test =  (expected.get_char() <= actual.get_char());
        }
        else if (t.is_a(typeof(double))) {
          test =  (expected.get_double() <= actual.get_double());
        }
        else if (t.is_a(typeof(float))) {
          test =  (expected.get_float() <= actual.get_float());
        }
      }
      return test;
    }
    /**
     *  lt - check less than
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool lt(Value actual, Value expected) {
      bool test = false;
      Type t = expected.type();
      if (expected.type_name() == actual.type_name()) {
        if (t.is_a(typeof(string))) {
          test =  (expected.get_string() < actual.get_string());
        }
        else if (t.is_a(typeof(int))) {
          test =  (expected.get_int() < actual.get_int());
        }
        else if (t.is_a(typeof(long))) {
          test =  (expected.get_long() < actual.get_long());
        }
        else if (t.is_a(typeof(char))) {
          test =  (expected.get_char() < actual.get_char());
        }
        else if (t.is_a(typeof(double))) {
          test =  (expected.get_double() < actual.get_double());
        }
        else if (t.is_a(typeof(float))) {
          test =  (expected.get_float() < actual.get_float());
        }
      }
      return test;
    }
    /**
     *  gt - check greater than
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool gt(Value actual, Value expected) {
      bool test = false;
      Type t = expected.type();
      if (expected.type_name() == actual.type_name()) {
        if (t.is_a(typeof(string))) {
          test =  (expected.get_string() > actual.get_string());
        }
        else if (t.is_a(typeof(int))) {
          test =  (expected.get_int() > actual.get_int());
        }
        else if (t.is_a(typeof(long))) {
          test =  (expected.get_long() > actual.get_long());
        }
        else if (t.is_a(typeof(char))) {
          test =  (expected.get_char() > actual.get_char());
        }
        else if (t.is_a(typeof(double))) {
          test =  (expected.get_double() > actual.get_double());
        }
        else if (t.is_a(typeof(float))) {
          test =  (expected.get_float() > actual.get_float());
        }
      }
      return test;
    }
    /**
     *  ge - check greater than or equal
     *
     * @param expected pattern
     * @param actual value
     * @returns true or false
     */
    public bool ge(Value actual, Value expected) {
      bool test = false;
      Type t = expected.type();
      if (expected.type_name() == actual.type_name()) {
        if (t.is_a(typeof(string))) {
          test =  (expected.get_string() >= actual.get_string());
        }
        else if (t.is_a(typeof(int))) {
          test =  (expected.get_int() >= actual.get_int());
        }
        else if (t.is_a(typeof(long))) {
          test =  (expected.get_long() >= actual.get_long());
        }
        else if (t.is_a(typeof(char))) {
          test =  (expected.get_char() >= actual.get_char());
        }
        else if (t.is_a(typeof(double))) {
          test =  (expected.get_double() >= actual.get_double());
        }
        else if (t.is_a(typeof(float))) {
          test =  (expected.get_float() >= actual.get_float());
        }
      }
      return test;
    }
  }
}
