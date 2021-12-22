(******************************************************************************
 * File:     MicroTimer\MicroTimer.st 
 * Author:   Tyler Matijevich
 * Date:     December 21, 2021/5:47 PM 
 ******************************************************************************
 * Description: Timer function blocks with microsecond resolution 
*******************************************************************************)

(* Timer with microsecond resolution *)
FUNCTION_BLOCK MicroTimer

	(* Determine the cycle time from brsystem *)
	RTInfo_0(enable := TRUE);
	
	(* Determine the elapsed time *)
	IF Start = FALSE THEN
		ElapsedTime := 0;
	ELSIF Start AND PreviousState = TRUE AND ElapsedTime < Duration AND Done = FALSE AND AsIOTimeCyclicStart() <> PreviousIOTime THEN
		(* 1. Start counting one scan after the rising edge of start (function block must be called at least once per task class) *)
		(* 2. Count as long as within input time duration *)
		(* 3. Count as long as new scan *)
		ElapsedTime := ElapsedTime + RTInfo_0.cycle_time;
	END_IF
	
	(* Confirm when complete *)
	Done := (ElapsedTime >= Duration OR Done) AND Start;
	
	(* Update variables for next scan *)
	PreviousIOTime 	:= AsIOTimeCyclicStart();
	PreviousState 	:= Start;

END_FUNCTION_BLOCK

(* Redefinition of TON with millisecond resolution *)
FUNCTION_BLOCK UTON

	MicroTimer_0.Start 		:= IN;
	MicroTimer_0.Duration 	:= TIME_TO_UDINT(PT) * 1000; // ms to us
	MicroTimer_0();
	(* The basic TIME data type has a resolution of one millisecond *)
	ET 						:= MIN(PT, LREAL_TO_TIME(UDINT_TO_LREAL(MicroTimer_0.ElapsedTime) / 1000.0));
	Q 						:= MicroTimer_0.Done;

END_FUNCTION_BLOCK

(* Redefinition of TOF with millisecond resolution *)
FUNCTION_BLOCK UTOF
	
	IF IN THEN
		MicroTimer_0.Start := FALSE;
	ELSIF IN = FALSE AND PreviousState THEN
		MicroTimer_0.Start := TRUE;
	END_IF
	MicroTimer_0(Duration := TIME_TO_UDINT(PT) * 1000);
	
	Q := NOT MicroTimer_0.Done;
	
	(* Saturate the elapsed time *)
	ET := MIN(PT, LREAL_TO_TIME(UDINT_TO_LREAL(MicroTimer_0.ElapsedTime) / 1000.0));
	
	(* Update previous state *)
	PreviousState := IN;

END_FUNCTION_BLOCK

(* Redefinition of TP with millisecond resolution *)
FUNCTION_BLOCK UTP
	
	(* Start and stop timer *)
	IF IN AND PreviousState = FALSE THEN
		MicroTimer_0.Start := TRUE;
	END_IF
	MicroTimer_0(Duration := TIME_TO_UDINT(PT) * 1000);
	IF MicroTimer_0.Done AND IN = FALSE THEN
		MicroTimer_0.Start := FALSE;
	END_IF
	
	(* Evaluate output and elapsed time *)
	Q 	:= MicroTimer_0.Start AND NOT MicroTimer_0.Done;
	ET 	:= MIN(PT, LREAL_TO_TIME(UDINT_TO_LREAL(MicroTimer_0.ElapsedTime) / 1000.0));
	
	(* Update previous state *)
	PreviousState := IN;

END_FUNCTION_BLOCK