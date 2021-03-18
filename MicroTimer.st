
(* Timer with microsecond accuracy defined by the current task class *)
FUNCTION_BLOCK MicroTimer

	// Determine the cycle time from brsystem
	RTInfo_0();
	IF RTInfo_0.status = ERR_OK THEN
		RTInfo_0.enable := FALSE;
		CycleTime 		:= RTInfo_0.cycle_time;
	END_IF
	
	// Determine the elapsed time
	IF Input = FALSE THEN
		ElapsedTime := 0;
	ELSIF (ElapsedTime < TimeDuration) AND (TimeDone = FALSE) THEN // Do not increment time if duration changes after done status
		ElapsedTime := ElapsedTime + CycleTime;
	END_IF
	
	// Set the output status
	TimeDone := (ElapsedTime >= TimeDuration OR TimeDone) AND Input; // Do not reset done status if already reached duration

END_FUNCTION_BLOCK