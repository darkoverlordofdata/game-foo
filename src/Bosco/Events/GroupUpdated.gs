[indent=4]

namespace Bosco.ECS

    delegate OnGroupUpdated(g : Group, e : Entity, i : int, c : IComponent, u : IComponent)

    class GroupUpdated

        class Listener
            prop event : unowned OnGroupUpdated
            construct(event : OnGroupUpdated)
                _event = event

        _listeners : list of Listener = new list of Listener

        def add(event : OnGroupUpdated)
            _listeners.add(new Listener(event))

        def remove(event : OnGroupUpdated)
            for var listener in _listeners
                if listener.event == event
                    _listeners.remove(listener)
                    return

        def clear()
            _listeners = new list of Listener

        def dispatch(g : Group, e : Entity, i : int, c : IComponent, u : IComponent)
            for var listener in _listeners
                listener.event(g, e, i, c, u)
