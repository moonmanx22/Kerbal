function Main{
    doBurn().
    //doCircularization().
    //doDeploy().
    //doDeOrbit().
    //doEntry().
    //doHoverSlam().
}


function doBurn {
    clearscreen.
    wait 2.
    Print "Raising Apoapsis".
    lock steering TO HEADING(90,30).
    lock throttle TO 1.
    Wait UNTIL SHIP:APOAPSIS > 120000.  //Remember, all altitudes will be in meters, not kilometers
    lock throttle TO 0.
    wait 5.
    
}

function doCircularization {
    clearscreen.
    STAGE.
    Print "Circularizing".
    local circ is list(0).
    set circ to improveConverge(circ, eccentricityScore@).
    wait until altitude > 70000.
    executeManeuver(list(time:seconds + eta:apoapsis, 0, 0, circ[0])).
}

function eccentricityScore {
  parameter data.
  local mnv is node(time:seconds + eta:apoapsis, 0, 0, data[0]).
  addManeuverToFlightPlan(mnv).
  local result is mnv:orbit:eccentricity.
  removeManeuverFromFlightPlan(mnv).
  return result.
}

 function improveConverge {
  parameter data, scoreFunction.
  for stepSize in list(100, 10, 1) {
    until false {
      local oldScore is scoreFunction(data).
      set data to improve(data, stepSize, scoreFunction).
      if oldScore <= scoreFunction(data) {
        break.
      }
    }
  }
  return data.
}

 function improve {
  parameter data, stepSize, scoreFunction.
  local scoreToBeat is scoreFunction(data).
  local bestCandidate is data.
  local candidates is list().
  local index is 0.
  until index >= data:length {
    local incCandidate is data:copy().
    local decCandidate is data:copy().
    set incCandidate[index] to incCandidate[index] + stepSize.
    set decCandidate[index] to decCandidate[index] - stepSize.
    candidates:add(incCandidate).
    candidates:add(decCandidate).
    set index to index + 1.
  }
  for candidate in candidates {
    local candidateScore is scoreFunction(candidate).
    if candidateScore < scoreToBeat {
      set scoreToBeat to candidateScore.
      set bestCandidate to candidate.
    }
  }
  return bestCandidate.
}

function executeManeuver {
  parameter mList.
  local mnv is node(mList[0], mList[1], mList[2], mList[3]).
  addManeuverToFlightPlan(mnv).
  local startTime is calculateStartTime(mnv).
  wait until time:seconds > startTime - 15.
  lockSteeringAtManeuverTarget(mnv).
  wait until time:seconds > startTime.
  lock throttle to 1.
  until isManeuverComplete(mnv) {
    doAutoStage().
  }
  lock throttle to 0.
  unlock steering.
  removeManeuverFromFlightPlan(mnv).
  RCS off.
  clearscreen.
}

function addManeuverToFlightPlan {
  parameter mnv.
  add mnv.
}

function calculateStartTime {
  parameter mnv.
  return time:seconds + mnv:eta - maneuverBurnTime(mnv) / 2.
}

function maneuverBurnTime {
  parameter mnv.
  local dV is mnv:deltaV:mag.
  local g0 is 9.80665.
  local isp is 0.

  list engines in myEngines.
  for en in myEngines {
    if en:ignition and not en:flameout {
      set isp to isp + (en:isp * (en:maxThrust / ship:maxThrust)).
    }
  }

  local mf is ship:mass / constant():e^(dV / (isp * g0)).
  local fuelFlow is ship:maxThrust / (isp * g0).
  local t is (ship:mass - mf) / fuelFlow.

  return t.
}

function lockSteeringAtManeuverTarget {
  parameter mnv.
  lock steering to mnv:burnvector.
}

function isManeuverComplete {
  parameter mnv.
  if not(defined originalVector) or originalVector = -1 {
    declare global originalVector to mnv:burnvector.
  }
  if vang(originalVector, mnv:burnvector) > 90 {
    declare global originalVector to -1.
    return true.
  }
  return false.
}

function removeManeuverFromFlightPlan {
  parameter mnv.
  remove mnv.
}

function doDeploy {
    clearscreen.
    wait 1.
    AG6 on.
    Print "Craft in Stable Orbit...".
    Wait 2.
    Print "All Systems Nominal...".
    Wait 5. 
    clearscreen.
    Print "Deploying Solar Panels and Coms".
    Wait 1.
    AG4 on.
    Wait 1.
    AG5 on.
    Wait 1.
    clearscreen.
}

function doDeOrbit {

    RCS on.
    wait 1.
    Lock throttle to tVal.
    SET tVal TO 0.
    AG4 off.
    Wait 1.
    AG5 off.
    Wait 1.
    AG6 off.
    Wait 1.

    PRINT "PREPING FOR DE-ORBIT - " + time:clock AT(0,3).
    Wait 5.
    LOCK STEERING TO HEADING(270,0).
    Wait 15.
    SET tVal to 1.
    PRINT "DE-ORBIT BURN STARTED - " + time:clock AT(0,5).
    LOCK STEERING TO HEADING(270,0).
    Wait 10. //Fires all 5 engines for 10 seconds
    AG1 on.
    SET tVal to 0.
    PRINT "DE-ORBIT BURN COMPLETE - " + time:clock AT(0,7).
    WAIT 15.
    RCS ON.
    LOCK STEERING TO SHIP:SRFRETROGRADE. //Positions booster for re-entry

    BRAKES ON.
    Wait 10.


}

function doEntry {
  Lock Steering to SRFRETROGRADE.
  UNTIL SHIP:ALTITUDE < 7500 { //This is the re-entry burn. the booster fires its center engine to keep velocity below 700m/s
    IF SHIP:VELOCITY:SURFACE:MAG > 2050 {
            SET tVAL TO 0.7.
            PRINT "RE-ENTRY BURN STARTED - " + time:clock AT(0,15).
            WAIT 15.45.
            SET tVAL TO 0.
            PRINT "RE-ENTRY BURN SHUTDOWN - " + time:clock AT(0,17).        
        }
    }
}

function doAutoStage {
  if not(defined oldThrust) {
    global oldThrust is ship:availablethrust.
  }
  if ship:availablethrust < (oldThrust - 10) {
    stage. wait 1.
    global oldThrust is ship:availablethrust.
  }
}

function doHoverSlam{
    clearscreen.
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
        print "Landing Burn Started - " + time:clock.
        lock throttle to idealThrottle.

    WAIT UNTIL ship:verticalspeed > -0.01.
        print "Dragon has Landed" + time:clock.
        set ship:control:pilotmainthrottle to 0.
        rcs off.
        Brakes off.
        AG6 on.
          
}

main().