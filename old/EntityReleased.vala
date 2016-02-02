namespace Bosco.ECS {

  public delegate void OnEntityReleased(Entity e);
  public class EntityReleased {
    internal class Listener {
      public unowned OnEntityReleased event;
    }

    internal GenericArray<Listener> listeners = new GenericArray<Listener>();

    public void add(OnEntityReleased event) {
      Listener wrapper = new Listener();
      wrapper.event = event;
      listeners.add(wrapper);
    }

    public void remove(OnEntityReleased event) {
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


    public void dispatch(Entity e) {
      for (int i=0; i<listeners.length; i++) {
        listeners.get(i).event(e);
      }
    }
  }
}
