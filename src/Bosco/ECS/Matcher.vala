namespace Bosco.ECS {
    public class Matcher : IMatcher {

      string _id = "";
      int[] _indices = {};

      public string id {get {return _id;}}
      public int[] indices {get {return _indices;}}
      public void matches(Entity entity) {

      }

    }
}
