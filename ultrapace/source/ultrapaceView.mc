using Toybox.WatchUi as Ui;

class ultrapaceView extends Ui.SimpleDataField {

    //! Set the label of the data field here.
    function initialize() {
        label = "Pace 100k/14h";
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and return it in this method.
    function compute(info) {
    	if (info.elapsedDistance == null || info.elapsedTime == 0) {
    		return "--";
    	}
    	
        // See Activity.Info in the documentation for available information.
        var metersLeft  = 100000 - info.elapsedDistance;
        var minutesLeft = 14*60.0 - info.elapsedTime / 1000.0 / 60;
        
        if (metersLeft > 0 && minutesLeft >= 0) {
        	return minutesLeft*1000.0 / metersLeft;
        }
        return 0.0;
    }

}