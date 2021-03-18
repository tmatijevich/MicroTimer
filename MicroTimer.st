
(* Timer with microsecond accuracy defined by the current task class *)
FUNCTION_BLOCK MicroTimer

	RTInfo_0(enable := TRUE);
	IF RTInfo_0.status = ERR_OK THEN
		CycleTime := RTInfo_0.cycle_time;
	END_IF
	IF Input = FALSE THEN
		ElapsedTime := 0;
	ELSIF (ElapsedTime < TimeDuration) AND (TimeDone = FALSE) THEN
		ElapsedTime := ElapsedTime + CycleTime;
	END_IF
	
	TimeDone := (ElapsedTime >= TimeDuration OR TimeDone) AND Input;

END_FUNCTION_BLOCK