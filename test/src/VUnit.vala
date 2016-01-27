public class VUnit : Object {

	private GLib.TestSuite suite;
	private Adaptor[] adaptors = new Adaptor[0];

	public delegate void TestMethod ();

	public VUnit (string name) {
		this.suite = new GLib.TestSuite (name);
	}

	public void add_test (string name, owned TestMethod test) {
		var adaptor = new Adaptor (name, (owned)test, this);
		this.adaptors += adaptor;

		this.suite.add (new VUnit (adaptor.name,
		                                   adaptor.set_up,
		                                   adaptor.run,
		                                   adaptor.tear_down ));
	}

	public virtual void set_up () {
	}

	public virtual void tear_down () {
	}

	public GLib.TestSuite get_suite () {
		return this.suite;
	}

	private class Adaptor {

		public string name { get; private set; }
		private TestMethod test;
		private VUnit test_case;

		public Adaptor (string name,
		                owned TestMethod test,
		                VUnit test_case) {
			this.name = name;
			this.test = (owned)test;
			this.test_case = test_case;
		}

		public void set_up (void* fixture) {
			this.test_case.set_up ();
		}

		public void run (void* fixture) {
			this.test ();
		}

		public void tear_down (void* fixture) {
			this.test_case.tear_down ();
		}
	}
}
