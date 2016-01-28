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
 * Simple Testing Framework for Vala
 *  by Dark Overlord of Data
 *
 *  Copyright 2016 Bruce Davidson
 */
namespace Bunny {
  /** @type Signature of Test function */
  public delegate bool DelegateTest();

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
   */
  public class Vunny : Object {

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

    /** run all the tests */
    public void run() {
      pass = 0;
      fail = 0;
      start();
      bool test;

      stdout.printf("---------------------------------\n");
      stdout.printf("| bunny vunny test suite v0.0.1 |\n");
      stdout.printf("---------------------------------\n");
      stdout.printf("\n\t%s\n---------------------------------\n", name);
      for (var i=0; i<tests.length; i++) {
        (test = tests[i].func()) ? pass++ : fail ++;
        if (test) {
          stdout.printf("PASS  <> %s\n", tests[i].name);
        } else {
          stdout.printf("FAIL  <> %s\n", tests[i].name);
        }
      }
      end();
      stdout.printf("---------------------------------\n");
      stdout.printf("  <====> Pass: %d\n", pass);
      stdout.printf("  <====> Fail: %d\n\n", fail);
    }
  }

  /**
   * Should - Test Wrapper
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
    public bool re(string expected, string actual) {
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
    public bool eq(Value expected, Value actual) {
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
    public bool ne(Value expected, Value actual) {
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
  }
}
