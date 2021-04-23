(*
 * File: MicroTimer.st
 * Date: 2021-03-18
 * Author: Tyler Matijevich
 *)

(* Timer with task-class cycle time accuracy *)
FUNCTION_BLOCK MicroTimer

	// Determine the cycle time from brsystem
	RTInfo_0();
	IF RTInfo_0.status = ERR_OK THEN
		RTInfo_0.enable := FALSE;
		CycleTime 		:= RTInfo_0.cycle_time;
	END_IF
	
	// Determine if this is a new scan
	RTC_gettime(ADR(RealTimeClock));
	IF RealTimeClock.second = RealTimeClockPrevious.second AND RealTimeClock.millisec = RealTimeClockPrevious.millisec AND RealTimeClock.microsec = RealTimeClockPrevious.microsec THEN
		NewScan := FALSE;
	ELSE
		NewScan := TRUE;
	END_IF
	RealTimeClockPrevious := RealTimeClock;
	
	IF Input = FALSE THEN
		State := 0;
	END_IF
	
	CASE State OF
		// OFF
		0:
			ElapsedTime := 0;
			IF Input THEN
				State := 10; // Start counting the scan after the rising edge of Input
			END_IF
			
		// DELAY
		10:
			// Do not increment time if duration changes after done status
			IF (ElapsedTime < TimeDuration) AND (TimeDone = FALSE) AND NewScan THEN
				ElapsedTime := ElapsedTime + CycleTime;
			END_IF
		
	END_CASE
	
	// Set the output status
	TimeDone := (ElapsedTime >= TimeDuration OR TimeDone) AND Input; // Do not reset done status if already reached duration (i.e. If TimeDuration is increased after TimeDone)

END_FUNCTION_BLOCK

(* TON re-definition with task-class cycle time accuracy *)
FUNCTION_BLOCK UTON

	MicroTimer_0.Input 			:= IN;
	MicroTimer_0.TimeDuration 	:= TIME_TO_UDINT(PT) * 1000; // ms to us
	MicroTimer_0();
	Q 							:= MicroTimer_0.TimeDone;
	IF MicroTimer_0.ElapsedTime > MicroTimer_0.TimeDuration THEN
		ET := PT;
	ELSE
		ET := REAL_TO_TIME(UDINT_TO_REAL(MicroTimer_0.ElapsedTime) / 1000); // Perform floating point division
	END_IF

END_FUNCTION_BLOCK

(* TOF re-definition with task-class cycle time accuracy *)
FUNCTION_BLOCK UTOF

	CASE State OF
		// OFF
		0:
			Q := FALSE;
			IF IN THEN
				MicroTimer_0(Input := FALSE); // Reset the timer
				Q 		:= TRUE;
				State 	:= 10;
			END_IF
		
		// ON
		10:
			Q := TRUE;
			IF IN = FALSE THEN
				State 	:= 20;
				MicroTimer_0(TimeDuration := TIME_TO_UDINT(PT) * 1000, Input := TRUE);
				Q  		:= NOT MicroTimer_0.TimeDone; // Reset if time duration is zero
			END_IF
		
		// DELAY
		20:
			IF IN THEN
				State 	:= 10; // Go back to ON
				MicroTimer_0(Input := FALSE); // Reset the timer
				Q 		:= TRUE;
			ELSE
				MicroTimer_0(TimeDuration := TIME_TO_UDINT(PT) * 1000, Input := TRUE);
				IF MicroTimer_0.TimeDone THEN
					State 	:= 0; // Go to OFF
					Q 		:= FALSE;
				END_IF
			END_IF
		
	END_CASE
	
	// Saturate the elapsed time
	IF MicroTimer_0.ElapsedTime > TIME_TO_UDINT(PT) * 1000 THEN
		ET := PT;
	ELSE
		ET := REAL_TO_TIME(UDINT_TO_REAL(MicroTimer_0.ElapsedTime) / 1000); // Perform floating point division
	END_IF

END_FUNCTION_BLOCK

(* TP re-definition with task-class cycle time accuracy *)
FUNCTION_BLOCK UTP

	CASE State OF
		// OFF
		0:
			// Reset the output and timer
			Q := FALSE;
			MicroTimer_0(Input := FALSE);
			
			IF IN THEN // From off to on
				// Start the timer, set the output, and transition to PULSE
				MicroTimer_0(TimeDuration := TIME_TO_UDINT(PT) * 1000, Input := TRUE);
				Q 		:= TRUE;
				State 	:= 10;
			END_IF
		
		// PULSE
		10:
			// Update the timer
			MicroTimer_0(TimeDuration := TIME_TO_UDINT(PT) * 1000, Input := TRUE);
			// Wait for the pulse to finish
			IF MicroTimer_0.TimeDone THEN
				// Reset the output
				Q := FALSE;
				// Go to RESET
				State := 20;
			END_IF
			
		// RESET
		20:
			IF IN = FALSE THEN
				// Reset the timer and return to OFF
				MicroTimer_0(Input := FALSE);
				State := 0;
			END_IF
			
	END_CASE
	
	// Saturate the elapsed time
	IF MicroTimer_0.ElapsedTime > TIME_TO_UDINT(PT) * 1000 THEN
		ET := PT;
	ELSE
		ET := REAL_TO_TIME(UDINT_TO_REAL(MicroTimer_0.ElapsedTime) / 1000); // Perform floating point division
	END_IF

END_FUNCTION_BLOCK