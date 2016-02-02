namespace Bosco.ECS {
  public class Group : DarkMatter {

    /**
     * Subscribe to Entity Addded events
     * @type {entitas.utils.ISignal} */
    public GroupChanged onEntityAdded;
    /**
     * Subscribe to Entity Removed events
     * @type {entitas.utils.ISignal} */
    public GroupChanged onEntityRemoved;
    /**
     * Subscribe to Entity Updated events
     * @type {entitas.utils.ISignal} */
    public GroupUpdated onEntityUpdated;

    /**
     * Count the number of entities in this group
     * @type {number}
     * @name entitas.Group#count */
    public int count {get {return _entities.size;}}

    /**
     * Get the Matcher for this group
     * @type {entitas.IMatcher}
     * @name entitas.Group#matcher */
    public IMatcher matcher {get {return _matcher;}}

    private Gee.HashMap<string,Entity> _entities;
    private IMatcher _matcher;
    private GenericArray<Entity> _entitiesCache;
    private Entity _singleEntityCache;
    private string _toStringCache;

    public Group(IMatcher matcher) {
      _entities = new Gee.HashMap<string,Entity>();
      _entitiesCache = new GenericArray<Entity>();
      onEntityAdded = new GroupChanged();
      onEntityRemoved = new GroupChanged();
      onEntityUpdated = new GroupUpdated();
      _matcher = matcher;
    }

    /**
     * Handle adding and removing component from the entity without raising events
     * @param entity
     */
    public void handleEntitySilently(Entity entity) throws Exception {
      if (_matcher.matches(entity)) {
        addEntitySilently(entity);
      } else {
        removeEntitySilently(entity);
      }
    }

    /**
     * Handle adding and removing component from the entity and raisieevents
     * @param entity
     * @param index
     * @param component
     */
    public void handleEntity(Entity entity, int index, IComponent component) throws Exception {
      if (_matcher.matches(entity)) {
        addEntity(entity, index, component);
      } else {
        removeEntity(entity, index, component);
      }
    }

    /**
     * Update entity and raise events
     * @param entity
     * @param index
     * @param previousComponent
     * @param newComponent
     */
    public void updateEntity(Entity entity, int index, IComponent previousComponent, IComponent newComponent) {
      if (_entities.has_key(entity.id)) {
        onEntityRemoved.dispatch(this, entity, index, previousComponent);
        onEntityAdded.dispatch(this, entity, index, newComponent);
        onEntityUpdated.dispatch(this, entity, index, previousComponent, newComponent);
      }
    }

    /**
     * Add entity without raising events
     * @param entity
     */
    public void addEntitySilently(Entity entity) {
      if (!_entities.has_key(entity.id)) {
        _entities[entity.id] = entity;
        _entitiesCache = null;
        _singleEntityCache = null;
        entity.addRef();
      }
    }

    /**
     * Add entity and raise events
     * @param entity
     * @param index
     * @param component
     */
    public void addEntity(Entity entity, int index, IComponent component) {
      if (!_entities.has_key(entity.id)) {
        _entities[entity.id] = entity;
        _entitiesCache = null;
        _singleEntityCache = null;
        entity.addRef();
        onEntityAdded.dispatch(this, entity, index, component);
      }
    }

    /**
     * Remove entity without raising events
     * @param entity
     */
    public void removeEntitySilently(Entity entity) throws Exception {
      if (_entities.has_key(entity.id)) {
        _entities.unset(entity.id);
        _entitiesCache = null;
        _singleEntityCache = null;
        entity.release();
      }
    }

    /**
     * Remove entity and raise events
     * @param entity
     * @param index
     * @param component
     */
    public void removeEntity(Entity entity, int index, IComponent component) throws Exception {
      if (_entities.has_key(entity.id)) {
        _entities.unset(entity.id);
        _entitiesCache = null;
        _singleEntityCache = null;
        onEntityRemoved.dispatch(this, entity, index, component);
        entity.release();
      }
    }

    /**
     * Check if group has this entity
     *
     * @param entity
     * @returns boolean
     */
    public bool containsEntity(Entity entity) {
      return _entities.has_key(entity.id);
    }



    /**
     * Get a list of the entities in this group
     *
     * @returns Array<entitas.Entity>
     */
    public GenericArray<Entity> getEntities() {
      if (_entitiesCache == null) {
        _entitiesCache = new GenericArray<Entity>();
        foreach (var e in _entities.values) {
          _entitiesCache.add(e);
        }
      }
      return _entitiesCache;
    }

    /**
     * Gets an entity singleton.
     * If a group has more than 1 entity, this is an error condition.
     *
     * @returns entitas.Entity
     */
    public Entity? getSingleEntity() throws Exception {
      if (_singleEntityCache == null) {
        var values = _entities.values;
        var c = values.size;
        if (c == 1) {
          foreach (var e in _entities.values) {
            _singleEntityCache = e;
          }
        } else if (c == 0) {
          return null;
        } else {
          throw new Exception.SingleEntityException(_matcher.toString());
        }
      }

      return _singleEntityCache;
    }

    /**
     * Create a string representation for this group:
     *
     *  ex: 'Group(Position)'
     *
     * @returns string
     */
    public string toString() {
      if (_toStringCache == null) {
        _toStringCache = "Group(" + _matcher.toString() + ")";
      }
      return _toStringCache;
    }

  }
}
