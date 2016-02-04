[indent=4]
namespace Bosco

    class Timer : DarkMatter

        _startTicks : int
        _pausedTicks : int
        _paused : bool
        _started : bool

        construct()
            _startTicks = 0
            _pausedTicks = 0
            _paused = false
            _started = false

        def start()
            _started = true
            _paused = false
            _startTicks = (int)SDL.Timer.get_ticks()
            _pausedTicks = 0

        def stop()
            _started = false
            _paused = false
            _startTicks = 0
            _pausedTicks = 0

        def pause()
            if _started && !_paused
                _paused = true
                _pausedTicks = (int)SDL.Timer.get_ticks() - _startTicks
                _startTicks = 0

        def unpause()
            if _started && _paused
                _paused = true
                _startTicks = (int)SDL.Timer.get_ticks() - _pausedTicks
                _pausedTicks = 0

        def getTicks() : int
            time : int = 0
            if _started
                if _paused
                    time = _pausedTicks
                else
                    time = (int)SDL.Timer.get_ticks() - _startTicks
            return time

        def isStarted() : bool
            return _startTicks != 0

        def isPaused() : bool
            return _paused && _started
