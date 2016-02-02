[indent=4]

namespace Bosco.ECS

    /**
     * Event Types
     * @readonly
     * @enum number
     */
    enum GroupEventType
        OnEntityAdded
        OnEntityRemoved
        OnEntityAddedOrRemoved


    class Matcher : DarkMatter implements IMatcher, IAllOfMatcher, IAnyOfMatcher, INoneOfMatcher

        /**
         * A unique sequential index number assigned to each ,atch
         * @type number */
        uniqueId : static int

        /**
         * Get the matcher id
         * @type number
         * @name entitas.Matcher#id */
        prop readonly id : string

        /**
         * A list of the component ordinals that this matches
         * @type Array<number>
         * @name entitas.Matcher#indices */
        prop readonly indices : array of int
            get
                if _indices == null
                    _indices = mergeIndices()
                return _indices

        /**
         * A unique sequential index number assigned to each entity at creation
         * @type number
         * @name entitas.Matcher#allOfIndices */
        prop readonly allOfIndices : array of int

        /**
         * A unique sequential index number assigned to each entity at creation
         * @type number
         * @name entitas.Matcher#anyOfIndices */
        prop readonly anyOfIndices : array of int

        /**
         * A unique sequential index number assigned to each entity at creation
         * @type number
         * @name entitas.Matcher#noneOfIndices */
        prop readonly noneOfIndices : array of int

        _indices : array of int
        _toStringCache : string

        construct()
            _id = (Matcher.uniqueId++).to_string()

        /**
         * Matches anyOf the components/indices specified
         * @params Array<entitas.IMatcher>|Array<number> args
         * @returns entitas.Matcher
         */
        def anyOf(args : array of int) : IAnyOfMatcher
            _anyOfIndices = Matcher.distinctIndices(args)
            _indices = null
            return this

        /**
         * Matches noneOf the components/indices specified
         * @params Array<entitas.IMatcher>|Array<number> args
         * @returns entitas.Matcher
         */
        def noneOf(args : array of int) : INoneOfMatcher
            _noneOfIndices = Matcher.distinctIndices(args)
            _indices = null
            return this

        /**
         * Check if the entity matches this matcher
         * @param entitas.Entity entity
         * @returns boolean
         */
        def matches(entity : Entity) : bool
            var matchesAllOf = _allOfIndices == null ? true : entity.hasComponents(_allOfIndices)
            var matchesAnyOf = _anyOfIndices == null ? true : entity.hasAnyComponent(_anyOfIndices)
            var matchesNoneOf = _noneOfIndices == null ? true : !entity.hasAnyComponent(_noneOfIndices)
            return matchesAllOf && matchesAnyOf && matchesNoneOf

        /**
         * Merge list of component indices
         * @returns Array<number>
         */
        def mergeIndices() : array of int

            var indicesList = new list of int
            if _allOfIndices != null
                for var i in _allOfIndices
                    indicesList.add(i)

            if _anyOfIndices != null
                for var i in _anyOfIndices
                    indicesList.add(i)

            if _noneOfIndices != null
                for var i in _noneOfIndices
                    indicesList.add(i)

            return Matcher.distinctIndices(listToArray(indicesList))

        /**
         * toString representation of this matcher
         * @returns string
         */
        def toString() : string
            if _toStringCache == null
                var sb = new StringBuilder()
                if _allOfIndices != null
                    Matcher.appendIndices(sb, "AllOf", _allOfIndices)

                if _anyOfIndices != null
                    if _allOfIndices != null
                        sb.append(".")

                    Matcher.appendIndices(sb, "AnyOf", _anyOfIndices)

                if _noneOfIndices != null
                    Matcher.appendIndices(sb, ".NoneOf", _noneOfIndices)

                _toStringCache = sb.str

            return _toStringCache

        def static listToArray(l : list of int) : array of int
            var a = new array of int[l.size]
            for var i=0 to (l.size-1)
                a[i] = l[i]
            return a

        /**
         * Get the set if distinct (non-duplicate) indices from a list
         * @param Array<number> indices
         * @returns Array<number>
         */
        def static distinctIndices(indices : array of int) : array of int
            var indicesSet = new Gee.HashSet of int
            var result = new list of int

            for var index in indices
                if !indicesSet.contains(index)
                    result.add(index)

                indicesSet.add(index)
            return listToArray(result)

        /**
         * Merge all the indices of a set of Matchers
         * @param Array<IMatcher> matchers
         * @returns Array<number>
         */
        def static merge(matchers : array of IMatcher) : array of int raises Exception
            var indices = new list of int

            for var matcher in matchers
                if matcher.indices.length != 1
                    raise new Exception.MatcherException(matcher.toString())

                indices.add(matcher.indices[0])
            return listToArray(indices)

        /**
         * Matches allOf the components/indices specified
         * @params Array<entitas.IMatcher>|Array<number> args
         * @returns entitas.Matcher
         */
         /*static IAllOfMatcher AllOf(int[] args) */
        def static AllOf(args : array of int) : IMatcher
            var matcher = new Matcher()
            matcher._allOfIndices = Matcher.distinctIndices(args)
            return matcher

        /**
         * Matches anyOf the components/indices specified
         * @params Array<entitas.IMatcher>|Array<number> args
         * @returns entitas.Matcher
         */
         /*static IAnyOfMatcher AnyOf(int[] args) */
        def static AnyOf(args : array of int) : IMatcher
            var matcher = new Matcher()
            matcher._anyOfIndices = Matcher.distinctIndices(args)
            return matcher

        def static appendIndices(sb : StringBuilder, prefix : string, indexArray : array of int)
            var SEPERATOR = ", "
            sb.append(prefix)
            sb.append("(")
            var lastSeperator = indexArray.length - 1
            for var i = 0 to lastSeperator
                sb.append(indexArray[i].to_string())
                if i < lastSeperator
                    sb.append(SEPERATOR)

            sb.append(")")
