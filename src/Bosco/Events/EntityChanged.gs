[indent=4]

namespace Bosco.ECS

    delegate OnEntityChanged(e : Entity, index : int, component : IComponent)

    class EntityChanged

        class Listener
            prop event : unowned OnEntityChanged
            construct(event : OnEntityChanged)
                _event = event

        _listeners : list of Listener = new list of Listener

        def add(event : OnEntityChanged)
            _listeners.add(new Listener(event))

        def remove(event : OnEntityChanged)
            for var listener in _listeners
                if listener.event == event
                    _listeners.remove(listener)
                    return

        def clear()
            _listeners = new list of Listener

        def dispatch(e : Entity, index : int, component : IComponent)
            for var listener in _listeners
                listener.event(e, index, component)
