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
 *        /\ /\
 *        \/_\/
 *        ('.')
 *       (     )
 *
 *
 * Simple Testing Framework for Vala/Genie
 *    by Dark Overlord of Data
 *
 *
 *
 *
 *    Copyright 2016 Bruce Davidson
 */
[indent=4]
const __bunny__:string = """
  bunny vunny test suite v0.0.1

          /\ /\
          \/_\/
          ('.')
         (     )

    It's no ordinary rabbit

"""

namespace Bunny

    /**
     *    Vunny - Vala Unit Testing
     * inspired by Chai
     */
    class Vunny : Object
        passed:int=0
        failed:int=0
        name:string = ""
        should:Should
        tests:list of Test = new list of Test

        construct()
            should = new Should()

        def describe(name:string)
            this.name = name

        def expect(actual:Value):Expectation
            return new Expectation(actual)

        def test(name:string, proc:DelegateTest)
            tests.add(new Test(name, proc))

        def it(name:string, func:DelegateFunc)
            tests.add(new Test.withFunc(name, func))

        def run()

            passed = 0
            failed = 0

            print __bunny__
            print "\t%s\n---------------------------------", name
            for test in tests
                if test.hasReturn
                  if test.func()
                      passed++
                      print "PASS <=> %s", test.name
                  else
                      failed++
                      print "FAIL <=> %s", test.name
                else
                  test.proc()
                  if Expectation.result
                      passed++
                      print "PASS <=> %s", test.name
                  else
                      failed++
                      print "FAIL <=> %s", test.name

            print "---------------------------------"
            print "    <====> Pass: %d", passed
            print "    <====> Fail: %d\n\n\033[0m", failed

    class Expectation
        actual:Value
        to:To
        result:static bool
        construct(actual:Value)
            this.actual = actual
            to = new To(this)
