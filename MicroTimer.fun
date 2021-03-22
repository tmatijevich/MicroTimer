
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
		RTInfo_0 : RTInfo := (enable:=TRUE); (*FB instance to return runtime information on the current software object*)
		CycleTime : UDINT := 1000; (*[us] Default to a conservative value until RTInfo response (typically 1 scan)*)
		State : USINT; (*Internal state control variable*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK UTON (*TON() FB with microsecond accuracy defined by the current task class*)
	VAR_INPUT
		IN : BOOL; (*Input signal*)
		PT : TIME; (*Delay time*)
	END_VAR
	VAR_OUTPUT
		Q : BOOL; (*Output signal, the rising edge of the input is delayed by PT*)
		ET : TIME; (*Elapsed time*)
	END_VAR
	VAR
		MicroTimer_0 : MicroTimer; (*Internal function block call*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK UTOF (*TOF() FB with microsecond accuracy defined by the current task class*)
	VAR_INPUT
		IN : BOOL; (*Input signal*)
		PT : TIME; (*Delay time*)
	END_VAR
	VAR_OUTPUT
		Q : BOOL; (*Falling edge of the input signal is delayed by PT*)
		ET : TIME; (*Elapsed time*)
	END_VAR
	VAR
		MicroTimer_0 : MicroTimer; (*Internal function block call*)
		State : USINT; (*Internal state control variable*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK UTP (*TP() FB with microsecond precision defined by the current task class*)
	VAR_INPUT
		IN : BOOL; (*Input signal*)
		PT : TIME; (*Pulse time*)
	END_VAR
	VAR_OUTPUT
		Q : BOOL; (*Output signal*)
		ET : TIME; (*Elapsed time*)
	END_VAR
	VAR
		MicroTimer_0 : MicroTimer; (*Internal function block call*)
		State : USINT; (*Internal state control variable*)
	END_VAR
END_FUNCTION_BLOCK
