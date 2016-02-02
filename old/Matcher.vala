namespace Bosco.ECS {

  /**
     * Event Types
     * @readonly
     * @enum {number}
     */
    public enum GroupEventType {
      OnEntityAdded,
      OnEntityRemoved,
      OnEntityAddedOrRemoved
    }

    public class Matcher : DarkMatter, IMatcher, IAllOfMatcher, IAnyOfMatcher, INoneOfMatcher {

      /**
       * Get the matcher id
       * @type {number}
       * @name entitas.Matcher#id */
      public string id {get {return _idCache;}}

      /**
       * A unique sequential index number assigned to each ,atch
       * @type {number} */
      public static int uniqueId = 0;

      /**
       * A list of the component ordinals that this matches
       * @type {Array<number>}
       * @name entitas.Matcher#indices */
       public int[] indices {
         get {
           if (_indices == null) {
             _indices = mergeIndices();
           }
           return _indices;
         }
       }

       /**
        * A unique sequential index number assigned to each entity at creation
        * @type {number}
        * @name entitas.Matcher#allOfIndices */
       public int[] allOfIndices {get {return _allOfIndices;}}

       /**
        * A unique sequential index number assigned to each entity at creation
        * @type {number}
        * @name entitas.Matcher#anyOfIndices */
       public int[] anyOfIndices {get {return _anyOfIndices;}}

       /**
        * A unique sequential index number assigned to each entity at creation
        * @type {number}
        * @name entitas.Matcher#noneOfIndices */
       public int[] noneOfIndices {get {return _noneOfIndices;}}

       private int[] _indices;
       public int[] _allOfIndices;
       public int[] _anyOfIndices;
       public int[] _noneOfIndices;
       private string _toStringCache;
       private int _id;
       private string _idCache;

      public Matcher() {
        _id = Matcher.uniqueId++;
        _idCache = _id.to_string();
      }

      /**
       * Matches anyOf the components/indices specified
       * @params {Array<entitas.IMatcher>|Array<number>} args
       * @returns {entitas.Matcher}
       */
      public IAnyOfMatcher anyOf(int[] args) {
        _anyOfIndices = Matcher.distinctIndices(args);
        _indices = null;
        return this;
      }

      /**
       * Matches noneOf the components/indices specified
       * @params {Array<entitas.IMatcher>|Array<number>} args
       * @returns {entitas.Matcher}
       */
      public INoneOfMatcher noneOf(int[] args) {
        _noneOfIndices = Matcher.distinctIndices(args);
        _indices = null;
        return this;
      }

      /**
       * Check if the entity matches this matcher
       * @param {entitas.Entity} entity
       * @returns {boolean}
       */
      public bool matches(Entity entity) {
        bool matchesAllOf = _allOfIndices == null ? true : entity.hasComponents(_allOfIndices);
        bool matchesAnyOf = _anyOfIndices == null ? true : entity.hasAnyComponent(_anyOfIndices);
        bool matchesNoneOf = _noneOfIndices == null ? true : !entity.hasAnyComponent(_noneOfIndices);
        return matchesAllOf && matchesAnyOf && matchesNoneOf;
      }

      /**
       * Merge list of component indices
       * @returns {Array<number>}
       */
      public int[] mergeIndices() {

        int[] indicesList = {};
        if (_allOfIndices != null) {
          for (var i=0; i<_allOfIndices.length; i++) {
              indicesList += _allOfIndices[i];
          }
        }
        if (_anyOfIndices != null) {
          for (var i=0; i<_anyOfIndices.length; i++) {
              indicesList += _anyOfIndices[i];
          }
        }
        if (_noneOfIndices != null) {
          for (var i=0; i<_noneOfIndices.length; i++) {
              indicesList += _noneOfIndices[i];
          }
        }
        return Matcher.distinctIndices(indicesList);
      }

      /**
       * toString representation of this matcher
       * @returns {string}
       */
      public string toString() {
        if (_toStringCache == null) {
          var sb = new StringBuilder();
          if (_allOfIndices != null) {
            Matcher.appendIndices(sb, "AllOf", _allOfIndices);
          }
          if (_anyOfIndices != null) {
            if (_allOfIndices != null) {
              sb.append(".");
            }
            Matcher.appendIndices(sb, "AnyOf", _anyOfIndices);
          }
          if (_noneOfIndices != null) {
            Matcher.appendIndices(sb, ".NoneOf", _noneOfIndices);
          }
          _toStringCache = sb.str;
        }
        return _toStringCache;
      }

      /**
       * Get the set if distinct (non-duplicate) indices from a list
       * @param {Array<number>} indices
       * @returns {Array<number>}
       */
      public static int[] distinctIndices(int[] indices) {

        var indicesSet = new Gee.HashSet<int>();
        int[] result = {};

        for (var i=0; i<indices.length; i++) {
          var index = indices[i];
          if (!indicesSet.contains(index)) {
            result += index;
          }
          indicesSet.add(index);
        }
        return result;
      }

      /**
       * Merge all the indices of a set of Matchers
       * @param {Array<IMatcher>} matchers
       * @returns {Array<number>}
       */
      public static int[] merge(IMatcher[] matchers) throws Exception {

        int[] indices = {};

        for (var i = 0; i<matchers.length; i++) {
          var matcher = matchers[i];
          if (matcher.indices.length != 1) {
            throw new Exception.MatcherException(matcher.toString());
          }
          indices+= matcher.indices[0];
        }
        return indices;
      }

      /**
       * Matches allOf the components/indices specified
       * @params {Array<entitas.IMatcher>|Array<number>} args
       * @returns {entitas.Matcher}
       */
       /*public static IAllOfMatcher AllOf(int[] args) {*/
      public static IMatcher AllOf(int[] args) {
        var matcher = new Matcher();
        matcher._allOfIndices = Matcher.distinctIndices(args);
        return matcher;
      }

      /**
       * Matches anyOf the components/indices specified
       * @params {Array<entitas.IMatcher>|Array<number>} args
       * @returns {entitas.Matcher}
       */
       /*public static IAnyOfMatcher AnyOf(int[] args) {*/
      public static IMatcher AnyOf(int[] args) {
        var matcher = new Matcher();
        matcher._anyOfIndices = Matcher.distinctIndices(args);
        return matcher;
      }

      private static void appendIndices(StringBuilder sb, string prefix, int[] indexArray) {
        string SEPERATOR = ", ";
        sb.append(prefix);
        sb.append("(");
        var lastSeperator = indexArray.length - 1;
        for (var i = 0; i<indexArray.length; i++) {
          sb.append(indexArray[i].to_string());
          if (i < lastSeperator) {
            sb.append(SEPERATOR);
          }
        }
        sb.append(")");
      }



    }
}
