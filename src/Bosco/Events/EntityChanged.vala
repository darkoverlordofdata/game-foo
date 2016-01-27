namespace Bosco.ECS {

  public delegate void OnEntityChanged(Entity e, int index, IComponent component);

  public class EntityChanged {
    internal class Listener {
      public unowned OnEntityChanged event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnEntityChanged event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnEntityChanged event) {
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

    public void dispatch(Entity e, int index, IComponent component) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(e, index, component);
      }
    }
  }
}
