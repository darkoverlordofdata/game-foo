namespace Bosco.ECS {

  public delegate void OnGroupsChanged(World w, Group g);

  public class GroupsChanged {
    internal class Listener {
      public unowned OnGroupsChanged event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnGroupsChanged event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnGroupsChanged event) {
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

    public void dispatch(World w, Group g) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(w, g);
      }
    }
  }
}
