[indent=4]

namespace Bosco.ECS

    delegate OnComponentReplaced(e : Entity, index : int, component : IComponent, replacement : IComponent)

    class ComponentReplaced

        _listeners : list of Listener = new list of Listener

        class Listener
            prop event : unowned OnComponentReplaced
            construct(event : OnComponentReplaced)
                _event = event

        def add(event : OnComponentReplaced)
            _listeners.add(new Listener(event))

        def remove(event : OnComponentReplaced)
            for var listener in _listeners
                if listener.event == event
                    _listeners.remove(listener)
                    return

        def clear()
            _listeners = new list of Listener

        def dispatch(e : Entity, index : int, component : IComponent, replacement : IComponent)
            for var listener in _listeners
                listener.event(e, index, component, replacement)
