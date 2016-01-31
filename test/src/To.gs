[indent=4]
namespace Bunny

    class To
        parent: Expectation
        should: Should
        invert: bool = false
        construct(parent:Expectation)
            this.parent = parent
            should = new Should()

        // def @not():To
        prop @not: To
            get
                invert = true
                return this

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
