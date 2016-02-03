[indent=4]

namespace Bosco.ECS

    class World : DarkMatter

        /**
         * The total number of components in this pool
         * @type number
         * @name entitas.Pool#totalComponents */
        prop componentsCount : int
            get
                return _totalComponents

        /**
         * Count of active entities
         * @type number
         * @name entitas.Pool#count */
        prop count : int
            get
                return _entities.size

        /**
         * Count of entities waiting to be recycled
         * @type number
         * @name entitas.Pool#reusableEntitiesCount */
        prop reusableEntitiesCount : int
            get
                return (int)_reusableEntities.length

        /**
         * Count of entities that sill have references
         * @type number
         * @name entitas.Pool#retainedEntitiesCount */
        prop retainedEntitiesCount : int
            get
                return _retainedEntities.size

        /**
         * Subscribe to Entity Created Event
         * @type entitas.utils.ISignal */
        prop readonly onEntityCreated : WorldChanged

        /**
         * Subscribe to Entity Will Be Destroyed Event
         * @type entitas.utils.ISignal */
        prop readonly onEntityWillBeDestroyed : WorldChanged

        /**
         * Subscribe to Entity Destroyed Event
         * @type entitas.utils.ISignal */
        prop readonly onEntityDestroyed : WorldChanged

        /**
         * Subscribe to Group Created Event
         * @type entitas.utils.ISignal */
        prop readonly onGroupCreated : GroupsChanged

        /**
         * Entity name for debugging
         * @type string */
        prop readonly name : string

        /**
         * An enum of valid component types
         * @type Object<string,number> */
        componentsEnum : static array of string

        /**
         * Count of components
         * @`type` number */
        totalComponents : static int = 0

        /**
         * Global reference to pool instance
         * @type entitas.Pool */
        instance : static World

        _entities : dict of string, Entity
        _groups : dict of string, Group
        _groupsForIndex : array of Gee.ArrayList of Group
        _reusableEntities : Queue of Entity
        _retainedEntities : dict of string, Entity
        _componentsEnum : array of string
        _totalComponents : int = 0
        _creationIndex : int = 0
        _entitiesCache : array of Entity
        _uuid : Utils.UUID

        _initializeSystems : array of IInitializeSystem
        _executeSystems : array of IExecuteSystem
        /**
         * @constructor
         * @param Object components
         * @param number totalComponents
         * @param number startCreationIndex
         */
        construct(components : array of string, startCreationIndex : int=0)
            World.instance = this
            _onGroupCreated = new GroupsChanged()
            _onEntityCreated = new WorldChanged()
            _onEntityDestroyed = new WorldChanged()
            _onEntityWillBeDestroyed = new WorldChanged()

            _componentsEnum = components
            _totalComponents = components.length
            _creationIndex = startCreationIndex
            _groupsForIndex = new array of Gee.ArrayList of Group[components.length]

            _reusableEntities = new Queue of Entity
            _retainedEntities = new dict of string, Entity
            _entitiesCache = new array of Entity[0]
            _entities = new dict of string, Entity
            _groups = new dict of string, Group
            _initializeSystems = new array of IInitializeSystem[0]
            _executeSystems = new array of IExecuteSystem[0]
            World.componentsEnum = components
            World.totalComponents = _totalComponents
            _uuid = new Utils.UUID()


        /**
         * Create a new entity
         * @param string name
         * @returns entitas.Entity
         */
        def createEntity(name : string) : Entity
            var entity = _reusableEntities.length > 0 ? _reusableEntities.pop_head() : new Entity(_componentsEnum, _totalComponents)
            entity.initialize(name, _uuid.randomUUID(), _creationIndex++)
            _entities[entity.id] = entity
            _entitiesCache = new array of Entity[0]
            entity.onComponentAdded.add(updateGroupsComponentAddedOrRemoved)
            entity.onComponentRemoved.add(updateGroupsComponentAddedOrRemoved)
            entity.onComponentReplaced.add(updateGroupsComponentReplaced)
            entity.onEntityReleased.add(onEntityReleased)

            onEntityCreated.dispatch(this, entity)
            return entity


        /**
         * Destroy an entity
         * @param entitas.Entity entity
         */
        def destroyEntity(entity : Entity) raises Exception
            if !_entities.has_key(entity.id)
                raise new Exception.WorldDoesNotContainEntityException("Could not destroy entity!")

            _entities.unset(entity.id)
            _entitiesCache = new array of Entity[0]
            _onEntityWillBeDestroyed.dispatch(this, entity)
            entity.destroy()

            _onEntityDestroyed.dispatch(this, entity)

            if entity.refCount == 1
                entity.onEntityReleased.remove(onEntityReleased)
                _reusableEntities.push_head(entity)
             else
                _retainedEntities[entity.id] = entity

            entity.release()

        /**
         * Destroy All Entities
         */
        def destroyAllEntities() raises Exception
            var entities = getEntities()
            for var entity in entities
                destroyEntity(entity)

        /**
         * Check if pool has this entity
         *
         * @param entitas.Entity entity
         * @returns boolean
         */
        def hasEntity(entity : Entity) : bool
            return _entities.has_key(entity.id)

        /**
         * Gets all of the entities
         *
         * @returns Array<entitas.Entity>
         */
        def getEntities(matcher : IMatcher?=null) : array of Entity
            if matcher != null
                /** PoolExtension::getEntities */
                return getGroup(matcher).getEntities()
             else
                if _entitiesCache.length == 0
                    _entitiesCache = new array of Entity[_entitiesCache.length]
                    for e in _entities.values
                        _entitiesCache+= e
                return _entitiesCache

        /**
         * add System
         * @param entitas.ISystem|Function
         * @returns entitas.ISystem
         */
        def add(system : ISystem) : World
            if system isa ISetWorld
                ((ISetWorld)system).setWorld(this)

            if system isa IInitializeSystem
                _initializeSystems += (IInitializeSystem)system

            if system isa IExecuteSystem
                _executeSystems += (IExecuteSystem)system

            return this

        /**
         * Initialize Systems
         */
        def initialize()
            for var sys in _initializeSystems
                sys.initialize()

        /**
         * Execute sustems
         */
        def execute()
            for var sys in _executeSystems
                sys.execute()

        /**
         * Gets all of the entities that match
         *
         * @param entias.IMatcher matcher
         * @returns entitas.Group
         */
        def getGroup(matcher : IMatcher) : Group
            group:Group

            if _groups.has_key(matcher.id)
                group = _groups[matcher.id]
            else
                group = new Group(matcher)

                var entities = getEntities()
                try
                    for var entity in entities
                        group.handleEntitySilently(entity)

                 except e : Error
                    assert(false)

                _groups[matcher.id] = group

                for var index in matcher.indices
                    if _groupsForIndex[index] == null
                        _groupsForIndex[index] = new Gee.ArrayList of Group
                    _groupsForIndex[index].add(group)
                _onGroupCreated.dispatch(this, group)
            return group


        /**
         * @param entitas.Entity entity
         * @param number index
         * @param entitas.IComponent component
         */
        def updateGroupsComponentAddedOrRemoved(entity : Entity, index : int, component : IComponent)
            if index+1 <= _groupsForIndex.length
                var groups = _groupsForIndex[index]
                if groups != null
                    try
                        for var group in groups
                            group.handleEntity(entity, index, component)

                    except e : Error
                        assert(false)

        /**
         * @param entitas.Entity entity
         * @param number index
         * @param entitas.IComponent previousComponent
         * @param entitas.IComponent newComponent
         */
        def updateGroupsComponentReplaced(entity : Entity, index : int, previousComponent : IComponent, newComponent : IComponent)
            if index+1 <= _groupsForIndex.length
                var groups = _groupsForIndex[index]
                if groups != null
                    for var group in groups
                        group.updateEntity(entity, index, previousComponent, newComponent)

        /**
         * @param entitas.Entity entity
         */
        def onEntityReleased(entity : Entity)
            if entity.isEnabled
                /*raise new Exception.EntityIsNotDestroyedException("Cannot release entity.")*/
                return

            entity.onEntityReleased.remove(onEntityReleased)
            _retainedEntities.unset(entity.id)
            _reusableEntities.push_head(entity)
