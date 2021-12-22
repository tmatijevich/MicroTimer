
FUNCTION_BLOCK MicroTimer (*Timer with microsecond resolution*)
	VAR_INPUT
		Duration : UDINT; (*[us] Timer duration, modifications ignored if Done*)
		Start : BOOL; (*Start timer*)
	END_VAR
	VAR_OUTPUT
		ElapsedTime : UDINT; (*[us] Elapsed time*)
		Done : BOOL; (*Set once elapsed time reaches timer duration*)
	END_VAR
	VAR
		RTInfo_0 : RTInfo; (*Runtime information of software object*)
		PreviousState : BOOL; (*Store the previous start input*)
		PreviousIOTime : DINT; (*[us] Store previous start time of task class*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK UTON (*Redefinition of TON with millisecond resolution*)
	VAR_INPUT
		IN : BOOL; (*Input signal*)
		PT : TIME; (*Delay time*)
	END_VAR
	VAR_OUTPUT
		Q : BOOL; (*IN delayed by PT when high*)
		ET : TIME; (*Elapsed time*)
	END_VAR
	VAR
		MicroTimer_0 : MicroTimer; (*Internal function block call*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK UTOF (*Redefinition of TOF with millisecond resolution*)
	VAR_INPUT
		IN : BOOL; (*Input signal*)
		PT : TIME; (*Delay time*)
	END_VAR
	VAR_OUTPUT
		Q : BOOL; (*IN delayed by PT when low*)
		ET : TIME; (*Elapsed time*)
	END_VAR
	VAR
		MicroTimer_0 : MicroTimer; (*Internal function block call*)
		PreviousState : BOOL; (*Store previous input value*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK UTP (*Redefinition of TP with millisecond resolution*)
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
		PreviousState : BOOL; (*Store previous input value*)
	END_VAR
END_FUNCTION_BLOCK
