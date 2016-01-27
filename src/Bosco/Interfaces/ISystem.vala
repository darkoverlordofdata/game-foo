namespace Bosco.ECS {
    public interface ISystem : Object  {

    }

    public interface ISetWorld  {
      public abstract void setWorld(World world);
    }

    public interface IExecuteSystem  {
      public abstract void execute();
    }

    public interface IInitializeSystem  {
      public abstract void initialize();
    }

}
