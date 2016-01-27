namespace Bosco.ECS {

  public delegate void OnGroupUpdated(Group g, Entity e, int i, IComponent c, IComponent u);

  public class GroupUpdated {
    internal class Listener {
      public unowned OnGroupUpdated event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnGroupUpdated event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnGroupUpdated event) {
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

    public void dispatch(Group g, Entity e, int index, IComponent c, IComponent u) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(g, e, index, c, u);
      }
    }
  }
}
