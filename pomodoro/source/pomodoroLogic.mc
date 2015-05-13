using Toybox.Timer as Timer;
using Toybox.Time as Time;
using Toybox.Attention as Attention;
using Toybox.Application as App;

class pomodoroLogic {
	var view;
	var state;
	var timer;
	var started = null; // Moment object to save time started
	var done_today;
	var debug = false;
	
	enum {
		STATE_IDLE,
		STATE_WORKING,
		STATE_REST
	}
	
	function initialize() {
		state = STATE_IDLE;
		timer = new Timer.Timer();
		done_today = 0;
	}
	
	function setDoneToday(done) {
		done_today = done;
	}
	
	function getDoneToday() {
		return done_today;
	}

	function incrementDoneToday() {
		done_today++;
		var app = App.getApp();
		app.saveDoneToday();
	}
	
	// view must support those methods:
	// 1. setStateLabel
	// 2. setTimer
	function setView(_view) {
		view = _view;
	}
	
	function stateLabel() {
		if (state == STATE_IDLE) {
			return "idle";
		}
		else if (state == STATE_WORKING) {
			return "working";
		}
		else if (state == STATE_REST) {
			return "rest";
		}
		return "unknown";	
	}
	
	function stateColor() {
		if (state == STATE_IDLE) {
			return Graphics.COLOR_GREEN;
		}
		else if (state == STATE_WORKING) {
			return Graphics.COLOR_RED;
		}
		else if (state == STATE_REST) {
			return Graphics.COLOR_BLUE;
		}
		return Graphics.COLOR_WHITE;
	}
	
	// return duration left. If timer doesn't running, return null
	function duration() {
		if (state != STATE_WORKING && state != STATE_REST) {
			return null;
		}

		var seconds;
		if (debug) {
			seconds = 10;
		}
		else {
			seconds = state == STATE_WORKING ? 25*60 : 5*60;
		}
		var duration = new Time.Duration(seconds);
		var rest = Time.now().subtract(started);
		return duration.subtract(rest);
	}
	
	function getState() {
		return state;
 	}
 	
	function setState(new_state) {
		vibrateOnState(new_state);		
		state = new_state;
	}
	
	function vibrateOnState(state) {
		var vibes = [];
		if (state == STATE_WORKING) {
			vibes = [new Attention.VibeProfile(50, 100), new Attention.VibeProfile(10, 100)];
		}
		else if (state == STATE_REST) {
			vibes = [new Attention.VibeProfile(70, 100), new Attention.VibeProfile(50, 100)];
		}
		else if (state == STATE_IDLE) {
			vibes = [new Attention.VibeProfile(10, 100), new Attention.VibeProfile(20, 200),
					 new Attention.VibeProfile(30, 100)];
		}
		Attention.vibrate(vibes);
	}
	
	function startTimer() {
		if (started == null) {
        	timer.start(method(:onTimer), 500, true);
		}
        started = Time.now();
	}
	
	function stopTimer() {
		timer.stop();
		started = null;
	}	
	
	function onTimer() {
		var left = duration();
		
		if (left == null) {
			return;
		}
		
		// update countdown timer in view's label
		if (left.value() <= 0) {
			// timer overdue, shift to next state
			if (state == STATE_WORKING) {
				setState(STATE_REST);
				startTimer();
			}
			else {
				setState(STATE_IDLE);
				stopTimer();
				incrementDoneToday();
			}
		}
		view.update();		
	}
	
	function startPressed() {
		if (state == STATE_IDLE) {
			setState(STATE_WORKING);
			startTimer();
			return true;
		}
		else if (state == STATE_WORKING) {
			// go to rest state
			setState(STATE_REST);
			startTimer();
			return true;
		}
		else {
			setState(STATE_IDLE);
			stopTimer();
		}
		
		return false;
	}
	
	function cancelPressed() {
		if (state != STATE_IDLE) {
			setState(STATE_IDLE);
			stopTimer();
		}
		return true;
	}
}