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
      public GroupChanged onGroupCreated;

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
       * @type {number} */
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
      public ArrayList<Entity> _entitiesCache;
      public EntityChanged _cachedUpdateGroupsComponentAddedOrRemoved;
      public ComponentReplaced _cachedUpdateGroupsComponentReplaced;
      public EntityReleased _cachedOnEntityReleased;

      public void createSystem(ISystem system) {

      }

      public Entity[]? getEntities(IMatcher? matcher=null) {
          return null;
      }


      /**
       * Set the system pool if supported
       *
       * @static
       * @param {entitas.ISystem} system
       * @param {entitas.Pool} pool
       */
      public static void setPool(ISystem system, World world) {
        /*var poolSystem = as(system, 'setPool');
        if (poolSystem != null) {
          poolSystem.setPool(pool);
        }*/
      }

      /**
       * @constructor
       * @param {Object} components
       * @param {number} totalComponents
       * @param {number} startCreationIndex
       */
      public World(EnumClass components, int totalComponents, int startCreationIndex=0) {
        World.instance = this;
        onGroupCreated = new GroupChanged();
        onEntityCreated = new WorldChanged();
        onEntityDestroyed = new WorldChanged();
        onEntityWillBeDestroyed = new WorldChanged();

        _componentsEnum = components;
        _totalComponents = totalComponents;
        _creationIndex = startCreationIndex;
        _groupsForIndex = new ArrayList<ArrayList<Group>>();
        _reusableEntities = new ArrayList<Entity>();
        _retainedEntities = new HashMap<string, Entity>();
        _entitiesCache = new ArrayList<Entity>();
        /*_cachedUpdateGroupsComponentAddedOrRemoved = updateGroupsComponentAddedOrRemoved;
        _cachedUpdateGroupsComponentReplaced = updateGroupsComponentReplaced;
        _cachedOnEntityReleased = onEntityReleased;*/
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
        _entitiesCache = null;
        /*entity.onComponentAdded.add(_cachedUpdateGroupsComponentAddedOrRemoved);
        entity.onComponentRemoved.add(_cachedUpdateGroupsComponentAddedOrRemoved);
        entity.onComponentReplaced.add(_cachedUpdateGroupsComponentReplaced);
        entity.onEntityReleased.add(_cachedOnEntityReleased);*/

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
        _entitiesCache = null;
        onEntityWillBeDestroyed.dispatch(this, entity);
        entity.destroy();

        onEntityDestroyed.dispatch(this, entity);

        if (entity._refCount == 1) {
          //entity.onEntityReleased.remove(_cachedOnEntityReleased);
          _reusableEntities.add(entity);
        } else {
          _retainedEntities[entity.id] = entity;
        }
        entity.release();

      }




    }
}
