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
 *        (\_/)
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

          (\_/)
          ('.')
         (     )

    It's no ordinary rabbit

"""

namespace Bunny

    /** @type Signature of Test function */
    delegate DelegateTest()
    delegate DelegateFunc():bool


    /** @class Test - name & func of each test */
    class Test: Object
        construct(name:string, func:DelegateTest)
            self.name = name
            self.func = func
            self.result = false
        name: string
        result: bool
        func: unowned DelegateTest

    /**
     *    Vunny - Vala Unit Testing
     * inspired by Chai
     */
    class abstract Vunny : Object
        passed:int=0
        failed:int=0
        name:string = ""
        should:Should
        tests:list of Test = new list of Test

        construct()
            should = new Should()

        def describe(name:string)
            self.name = name

        def expect(actual:Value):Expectation
            return new Expectation(actual)

        def test(name:string, func:DelegateTest)
            tests.add(new Test(name, func))

        /*def it(name:string, func:DelegateFunc) {
            tests.add(new Test(name, func))*/

        def run()

            passed = 0
            failed = 0

            stdout.puts(__bunny__)

            stdout.printf("\n\t%s\n---------------------------------\n", name)
            for test in tests
                test.func()
                if Expectation.result
                    passed++
                    stdout.printf("PASS <=> %s\n", test.name)
                else
                    failed++
                    stdout.printf("FAIL <=> %s\n", test.name)
            stdout.printf("---------------------------------\n")
            stdout.printf("    <====> Pass: %d\n", passed)
            stdout.printf("    <====> Fail: %d\n\n\033[0m", failed)

    class Expectation
        actual:Value
        to:To
        result:static bool
        construct(actual:Value)
            self.actual = actual
            to = new To(self)

    class To
        parent: Expectation
        should: Should
        invert: bool = false
        construct(parent:Expectation)
            self.parent = parent
            should = new Should()

        def @not():To
            invert = true
            return self

        def equal(expected:Value)
            var test = should.eq(parent.actual, expected)
            Expectation.result = invert ? !test : test

        def gt(expected:Value)
            var test = should.gt(parent.actual.get_string(), expected.get_string())
            Expectation.result = invert ? !test : test

        def ge(expected:Value)
            var test = should.ge(parent.actual, expected)
            Expectation.result = invert ? !test : test

        def lt(expected:Value)
            var test = should.lt(parent.actual, expected)
            Expectation.result = invert ? !test : test

        def le(expected:Value)
            var test = should.le(parent.actual, expected)
            Expectation.result = invert ? !test : test

        def match(expected:Value)
            var test = should.match(parent.actual.get_string(), expected.get_string())
            Expectation.result = invert ? !test : test

    class Should
        def match(actual:string, expected:string):bool
            var result = false
            try
                var r = new Regex(expected)
                result = r.match(actual)
            except e: RegexError
                stdout.printf("Error %s\n", e.message)

            return result

        /**
         *    eq - check equality
         *
         * @param expected pattern
         * @param actual value
         * @returns true or false
         */
        def eq(actual:Value, expected:Value):bool
            var test = false
            var t = expected.type()

            if expected.type_name() == actual.type_name()
                if t.is_a(typeof(string))
                    test = expected.get_string() == actual.get_string()

                else if t.is_a(typeof(bool))
                    test = expected.get_boolean() == actual.get_boolean()

                else if t.is_a(typeof(int))
                    test = expected.get_int() == actual.get_int()

                else if t.is_a(typeof(long))
                    test = expected.get_long() == actual.get_long()

                else if t.is_a(typeof(char))
                    test = expected.get_char() == actual.get_char()

                else if t.is_a(typeof(double))
                    test = expected.get_double() == actual.get_double()

                else if t.is_a(typeof(float))
                    test = expected.get_float() == actual.get_float()

            return test

        /**
         *    ne - check inequality
         *
         * @param expected pattern
         * @param actual value
         * @returns true or false
         */
        def ne(actual:Value, expected:Value):bool
            var test = false
            var t = expected.type()
            if expected.type_name() == actual.type_name()
                if t.is_a(typeof(string))
                    test = expected.get_string() != actual.get_string()

                else if t.is_a(typeof(bool))
                    test = expected.get_boolean() != actual.get_boolean()

                else if t.is_a(typeof(int))
                    test = expected.get_int() != actual.get_int()

                else if t.is_a(typeof(long))
                    test = expected.get_long() != actual.get_long()

                else if t.is_a(typeof(char))
                    test = expected.get_char() != actual.get_char()

                else if t.is_a(typeof(double))
                    test = expected.get_double() != actual.get_double()

                else if t.is_a(typeof(float))
                    test = expected.get_float() != actual.get_float()


            return test

        /**
         *    le - check less than or equal
         *
         * @param expected pattern
         * @param actual value
         * @returns true or false
         */
        def le(actual:Value, expected:Value):bool
            var test = false
            var t = expected.type()
            if expected.type_name() == actual.type_name()
                if t.is_a(typeof(string))
                    test = expected.get_string() <= actual.get_string()

                else if t.is_a(typeof(int))
                    test = expected.get_int() <= actual.get_int()

                else if t.is_a(typeof(long))
                    test = expected.get_long() <= actual.get_long()

                else if t.is_a(typeof(char))
                    test = expected.get_char() <= actual.get_char()

                else if t.is_a(typeof(double))
                    test = expected.get_double() <= actual.get_double()

                else if t.is_a(typeof(float))
                    test = expected.get_float() <= actual.get_float()


            return test

        /**
         *    lt - check less than
         *
         * @param expected pattern
         * @param actual value
         * @returns true or false
         */
        def lt(actual:Value, expected:Value):bool
            var test = false
            var t = expected.type()
            if expected.type_name() == actual.type_name()
                if t.is_a(typeof(string))
                    test = expected.get_string() < actual.get_string()

                else if t.is_a(typeof(int))
                    test = expected.get_int() < actual.get_int()

                else if t.is_a(typeof(long))
                    test = expected.get_long() < actual.get_long()

                else if t.is_a(typeof(char))
                    test = expected.get_char() < actual.get_char()

                else if t.is_a(typeof(double))
                    test = expected.get_double() < actual.get_double()

                else if t.is_a(typeof(float))
                    test = expected.get_float() < actual.get_float()


            return test

        /**
         *    gt - check greater than
         *
         * @param expected pattern
         * @param actual value
         * @returns true or false
         */
        def gt(actual:Value, expected:Value):bool
            var test = false
            var t = expected.type()
            if expected.type_name() == actual.type_name()
                if t.is_a(typeof(string))
                    test = expected.get_string() > actual.get_string()

                else if t.is_a(typeof(int))
                    test = expected.get_int() > actual.get_int()

                else if t.is_a(typeof(long))
                    test = expected.get_long() > actual.get_long()

                else if t.is_a(typeof(char))
                    test = expected.get_char() > actual.get_char()

                else if t.is_a(typeof(double))
                    test = expected.get_double() > actual.get_double()

                else if t.is_a(typeof(float))
                    test = expected.get_float() > actual.get_float()


            return test

        /**
         *    ge - check greater than or equal
         *
         * @param expected pattern
         * @param actual value
         * @returns true or false
         */
        def ge(actual:Value, expected:Value):bool
            var test = false
            var t = expected.type()
            if expected.type_name() == actual.type_name()
                if t.is_a(typeof(string))
                    test = expected.get_string() >= actual.get_string()

                else if t.is_a(typeof(int))
                    test = expected.get_int() >= actual.get_int()

                else if t.is_a(typeof(long))
                    test = expected.get_long() >= actual.get_long()

                else if t.is_a(typeof(char))
                    test = expected.get_char() >= actual.get_char()

                else if t.is_a(typeof(double))
                    test = expected.get_double() >= actual.get_double()

                else if t.is_a(typeof(float))
                    test = expected.get_float() >= actual.get_float()


            return test
