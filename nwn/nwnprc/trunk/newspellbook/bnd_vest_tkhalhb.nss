/*
Heartbeat script for Tkhaluuljin's Aura of Madness (bnd_vest_tkhalhb)
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

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        PulseTkhalMadnessOnTarget(oBinder, oTarget);
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
