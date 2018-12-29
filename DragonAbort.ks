

function doStablize {
    Clearscreen.
    Print "Flight Aborted".
    RCS ON.
    If SHIP:ALTITUDE < 500 {
        AG9 ON.
        Wait 0.1.
        lock Steering to UP.
        Lock Throttle to 1.
        Wait 5.
        Lock Steering to Heading (90,45).
        Wait 5.
        CHUTES ON.
        Lock Throttle to 0.
        doHoverSlam().
    }
    If SHIP:ALTITUDE > 500 {
        Lock Steering to SRFPROGRADE.
        Lock Throttle to 1.
        doEntry().
        doHoverSlam().
    }
    Wait 5.
}

function doEntry {
  Lock Steering to SRFRETROGRADE.
  UNTIL SHIP:ALTITUDE < 10000 { //This is the re-entry burn. the booster fires its center engine to keep velocity below 700m/s
    IF SHIP:VELOCITY:SURFACE:MAG > 600 {
            Lock Throttle TO 0.7.
            PRINT "RE-ENTRY BURN STARTED - " + time:clock AT(0,15).
            WAIT 5.
            Lock Throttle TO 0.
            AG7 ON.
            PRINT "RE-ENTRY BURN SHUTDOWN - " + time:clock AT(0,17).        
        }
    }
    Lock Throttle TO 0.
    Wait 5.
}

function doHoverSlam{
    clearscreen.
    AG7 ON.
    set radarOffset to 7.5.	 				// The value of alt:radar when landed (on gear)
    lock trueRadar to alt:radar - radarOffset.			// Offset radar to get distance from gear to ground
    lock g to constant:g * body:mass / body:radius^2.		// Gravity (m/s^2)
    lock maxDecel to (ship:availablethrust / ship:mass) - g.	// Maximum deceleration possible (m/s^2)
    lock stopDist to ship:verticalspeed^2 / (2 * maxDecel).		// The distance the burn will require
    lock idealThrottle to stopDist / trueRadar.			// Throttle required for perfect hoverslam
    lock impactTime to trueRadar / abs(ship:verticalspeed).		// Time until impact, used for landing gear


    WAIT UNTIL ship:verticalspeed < -1.
        print "Preparing for hoverslam...".
        rcs on.
        brakes on.
        lock steering to srfretrograde.
        when impactTime < 3 then {gear on.}

    WAIT UNTIL trueRadar < stopDist.
    AG8 ON.
        print "Landing Burn Started - " + time:clock.
        lock throttle to idealThrottle.

    WAIT UNTIL ship:verticalspeed > -0.01.
        print "Dragon has Landed" + time:clock.
        set ship:control:pilotmainthrottle to 0.
        rcs off.
        Brakes off.
        AG6 on.
          
}
doStablize().