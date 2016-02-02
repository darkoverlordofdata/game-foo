using Gee;
using Utils;

namespace Bosco.ECS {
  public class World : DarkMatter {

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
    public int reusableEntitiesCount {get { return (int)_reusableEntities.length; }}

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
    public static string[] componentsEnum;

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
    public GenericArray<Group>_testArray;
    public GenericArray<GenericArray<Group>>_groupsForIndex;
    public GLib.Queue<Entity> _reusableEntities;
    public HashMap<string, Entity> _retainedEntities;
    public string[] _componentsEnum;
    public int _totalComponents = 0;
    public int _creationIndex = 0;
    public GenericArray<Entity> _entitiesCache;
    public UUID uuid;

    private IInitializeSystem[] _initializeSystems;
    private IExecuteSystem[] _executeSystems;
    /**
     * @constructor
     * @param {Object} components
     * @param {number} totalComponents
     * @param {number} startCreationIndex
     */
    public World(string[] components, int startCreationIndex=0) {
      World.instance = this;
      onGroupCreated = new GroupsChanged();
      onEntityCreated = new WorldChanged();
      onEntityDestroyed = new WorldChanged();
      onEntityWillBeDestroyed = new WorldChanged();

      _componentsEnum = components;
      _totalComponents = components.length;
      _creationIndex = startCreationIndex;
      _groupsForIndex = new GenericArray<GenericArray<Group>>();

      _testArray = new GenericArray<Group>();
      _reusableEntities = new GLib.Queue<Entity>();
      _retainedEntities = new HashMap<string, Entity>();
      _entitiesCache = new GenericArray<Entity>();
      _entities = new HashMap<string, Entity>();
      _groups = new HashMap<string, Group>();
      _initializeSystems = {};
      _executeSystems = {};
      World.componentsEnum = components;
      World.totalComponents = _totalComponents;
      uuid = new UUID();
    }

    /**
     * Create a new entity
     * @param {string} name
     * @returns {entitas.Entity}
     */
    public Entity createEntity(string name) {
      var entity = _reusableEntities.length > 0 ? _reusableEntities.pop_head() : new Entity(_componentsEnum, _totalComponents);
      entity.initialize(name, uuid.randomUUID(), _creationIndex++);
      _entities[entity.id] = entity;
      _entitiesCache = new GenericArray<Entity>();
      entity.onComponentAdded.add(updateGroupsComponentAddedOrRemoved);
      entity.onComponentRemoved.add(updateGroupsComponentAddedOrRemoved);
      entity.onComponentReplaced.add(updateGroupsComponentReplaced);
      entity.onEntityReleased.add(onEntityReleased);

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

      if (entity.refCount == 1) {
        entity.onEntityReleased.remove(onEntityReleased);
        _reusableEntities.push_head(entity);
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
      for (var i = 0; i < entities.length; i++) {
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
      stdout.printf("In World\n");
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
        try {
          for (var i = 0; i < entities.length; i++) {
            group.handleEntitySilently(entities[i]);
          }
        } catch (Error e) {
          assert(false);
        }
        _groups[matcher.id] = group;

        for (var i = 0; i < matcher.indices.length; i++) {
          var index = matcher.indices[i];
          GenericArray<Group> ag;
          if (_groupsForIndex.length < index) {
            _groupsForIndex.add(ag = new GenericArray<Group>());
          } else {
            ag = _groupsForIndex[index];
          }
          ag.add(group);
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
      if (index+1 <= _groupsForIndex.length) {
        var groups = _groupsForIndex[index];
        if (groups != null) {
          try {
            for (var i = 0; i < groups.length; i++) {
              groups[i].handleEntity(entity, index, component);
            }
          }
          catch (Error e) {
            assert(false);
          }
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
      if (index+1 <= _groupsForIndex.length) {
        var groups = _groupsForIndex[index];
        if (groups != null) {
          for (var i = 0; i < groups.length; i++) {
            groups[i].updateEntity(entity, index, previousComponent, newComponent);
          }
        }
      }
    }

    /**
     * @param {entitas.Entity} entity
     */
    protected void onEntityReleased(Entity entity) {
      if (entity.isEnabled) {
        /*throw new Exception.EntityIsNotDestroyedException("Cannot release entity.");*/
        return;
      }
      entity.onEntityReleased.remove(onEntityReleased);
      _retainedEntities.unset(entity.id);
      _reusableEntities.push_head(entity);
    }

  }
}
