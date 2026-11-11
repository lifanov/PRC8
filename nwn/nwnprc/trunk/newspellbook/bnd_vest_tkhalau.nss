/*
Aura of Madness for Tkhaluuljin (Toggleable 10-ft Aura)
As a standard action, you can project or suppress a 10-foot aura that drives others mad.
All living creatures who pass within the aura must make a Will save or become confused for
1 round per 5 effective binder levels. A creature that makes its saving throw cannot be
affected by this binder's Aura of Madness for 24 hours.
If you suppress this ability, you must wait 5 rounds before you reactivate it.
*/
#include "bnd_inc_bndfunc"

int HasTkhalMadnessAura(object oBinder)
{
    if (GetLocalInt(oBinder, "TkhalMadnessAuraActive"))
        return TRUE;
    if (GetHasSpellEffect(VESTIGE_TKHAL_MADNESS_SPELL, oBinder))
        return TRUE;
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "TkhalMadnessAura")
            return TRUE;
        eCheck = GetNextEffect(oBinder);
    }
    return FALSE;
}

void RemoveTkhalMadnessAura(object oBinder)
{
    DeleteLocalInt(oBinder, "TkhalMadnessAuraActive");
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "TkhalMadnessAura" || GetEffectSpellId(eCheck) == VESTIGE_TKHAL_MADNESS_SPELL)
            RemoveEffect(oBinder, eCheck);
        eCheck = GetNextEffect(oBinder);
    }
}

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;

    // If Aura of Madness is currently active, toggle it OFF and start the 5-round cooldown
    if (HasTkhalMadnessAura(oBinder))
    {
        RemoveTkhalMadnessAura(oBinder);
        BindAbilCooldown(oBinder, VESTIGE_TKHAL_MADNESS_SPELL, VESTIGE_TKHALUULJIN);
        FloatingTextStringOnCreature("Tkhaluuljin's Aura of Madness suppressed (5-round cooldown before reactivation).", oBinder, FALSE);
        return;
    }

    // Check if the 5-round post-suppression cooldown is still running
    if (GetLocalInt(oBinder, "Bind" + IntToString(VESTIGE_TKHAL_MADNESS_SPELL)))
    {
        if (!BindAbilCooldown(oBinder, VESTIGE_TKHAL_MADNESS_SPELL, VESTIGE_TKHALUULJIN))
            return;
    }

    // Toggle Aura of Madness ON permanently (stays active until toggled off or unbound)
    effect eAura = EffectLinkEffects(
        EffectAreaOfEffect(VFX_PER_SNARE, "bnd_vest_tkhalen", "bnd_vest_tkhalhb", ""),
        EffectVisualEffect(VFX_DUR_AURA_PULSE_PURPLE_BLACK)
    );
    eAura = TagEffect(SupernaturalEffect(eAura), "TkhalMadnessAura");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oBinder);
    SetLocalInt(oBinder, "TkhalMadnessAuraActive", TRUE);
    FloatingTextStringOnCreature("Tkhaluuljin's Aura of Madness activated (stays active until toggled off).", oBinder, FALSE);

    // Immediately affect any living creatures currently within 10 feet
    location lLoc = GetLocation(oBinder);
    float fRadius = FeetToMeters(10.0);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        PulseTkhalMadnessOnTarget(oBinder, oTarget);
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
