/*
OnExit script for Amun-her Khepeshef's Scion of War 60-ft Aura (bnd_vest_amunsox)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    object oTarget = GetExitingObject();
    if (!GetIsObjectValid(oTarget) || oTarget == oBinder)
        return;

    if (!GetIsObjectValid(oBinder) || GetLocalObject(oTarget, "AmunScionAuraSource") == oBinder)
    {
        DeleteLocalInt(oTarget, "AmunScionAuraBonus");
        DeleteLocalObject(oTarget, "AmunScionAuraSource");
    }
}
