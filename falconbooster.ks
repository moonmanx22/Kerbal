function main {
    doSystemsCheck().
    SET genoutputmessage TO "".
    doCountdown().
    doAscentRecover().
    //doAscentExpend().
    //doAscentRecoverPolar().
    doBoostback().
    doEntryBurn().
    doHoverSlam().
    doSafingSequence().
}


function doSystemsCheck {
    clearscreen.
    Print "Falcon Booster SW v1.1".
    Wait 2.
    Print "Running Systems Check".
    Wait 2.
    Print ".".
    Wait 0.2.
    Print "..".
    Wait 0.2.
    Print "...".
    Wait 0.2.
    Print "....".
    Wait 0.2.
    Print ".....".
    Wait 0.2.
    Print "......".
    Wait 0.2.
    Print ".......".
    Wait 1.
    Print "Systems Check Complete".
    Wait 2.
    Print "Falcon is GO for Flight".
    Wait 3.
    clearscreen.
    set ch to terminal:input:getchar().
    Wait until terminal:input:Return.
    Print "Falcon Booster is in Startup...".
    Wait 2.
    
}

function updateReadouts{  
    print "Altitude = "+round(SHIP:ALTITUDE,3)+"          " AT(0,3).
    print "Ground Speed = "+round(SHIP:GROUNDSPEED,3)+"          " AT(0,4).
    print "Vertical Speed = "+round(SHIP:VERTICALSPEED,3)+"          " AT(0,5).
    print "Air Speed = "+round(SHIP:AIRSPEED,3)+"          " AT(0,6).
    print genoutputmessage+"                           " AT(0,7).
    
}

function doCountdown{    
    set tVal to 1. //Sets throttle value to 1 now we can just update tVal

    PRINT "Counting down:".

    FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO { //This is our countdown loop, which cycles from 5 to 0

        PRINT "..." + countdown.

        WAIT 1. 
        LOCK THROTTLE TO tVal. //Now we can just update tVal
    }
    Wait 0.2.
    STAGE.
}

function doAscentRecover{
    wait 2.5.
    Stage.
    SET MYSTEER TO HEADING(90,90).//This sets our steering 90 degrees up and yawed to the compass
    CLEARSCREEN.
    Print "Booster in Recovery Mode".

    LOCK STEERING TO MYSTEER. // from now on we'll be able to change steering by just assigning a new value to MYSTEER

    UNTIL SHIP:APOAPSIS > 60000 { //Remember, all altitudes will be in meters, not kilometers


        updateReadouts(). //update all readouts

        IF SHIP:VELOCITY:SURFACE:MAG > 10 {
                GEAR OFF.
            }

            //For the initial ascent, we want our steering to be straight

            //up and rolled due east

            IF SHIP:VELOCITY:SURFACE:MAG < 100 {
                
                //heading of 90 degrees (east)

                SET MYSTEER TO HEADING(90,90).



            //Once we pass 100m/s, we want to pitch down five degrees

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 AND SHIP:VELOCITY:SURFACE:MAG < 250 {

                SET MYSTEER TO HEADING(90,85).
                PRINT "Pitching to 85 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            //Each successive IF statement checks to see if our velocity

            //is within a 100m/s block and adjusts our heading down another

            //ten degrees if so

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 250 AND SHIP:VELOCITY:SURFACE:MAG < 325 {

                SET MYSTEER TO HEADING(90,80).
                PRINT "Pitching to 80 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 325 AND SHIP:VELOCITY:SURFACE:MAG < 450 {

                SET MYSTEER TO HEADING(90,70).
                PRINT "Pitching to 70 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 450 AND SHIP:VELOCITY:SURFACE:MAG < 550 {

                SET MYSTEER TO HEADING(90,60).
                SET tVal TO 0.85.

                PRINT "Pitching to 60 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 550 AND SHIP:VELOCITY:SURFACE:MAG < 625 {

                SET MYSTEER TO HEADING(90,55).

                PRINT "Pitching to 55 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 625 AND SHIP:VELOCITY:SURFACE:MAG < 700 {

                SET MYSTEER TO HEADING(90,45).
                SET tVal TO 0.75.

                PRINT "Pitching to 45 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 700 AND SHIP:VELOCITY:SURFACE:MAG < 800 {

                SET MYSTEER TO HEADING(90,40).

                PRINT "Pitching to 40 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            //Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait

            //for the main loop to recognize that our apoapsis is above 100km

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 800 {
                
                SET tVal TO 0.50.
                PRINT "Escape Tower Jettison" AT(0,15).

                AG9 on.

                SET MYSTEER TO HEADING(90,40).



            }



    }
    clearscreen.
    PRINT "MECO - " + time:clock AT (0,1).
    SET tVal TO 0.
    RCS on.
    WAIT 1.
    STAGE.
    WAIT 1.
    Lock steering to heading (90,90).
    Wait 9.
     
}

function doAscentRecoverPolar{
    SET MYSTEER TO HEADING(0,90).//This sets our steering 90 degrees up and yawed to the compass
    CLEARSCREEN.
    Print "Booster in Recovery Mode".

    LOCK STEERING TO MYSTEER. // from now on we'll be able to change steering by just assigning a new value to MYSTEER

    UNTIL SHIP:APOAPSIS > 60000 { //Remember, all altitudes will be in meters, not kilometers


        updateReadouts(). //update all readouts

        IF SHIP:VELOCITY:SURFACE:MAG > 10 {
                GEAR OFF.
            }

            //For the initial ascent, we want our steering to be straight

            //up and rolled due east

            IF SHIP:VELOCITY:SURFACE:MAG < 100 {
                
                //heading of 90 degrees (east)

                SET MYSTEER TO HEADING(350,90).



            //Once we pass 100m/s, we want to pitch down five degrees

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 AND SHIP:VELOCITY:SURFACE:MAG < 250 {

                SET MYSTEER TO HEADING(350,85).
                PRINT "Pitching to 85 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            //Each successive IF statement checks to see if our velocity

            //is within a 100m/s block and adjusts our heading down another

            //ten degrees if so

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 250 AND SHIP:VELOCITY:SURFACE:MAG < 325 {

                SET MYSTEER TO HEADING(355,80).
                PRINT "Pitching to 80 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 325 AND SHIP:VELOCITY:SURFACE:MAG < 450 {

                SET MYSTEER TO HEADING(355,70).
                PRINT "Pitching to 70 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 450 AND SHIP:VELOCITY:SURFACE:MAG < 550 {

                SET MYSTEER TO HEADING(0,60).
                SET tVal TO 0.85.

                PRINT "Pitching to 60 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 550 AND SHIP:VELOCITY:SURFACE:MAG < 625 {

                SET MYSTEER TO HEADING(0,55).

                PRINT "Pitching to 55 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 625 AND SHIP:VELOCITY:SURFACE:MAG < 700 {

                SET MYSTEER TO HEADING(0,45).
                SET tVal TO 0.75.

                PRINT "Pitching to 45 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 700 AND SHIP:VELOCITY:SURFACE:MAG < 800 {

                SET MYSTEER TO HEADING(0,40).

                PRINT "Pitching to 40 degrees" AT(0,15).

                PRINT ROUND(SHIP:APOAPSIS,0) + " - Apoapsis" AT (0,16).



            //Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait

            //for the main loop to recognize that our apoapsis is above 100km

            } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 800 {
                
                SET tVal TO 0.50.
                PRINT "Escape Tower Jettison" AT(0,15).

                AG9 on.

                SET MYSTEER TO HEADING(0,40).



            }



    }
    clearscreen.
    PRINT "MECO - " + time:clock AT (0,1).
    SET tVal TO 0.
    RCS on.
    WAIT 1.
    STAGE.
    WAIT 1.
    Lock steering to HEADING (0,90).
    WAIT 5.
   
}

function doAscentExpend {
    clearscreen.
    Print "Booster in Expendable Mode".
    UNTIL SHIP:APOAPSIS > 50000 { //Remember, all altitudes will be in meters, not kilometers
        updateReadouts(). //update all readouts
        lock targetPitch to 90 - .5 * alt:radar^0.43.
        set targetDirection to 90.
        lock steering to heading(targetDirection, targetPitch).
    }
    UNTIL SHIP:APOAPSIS > 200000 {
        updateReadouts(). //update all readouts
        set tVal to 0.5.
        lock targetPitch to 90 - .601 * alt:radar^0.43.
        set targetDirection to 90.
        lock steering to heading(targetDirection, targetPitch).
    }
    set tVAL to 0.
    wait 1.
    lock steering to prograde.
    wait 1.
    STAGE.
}

function doBoostback{
    SET tVal TO 0.
    AG1 on.


    PRINT "PREPING FOR BOOSTBACK - " + time:clock AT(0,3).
    LOCK STEERING TO HEADING(270,0).
    Wait 8.
    SET tVal to 0.2. //Ignite center engine at low thrust to help stablize booster
    Wait 17.
    SET tVal to 1.
    PRINT "BOOSTBACK BURN STARTED - " + time:clock AT(0,5).
    AG1 off.
    LOCK STEERING TO HEADING(270,0).
    Wait 20. //Fires all 5 engines for 20 seconds
    AG1 on.
    SET tVal to 0.
    PRINT "BOOSTBACK BURN COMPLETE - " + time:clock AT(0,7).
    Wait 5.
    LOCK STEERING TO HEADING(90,90).
    WAIT 15.
    RCS ON.
    LOCK STEERING TO SRFRETROGRADE. //Positions booster for re-entry

    BRAKES ON.
    AG1 off.
    Wait 10.
}

function doEntryBurn{
    Lock THROTTLE to tVAL.
    Set tVAL to 0.
    Lock Steering to SRFRETROGRADE.
    UNTIL SHIP:ALTITUDE < 9000 { //This is the re-entry burn. the booster fires its center engine to keep velocity below 700m/s
    IF SHIP:VELOCITY:SURFACE:MAG > 785 {
            SET tVAL TO 1.
            PRINT "RE-ENTRY BURN STARTED - " + time:clock AT(0,15).
            WAIT 9.
            SET tVAL TO 0.
            PRINT "RE-ENTRY BURN SHUTDOWN - " + time:clock AT(0,17).        
        }
    }
}

function doHoverSlam{
    AG1 on.
    clearscreen.
    set radarOffset to 24.245.	 				// The value of alt:radar when landed (on gear)
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
        print "Landing Burn Started - " + time:clock.
        lock throttle to idealThrottle.

    WAIT UNTIL ship:verticalspeed > -0.01.
        CLEARSCREEN.
        print "Falcon has Landed " + time:clock.
        set ship:control:pilotmainthrottle to 0.
        rcs off.
            Brakes off.
            AG2 on.
            SET X TO FALSE.
}

function doSafingSequence {
    Clearscreen.
    wait 5.
    Print "Falcon Booster Safing Sequence Initiated".
    Wait 2.
    PRINT "Booster Health Check..." at (0,3).
    Wait 1.

    FROM {local countdown is 1.} UNTIL countdown = 101 STEP {SET countdown to countdown + 1.} DO { //This is our countdown loop, which cycles from 5 to 0

        PRINT countdown + " %" at (0,4).
        wait 0.1.
    }
    wait 0.5.
    clearscreen.
    Print "Purging Fuel Tanks".
    Wait 1. 
    AG3 on.
    wait 1.
    Set Throttle to 1.
    until Ship:LIQUIDFUEL = 0{
        Print round(Ship:LIQUIDFUEL, 1) + " Liquid Fuel Remaining" at (0,4).
        Print round(Ship:OXIDIZER, 1) + " Oxidizer Remaining" at (0,5).
    }
    WAIT UNTIL SHIP:LIQUIDFUEL =0.
    AG3 off.
    Wait 2.
    Print "Flacon Booster Safed".
    wait 2.
    clearscreen.
    Print "Booster in Recovery Standby Mode.".
}


main().

