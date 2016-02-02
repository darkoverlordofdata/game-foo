[indent=4]

namespace Bosco.ECS

    delegate OnEntityReleased(e : Entity)
    
    class EntityReleased

        class Listener
            prop event : unowned OnEntityReleased
            construct(event : OnEntityReleased)
                _event = event

        _listeners : list of Listener = new list of Listener

        def add(event : OnEntityReleased)
            _listeners.add(new Listener(event))

        def remove(event : OnEntityReleased)
            for var listener in _listeners
                if listener.event == event
                    _listeners.remove(listener)
                    return

        def clear()
            _listeners = new list of Listener

        def dispatch(e : Entity)
            for var listener in _listeners
                listener.event(e)
