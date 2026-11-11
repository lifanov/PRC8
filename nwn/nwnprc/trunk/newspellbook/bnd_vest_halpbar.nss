/**
 * @file
 * Blade Barrier for Halphax
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_HALPHAX)) return;
    DoRacialSLA(SPELL_BLADE_BARRIER, GetBinderLevel(oBinder, VESTIGE_HALPHAX), GetBinderDC(oBinder, VESTIGE_HALPHAX));    
}
        