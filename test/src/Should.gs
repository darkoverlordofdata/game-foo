[indent=4]
namespace Bunny

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
