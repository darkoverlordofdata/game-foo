namespace Bosco.ECS {

  public class Entity : DarkMatter {

    /**
     * @static
     * @type {number} */
    public static int instanceIndex = 0;

    /**
     * @static
     * @type {number} */
    public static int size = 0;

    /**
     * A unique sequential index number assigned to each entity at creation
     * @type {number}
     * @name entitas.Entity#creationIndex */
    public int creationIndex {get  {return _creationIndex;}}

    /**
     * Subscribe to Entity Released Event
     * @type {entitas.ISignal} */
    public EntityReleased onEntityReleased;

    /**
     * Subscribe to Component Added Event
     * @type {entitas.ISignal} */
    public EntityChanged onComponentAdded;

    /**
     * Subscribe to Component Removed Event
     * @type {entitas.ISignal} */
    public EntityChanged onComponentRemoved;

    /**
     * Subscribe to Component Replaced Event
     * @type {entitas.ISignal} */
    public ComponentReplaced onComponentReplaced;

    /**
     * Entity name
     * @type {string} */
    public string name = "";

    /**
     *  Entity Id
     * @type {string} */
    public string id = "";

    public int _creationIndex=0;
    public bool _isEnabled=true;
    public IComponent[] _components = new IComponent[16];
    public IComponent[] _componentsCache;
    private int[] _componentIndicesCache = new int[16];
    public string _toStringCache = "";
    public int _refCount = 0;
    private World _world;
    private unowned string[] _componentsEnum;

    /**
     * The basic game object. Everything is an entity with components that
     * are added / removed as needed.
     *
     * @param {Object} componentsEnum
     * @param {number} totalComponents
     * @constructor
     */
    public Entity(string[] componentsEnum, int totalComponents=16) {
      onEntityReleased = new EntityReleased();
      onComponentAdded = new EntityChanged();
      onComponentRemoved = new EntityChanged();
      onComponentReplaced = new ComponentReplaced();
      _componentsEnum = componentsEnum;
      _world = World.instance;

    }
     /**
      * AddComponent
      *
      * @param {number} index
      * @param {entitas.IComponent} component
      * @returns {entitas.Entity}
      */
    public Entity addComponent(int index, IComponent component) throws Exception {
      if (!_isEnabled) {
        throw new Exception.EntityIsNotEnabledException("Cannot add component!");
      }
      if (hasComponent(index)) {
        var errorMsg = @"Cannot add component at index $index";
        throw new Exception.EntityAlreadyHasComponentException(errorMsg);
      }
      _components[index] = component;
      _componentsCache = null;
      _componentIndicesCache = null;
      _toStringCache = null;
      onComponentAdded.dispatch(this, index, component);
      return this;
    }

     /**
      * RemoveComponent
      *
      * @param {number} index
      * @returns {entitas.Entity}
      */
    public Entity removeComponent(int index) throws Exception {
      if (!_isEnabled) {
        throw new Exception.EntityIsNotEnabledException("Cannot remove component!");
      }
      if (!hasComponent(index)) {
        var errorMsg = @"Cannot remove component at index $index";
        throw new Exception.EntityDoesNotHaveComponentException(errorMsg);
      }
      _replaceComponent(index, null);
      return this;
    }

      /**
       * ReplaceComponent
       *
       * @param {number} index
       * @param {entitas.IComponent} component
       * @returns {entitas.Entity}
       */
    public Entity replaceComponent(int index, IComponent component) throws Exception {
      if (!_isEnabled) {
        throw new Exception.EntityIsNotEnabledException("Cannot replace component!");
      }

      if (hasComponent(index)) {
        _replaceComponent(index, component);
      } else if (component != null) {
        addComponent(index, component);
      }
      return this;
    }

    protected void _replaceComponent(int index, IComponent? replacement) {
      var previousComponent = _components[index];
      if (previousComponent == replacement) {
        onComponentReplaced.dispatch(this, index, previousComponent, replacement);
      } else {
        _components[index] = replacement;
        _componentsCache = null;
        if (replacement == null) {
          _components[index] = null;
          _componentIndicesCache = null;
          _toStringCache = null;
          onComponentRemoved.dispatch(this, index, previousComponent);

        } else {
          onComponentReplaced.dispatch(this, index, previousComponent, replacement);
        }
      }

    }

    /**
     * GetComponent
     *
     * @param {number} index
     * @param {entitas.IComponent} component
     */
    public IComponent getComponent(int index) throws Exception {
      if (!hasComponent(index)) {
        var errorMsg = @"Cannot get component at index $index";
        throw new Exception.EntityDoesNotHaveComponentException(errorMsg);
      }
      return _components[index];
    }

    /**
     * GetComponents
     *
     * @returns {Array<entitas.IComponent>}
     */
    public IComponent[] getComponents() {
      if (_componentsCache == null) {
        IComponent[] components = {};
        for (var i = 0;i < _components.length; i++) {
          var component = _components[i];
          if (component != null) {
            components+= component;
          }
        }
        _componentsCache = components;
      }
      return _componentsCache;
    }

    /**
     * GetComponentIndices
     *
     * @returns {Array<number>}
     */
    public int[] getComponentIndices() {
      if (_componentIndicesCache == null) {
        int[] indices = {};
        for (var i = 0; i < _components.length; i++) {
          if (_components[i] != null) {
            indices+= i;
          }
        }
        _componentIndicesCache = indices;
      }
      return _componentIndicesCache;
    }

     /**
      * HasComponent
      *
      * @param {number} index
      * @returns {boolean}
      */
    public bool hasComponent(int index) {
      return _components[index] != null;
    }

    /**
     * HasComponents
     *
     * @param {Array<number>} indices
     * @returns {boolean}
     */
    public bool hasComponents(int[] indices) {
      for (var i = 0; i < indices.length; i++) {
        if (_components[indices[i]] == null) {
          return false;
        }
      }
      return true;
    }

    /**
     * HasAnyComponent
     *
     * @param {Array<number>} indices
     * @returns {boolean}
     */
    public bool hasAnyComponent(int[] indices) {
      for (var i = 0; i < indices.length; i++) {
        if (_components[indices[i]] != null) {
          return true;
        }
      }
      return false;
    }

    /**
     * RemoveAllComponents
     *
     */
    public void removeAllComponents() {
      _toStringCache = "";
      for (var i = 0; i < _components.length; i++) {
        if (_components[i] != null) {
          _replaceComponent(i, null);
        }
      }
    }

    /**
     * Destroy
     *
     */
    public void destroy() {
      removeAllComponents();
      onComponentAdded.clear();
      onComponentReplaced.clear();
      onComponentRemoved.clear();
      _isEnabled = false;
    }

    /**
     * ToString
     *
     * @returns {string}
     */
    public string toString() {
      if (_toStringCache == "") {
        var sb = new StringBuilder();
        var seperator = ", ";
        var components = getComponents();
        var lastSeperator = components.length - 1 ;
        for (var i = 0, componentsLength = components.length; i < componentsLength; i++) {
          sb.append(_componentsEnum[i].replace("Component", ""));
          if (i < lastSeperator) {
            sb.append(seperator);
          }
        }
        _toStringCache = sb.str;
      }
      return _toStringCache;
    }

    /**
     * AddRef
     *
     * @returns {entitas.Entity}
     */
    public Entity addRef() {
      _refCount += 1;
      return this;
    }

    /**
     * Release
     *
     */
    public void release() throws Exception {
      this._refCount -= 1;
      if (this._refCount == 0) {
        onEntityReleased.dispatch(this);

      } else if (this._refCount < 0) {
        throw new Exception.EntityIsAlreadyReleasedException("");
      }
    }
  }
}
