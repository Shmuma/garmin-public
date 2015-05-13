using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;

class pomodoroView extends Ui.View {
	var logic;
	var label_state;
	var label_time;
	var label_done;
	
	function initialize(_logic) {
	    logic = _logic;
	    logic.setView(self);
	}

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
		label_state = View.findDrawableById("label_state");
		label_time = View.findDrawableById("label_time");
		label_done = View.findDrawableById("label_done");
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	update();
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        setStateLabel(logic.stateLabel());
        setTime(logic.duration(), logic.getState());
        setDoneToday(logic.getDoneToday());
        View.onUpdate(dc);
     }
    
    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

	function setStateLabel(label) {
		label_state.setText(label);
	}
	
	function setTime(duration, state) {
		if (duration == null) {
			label_time.setText("_:_");
		}
		else {
			var val = duration.value();
			label_time.setText(Lang.format("$1$:$2$", [val / 60, (val % 60).format("%02d")]));
		}
		label_time.setColor(logic.stateColor());		
	}		
	
	function setDoneToday(done) {
		label_done.setText("done: " + done);
	}
	
	function update() {
		Ui.requestUpdate();
	}
}

class pomodoroInput extends Ui.InputDelegate {
	var logic;
	
	function initialize(_logic) {
		logic = _logic;
	}

	function onKey(key) {
		if (key.getKey() == Ui.KEY_ENTER) {
			if (logic.startPressed()) {
				Ui.requestUpdate();
			}
			return true;
		}
		return false;
	}
}