namespace Bosco.ECS {

  public delegate void OnGroupChanged(Group g, Entity e, int i, IComponent c);

  public class GroupChanged {
    internal class Listener {
      public unowned OnGroupChanged event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnGroupChanged event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnGroupChanged event) {
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

    public void dispatch(Group g, Entity e, int index, IComponent c) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(g, e, index, c);
      }
    }
  }
}
