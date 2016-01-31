[indent=4]
namespace Bunny

    /** @type Signature of Test function */
    delegate DelegateTest()
    delegate DelegateFunc():bool


    /** @class Test - name & func of each test */
    class Test: Object
        name: string
        result: bool
        hasReturn: bool
        proc: unowned DelegateTest
        func: unowned DelegateFunc
        construct(name:string, proc:DelegateTest)
            this.name = name
            this.proc = proc
            this.result = false
            this.hasReturn = false
        construct withFunc(name:string, func:DelegateFunc)
            this.name = name
            this.func = func
            this.result = false
            this.hasReturn = true
