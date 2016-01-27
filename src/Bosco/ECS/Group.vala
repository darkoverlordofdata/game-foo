namespace Bosco.ECS {
  public class Group : DarkMatter {
    GenericArray<Entity> _entitiesCache;

    public Group(IMatcher matcher) {
      _entitiesCache = new GenericArray<Entity>();
    }

    public GenericArray<Entity> getEntities() {
      return _entitiesCache;
    }

  }
}
