/*
OnEnter script for Tkhaluuljin's Aura of Madness (bnd_vest_tkhalen)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oBinder) ||
        !GetHasSpellEffect(VESTIGE_TKHALUULJIN, oBinder) ||
        !GetLocalInt(oBinder, "TkhalMadnessAuraActive"))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    object oTarget = GetEnteringObject();
    PulseTkhalMadnessOnTarget(oBinder, oTarget);
}
