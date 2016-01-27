namespace Bosco.ECS {
  public delegate void OnComponentReplaced(Entity e, int index, IComponent component, IComponent replacement);

  public class ComponentReplaced {
    internal class Listener {
      public unowned OnComponentReplaced event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnComponentReplaced event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnComponentReplaced event) {
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


    public void dispatch(Entity e, int index, IComponent component, IComponent replacement) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(e, index, component, replacement);
      }
    }
  }
}
