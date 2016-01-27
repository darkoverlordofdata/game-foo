using Gee;

namespace Utils {

    public interface ISignal<T> {
      public abstract void dispatch(Object args, ...);
      public abstract void add(T listener);
      public abstract void clear();
      public abstract void remove(T listener);

    }

    public class Signal<T> : ISignal<T> {
      public ArrayList<T> _listeners;
      public bool active;
      private int _alloc;
      private Object _context;

      /**
       *
       * @constructor
       * @param context
       * @param alloc
       */
      public Signal(Object context, int alloc=16) {
        _context = context;
        _alloc = alloc;
        _listeners = new Gee.ArrayList<T>();
        active = false;
      }

      /**
       * Dispatch event
       *
       * @param $0
       * @param $1
       * @param $2
       * @param $3
       * @param $4
       */
      public void dispatch(Object args, ...) {
        if (_listeners.size>0) {
          foreach(T listener in _listeners) {
            listener.dispatch(args);
          }
        }
      }

      /**
       * Add event listener
       * @param listener
       */
      public void add(T listener) {
        _listeners.add(listener);
        active = true;
      }

      /**
       * Remove event listener
       * @param listener
       */
      public void clear() {
        active = false;
      }

      /**
       * Clear and reset to original alloc
       */
      public void remove(T listener) {
        _listeners.remove(listener);
        active = _listeners.size > 0;

      }
    }
}
