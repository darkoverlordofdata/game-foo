namespace Bosco.ECS {
    public interface IMatcher : DarkMatter {
      public abstract string id {get;}
      public abstract int[] indices {get;}
      public abstract bool matches(Entity entity);
      public abstract string toString();
    }

    public interface ICompoundMatcher : DarkMatter {
      public abstract int[] allOfIndices {get;}
      public abstract int[] anyOfIndices {get;}
      public abstract int[] noneOfIndices {get;}

    }

    public interface INoneOfMatcher : DarkMatter {

    }

    public interface IAnyOfMatcher : DarkMatter {
      public abstract INoneOfMatcher noneOf(int[] args);
    }

    public interface IAllOfMatcher : DarkMatter {
      public abstract IAnyOfMatcher anyOf(int[] args);
      public abstract INoneOfMatcher noneOf(int[] args);
    }
}
