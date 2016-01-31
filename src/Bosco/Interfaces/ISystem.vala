namespace Bosco.ECS {
    public interface ISystem : DarkMatter  {

    }

    public interface ISetWorld : DarkMatter  {
      public abstract void setWorld(World world);
    }

    public interface IExecuteSystem : DarkMatter  {
      public abstract void execute();
    }

    public interface IInitializeSystem : DarkMatter  {
      public abstract void initialize();
    }

}
