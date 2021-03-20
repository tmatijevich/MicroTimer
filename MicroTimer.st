
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

(* TON() FB with microsecond accuracy defined by the current task class *)
FUNCTION_BLOCK UTON

	MicroTimer_0.Input 			:= IN;
	MicroTimer_0.TimeDuration 	:= TIME_TO_UDINT(PT) * 1000; // ms to us
	MicroTimer_0();
	Q 							:= MicroTimer_0.TimeDone;
	ET 							:= REAL_TO_TIME(UDINT_TO_REAL(MicroTimer_0.ElapsedTime) * 1.0e-03); // Perform floating point division

END_FUNCTION_BLOCK