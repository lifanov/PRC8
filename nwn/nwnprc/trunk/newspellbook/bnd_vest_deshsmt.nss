#include "bnd_inc_bndfunc"
#include "prc_inc_smite"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_DESHARIS)) return;
    object oTarget = PRCGetSpellTargetObject();   
    int nRace = MyPRCGetRacialType(oTarget);
    if(nRace == RACIAL_TYPE_ANIMAL || nRace == RACIAL_TYPE_BEAST || nRace == RACIAL_TYPE_ELEMENTAL || nRace == RACIAL_TYPE_FEY || nRace == RACIAL_TYPE_PLANT) 
        DoSmite(oBinder, oTarget, SMITE_TYPE_DESHARIS);
}