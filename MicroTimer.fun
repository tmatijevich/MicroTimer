
FUNCTION_BLOCK MicroTimer (*Timer with microsecond accuracy defined by the current task class*)
	VAR_INPUT
		TimeDuration : UDINT;
		Input : BOOL;
	END_VAR
	VAR_OUTPUT
		ElapsedTime : UDINT;
		TimeDone : BOOL;
	END_VAR
	VAR
		RTInfo_0 : RTInfo;
		CycleTime : UDINT;
	END_VAR
END_FUNCTION_BLOCK
