namespace Bosco.ECS {

  public delegate void OnWorldChanged(World w, Entity e);

  public class WorldChanged {
    internal class Listener {
      public unowned OnWorldChanged event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnWorldChanged event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnWorldChanged event) {
      for (int i=0; i<listeners.length; i++) {
        if (listeners.get(i).event == event) {
          listeners.remove(listeners.get(i));
          return;
        }
      }
    }

    public void clear() {
      listeners.remove_range(0, listeners.length);
    }

    public void dispatch(World w, Entity e) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(w, e);
      }
    }
  }
}
