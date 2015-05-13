using Toybox.Application as App;
using Toybox.Time as Time;

class pomodoroApp extends App.AppBase {
	var logic;
	
	function initialize() {
		logic = new pomodoroLogic();
	}

    //! onStart() is called on application start up
    function onStart() {
    	// try to retrieve today's pomodoro count
		var value = getProperty(getTodayKey());
		if (value != null) {
			System.println("State loaded: " + value);
			logic.setDoneToday(value);
		}
		else {
			clearProperties();
		}
    }

    //! onStop() is called when your application is exiting
    function onStop() {
		saveDoneToday();
    }
    
    function saveDoneToday() {
    	setProperty(getTodayKey(), logic.getDoneToday());
	}    	

	// return integer 
	function getTodayKey() {
		var t = Time.Gregorian.info(Time.today(), Time.Gregorian.FORMAT_SHORT);
		return Lang.format("$1$-$2$-$3$", [t.year, t.month, t.day]);
	}

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new pomodoroView(logic), new pomodoroInput(logic) ];
    }

}