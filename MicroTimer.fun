
FUNCTION_BLOCK MicroTimer (*Timer with microsecond accuracy defined by the current task class*)
	VAR_INPUT
		TimeDuration : UDINT; (*[us] Specify the duration of the timer, does not update when TimeDone*)
		Input : BOOL; (*Set to start the timer, reset to restart timer*)
	END_VAR
	VAR_OUTPUT
		ElapsedTime : UDINT; (*[us] Time since Input, halts when duration is reached*)
		TimeDone : BOOL; (*Set TRUE once the elapsed time has reached the duration, reset with Input*)
	END_VAR
	VAR
		RTInfo_0 : RTInfo; (*FB instance to return runtime information on the current software object*)
		CycleTime : UDINT := 1000; (*[us] Default to a conservative value until RTInfo response (typically 1 scan)*)
	END_VAR
END_FUNCTION_BLOCK
