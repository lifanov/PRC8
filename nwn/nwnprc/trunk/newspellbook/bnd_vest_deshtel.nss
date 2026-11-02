#include "bnd_inc_bndfunc"
#include "prc_inc_template"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    int nUses = 1;
    int nSLA = GetSpellId(); 
    
    // Check uses per day
    if (GetLegacyUses(oBinder, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSLA))) + " the maximum amount of times today.", oBinder, FALSE);
        return;
    }             
    else
    {
		SetLegacyUses(oBinder, nSLA);
    	FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oBinder, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSLA))) + " remaining today.", oBinder, FALSE);    		    		

    	DoRacialSLA(SPELL_TELEPORT_SELF, GetBinderLevel(oBinder, VESTIGE_DESHARIS), GetBinderDC(oBinder, VESTIGE_DESHARIS), FALSE);
    }     
}