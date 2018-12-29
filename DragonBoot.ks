core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
clearscreen.
Print "Dragon SW V1.1".
Wait 1.
Print "Dragon is GO for Flight".
Wait 6.
clearscreen.
Print "Waiting for Booster Sep...".
until ship:apoapsis > 60000 {
    wait 1.
    If ABORT{
        lock steering to up.
        lock throttle to 1.
        Print "ABORTED".
        runpath("0:/DragonAbort.ks").
        }
}
runpath("0:/dragon2.ks").