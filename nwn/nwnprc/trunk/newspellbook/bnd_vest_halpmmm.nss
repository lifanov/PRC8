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
    DoRacialSLA(SPELL_MORDENKAINENS_MAGNIFICENT_MANSION, GetBinderLevel(oBinder, VESTIGE_HALPHAX), GetBinderDC(oBinder, VESTIGE_HALPHAX));    
}
        