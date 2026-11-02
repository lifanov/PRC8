/**
 * @file
 * Arcane Eye for Malphas
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    DoRacialSLA(SPELL_ARCANE_EYE, GetBinderLevel(oBinder, VESTIGE_MALPHAS), GetBinderDC(oBinder, VESTIGE_MALPHAS));    
}
        