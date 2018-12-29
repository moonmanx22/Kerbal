Set the boot program on Upper Stage to DragonBoot.ks
Set the boot program on booster to FalconBoot.ks

Select the Boosters Terminal and Press "Return" to initiate Countdown.


By defualt the programs are set to follow the booster, select the Remote Guidance Unit on the booster and choose "Control form here".

To follow upper stage change code as shown below:

In falconbooster.ks change:
FROM:
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
TO:
 function main {
    doSystemsCheck().
    SET genoutputmessage TO "".
    doCountdown().
    doAscentRecover().
    //doAscentExpend().
    //doAscentRecoverPolar().
    //doBoostback().
    //doEntryBurn().
    //doHoverSlam().
    //doSafingSequence().
 }

In dragon2.ks change:
FROM:
 function Main{
    doBurn().
    //doCircularization().
    //doDeploy().
    //doDeOrbit().
    //doEntry().
    //doHoverSlam().
 }
TO:
 function Main{
    doBurn().
    doCircularization().
    doDeploy().
    //doDeOrbit().
    //doEntry().
    //doHoverSlam().
 }
