/**
 * @file
 * True Strike for Zceryll
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    if(GetLocalInt(oBinder, "ZceryllTS")) return;
    SetLocalInt(oBinder, "ZceryllTS", TRUE);
    DoRacialSLA(SPELL_TRUE_STRIKE, GetBinderLevel(oBinder, VESTIGE_ZCERYLL), GetBinderDC(oBinder, VESTIGE_ZCERYLL));    
}
        