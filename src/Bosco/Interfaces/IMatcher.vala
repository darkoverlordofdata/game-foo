namespace Bosco.ECS {
    public interface IMatcher : DarkMatter {
      public abstract void matches(Entity entity);
    }
}
