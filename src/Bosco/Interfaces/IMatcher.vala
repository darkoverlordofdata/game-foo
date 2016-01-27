namespace Bosco.ECS {
    public interface IMatcher  {
      public abstract string id {get;}
      public abstract int[] indices {get;}
      public abstract void matches(Entity entity);
    }
}
