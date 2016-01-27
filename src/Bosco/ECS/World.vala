using Gee;
using Utils;

namespace Bosco.ECS {
  public class World : Object {

    /**
     * The total number of components in this pool
     * @type {number}
     * @name entitas.Pool#totalComponents */
    public int componentsCount { get {return _totalComponents; }}

    /**
     * Count of active entities
     * @type {number}
     * @name entitas.Pool#count */
    public int count {get { return _entities.size; }}

    /**
     * Count of entities waiting to be recycled
     * @type {number}
     * @name entitas.Pool#reusableEntitiesCount */
    public int reusableEntitiesCount {get { return _reusableEntities.size; }}

    /**
     * Count of entities that sill have references
     * @type {number}
     * @name entitas.Pool#retainedEntitiesCount */
    public int retainedEntitiesCount {get { return _retainedEntities.size; }}

    /**
     * Subscribe to Entity Created Event
     * @type {entitas.utils.ISignal} */
    public WorldChanged onEntityCreated;

    /**
     * Subscribe to Entity Will Be Destroyed Event
     * @type {entitas.utils.ISignal} */
    public WorldChanged onEntityWillBeDestroyed;

    /**
     * Subscribe to Entity Destroyed Event
     * @type {entitas.utils.ISignal} */
    public WorldChanged onEntityDestroyed;

    /**
     * Subscribe to Group Created Event
     * @type {entitas.utils.ISignal} */
    public GroupsChanged onGroupCreated;

    /**
     * Entity name for debugging
     * @type {string} */
    public string name= "";

    /**
     * An enum of valid component types
     * @type {Object<string,number>} */
    public static unowned EnumClass componentsEnum;

    /**
     * Count of components
     * @`type` {number} */
    public static int totalComponents = 0;

    /**
     * Global reference to pool instance
     * @type {entitas.Pool} */
    public static World instance;

    public HashMap<string, Entity> _entities;
    public HashMap<string, Group> _groups;
    public ArrayList<ArrayList<Group>>_groupsForIndex;
    public ArrayList<Entity> _reusableEntities;
    public HashMap<string, Entity> _retainedEntities;
    public unowned EnumClass _componentsEnum;
    public int _totalComponents = 0;
    public int _creationIndex = 0;
    public GenericArray<Entity> _entitiesCache;
    public OnEntityChanged _cachedUpdateGroupsComponentAddedOrRemoved;
    public OnComponentReplaced _cachedUpdateGroupsComponentReplaced;
    public OnEntityReleased _cachedOnEntityReleased;

    private IInitializeSystem[] _initializeSystems;
    private IExecuteSystem[] _executeSystems;
    /**
     * @constructor
     * @param {Object} components
     * @param {number} totalComponents
     * @param {number} startCreationIndex
     */
    public World(EnumClass components, int totalComponents, int startCreationIndex=0) {
      World.instance = this;
      onGroupCreated = new GroupsChanged();
      onEntityCreated = new WorldChanged();
      onEntityDestroyed = new WorldChanged();
      onEntityWillBeDestroyed = new WorldChanged();

      _componentsEnum = components;
      _totalComponents = totalComponents;
      _creationIndex = startCreationIndex;
      _groupsForIndex = new ArrayList<ArrayList<Group>>();
      _reusableEntities = new ArrayList<Entity>();
      _retainedEntities = new HashMap<string, Entity>();
      _entitiesCache = new GenericArray<Entity>();
      _cachedUpdateGroupsComponentAddedOrRemoved = updateGroupsComponentAddedOrRemoved;
      _cachedUpdateGroupsComponentReplaced = updateGroupsComponentReplaced;
      _cachedOnEntityReleased = onEntityReleased;
      _initializeSystems = {};
      _executeSystems = {};
      World.componentsEnum = components;
      World.totalComponents = totalComponents;

    }

    /**
     * Create a new entity
     * @param {string} name
     * @returns {entitas.Entity}
     */
    public Entity createEntity(string name) {
      var entity = _reusableEntities.size > 0 ? _reusableEntities.remove_at(_reusableEntities.size-1) : new Entity(_componentsEnum, _totalComponents);
      entity._isEnabled = true;
      entity.name = name;
      entity._creationIndex = _creationIndex++;
      entity.id = UUID.randomUUID();
      entity.addRef();
      _entities[entity.id] = entity;
      _entitiesCache.remove_range(0, _entitiesCache.length);
      entity.onComponentAdded.add(_cachedUpdateGroupsComponentAddedOrRemoved);
      entity.onComponentRemoved.add(_cachedUpdateGroupsComponentAddedOrRemoved);
      entity.onComponentReplaced.add(_cachedUpdateGroupsComponentReplaced);
      entity.onEntityReleased.add(_cachedOnEntityReleased);

      onEntityCreated.dispatch(this, entity);
      return entity;
    }

    /**
     * Destroy an entity
     * @param {entitas.Entity} entity
     */
    public void destroyEntity(Entity entity) throws Exception {
      if (!_entities.has_key(entity.id)) {
        throw new Exception.WorldDoesNotContainEntityException("Could not destroy entity!");
      }
      _entities.unset(entity.id);
      _entitiesCache.remove_range(0, _entitiesCache.length);
      onEntityWillBeDestroyed.dispatch(this, entity);
      entity.destroy();

      onEntityDestroyed.dispatch(this, entity);

      if (entity._refCount == 1) {
        entity.onEntityReleased.remove(_cachedOnEntityReleased);
        _reusableEntities.add(entity);
      } else {
        _retainedEntities[entity.id] = entity;
      }
      entity.release();
    }

    /**
     * Destroy All Entities
     */
    public void destroyAllEntities() throws Exception {
      var entities = getEntities();
      for (var i = 0, entitiesLength = entities.length; i < entitiesLength; i++) {
        destroyEntity(entities[i]);
      }
    }

    /**
     * Check if pool has this entity
     *
     * @param {entitas.Entity} entity
     * @returns {boolean}
     */
    public bool hasEntity(Entity entity) {
      return _entities.has_key(entity.id);
    }

    /**
     * Gets all of the entities
     *
     * @returns {Array<entitas.Entity>}
     */
    public GenericArray<Entity> getEntities(IMatcher? matcher=null) {
      if (matcher != null) {
        /** PoolExtension::getEntities */
        return getGroup(matcher).getEntities();
      } else {
        if (_entitiesCache.length == 0) {
          foreach (Entity e in _entities.values) {
            _entitiesCache.add(e);
          }
        }
        return _entitiesCache;
      }
    }
    /**
     * add System
     * @param {entitas.ISystem|Function}
     * @returns {entitas.ISystem}
     */
    public World add(ISystem system) {
      if (system is ISetWorld) {
        ((ISetWorld)system).setWorld(this);
      }

      if (system is IInitializeSystem) {
        _initializeSystems += (IInitializeSystem)system;
      }

      if (system is IExecuteSystem) {
        _executeSystems += (IExecuteSystem)system;
      }
      return this;
    }

    /**
     * Initialize Systems
     */
    public void initialize() {
      for (var i = 0; i<_initializeSystems.length;i++) {
        _initializeSystems[i].initialize();
      }
    }

    /**
     * Execute sustems
     */
    public void execute() {
      for (var i = 0; i<_executeSystems.length; i++) {
        _executeSystems[i].execute();
      }
    }
    /**
     * Gets all of the entities that match
     *
     * @param {entias.IMatcher} matcher
     * @returns {entitas.Group}
     */
    public Group getGroup(IMatcher matcher) {
      Group group;

      if (_groups.has_key(matcher.id)) {
        group = _groups[matcher.id];
      } else {
        group = new Group(matcher);

        var entities = getEntities();
        for (var i = 0, entitiesLength = entities.length; i < entitiesLength; i++) {
          //group.handleEntitySilently(entities[i]);
        }
        _groups[matcher.id] = group;

        for (var i = 0, indicesLength = matcher.indices.length; i < indicesLength; i++) {
          var index = matcher.indices[i];
          if (_groupsForIndex[index] == null) {
            _groupsForIndex[index] = new Gee.ArrayList<Group>();
          }
          _groupsForIndex[index].add(group);
        }
        onGroupCreated.dispatch(this, group);
      }
      return group;
    }

    /**
     * @param {entitas.Entity} entity
     * @param {number} index
     * @param {entitas.IComponent} component
     */
    protected void updateGroupsComponentAddedOrRemoved(Entity entity, int index, IComponent component) {
      var groups = _groupsForIndex[index];
      if (groups != null) {
        for (var i = 0, groupsCount = groups.size; i < groupsCount; i++) {
          //groups[i].handleEntity(entity, index, component);
        }
      }
    }

    /**
     * @param {entitas.Entity} entity
     * @param {number} index
     * @param {entitas.IComponent} previousComponent
     * @param {entitas.IComponent} newComponent
     */
    protected void updateGroupsComponentReplaced(Entity entity, int index, IComponent previousComponent, IComponent newComponent) {
      var groups = _groupsForIndex[index];
      if (groups != null) {
        for (var i = 0, groupsCount = groups.size; i < groupsCount; i++) {
          //groups[i].updateEntity(entity, index, previousComponent, newComponent);
        }
      }
    }

    /**
     * @param {entitas.Entity} entity
     */
    protected void onEntityReleased(Entity entity) {
      if (entity._isEnabled) {
        /*throw new Exception.EntityIsNotDestroyedException("Cannot release entity.");*/
        return;
      }
      entity.onEntityReleased.remove(_cachedOnEntityReleased);
      _retainedEntities.unset(entity.id);
      _reusableEntities.add(entity);
    }


  }
}
