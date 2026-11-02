/**
 * @file
 * Deeper Darkness for Tenebrous
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
	if (GetHasSpellEffect(GetSpellId(), oBinder))
	{
		PRCRemoveSpellEffects(GetSpellId(), oBinder, oBinder);
		GZPRCRemoveSpellEffects(GetSpellId(), oBinder, FALSE);	
	}
    else
    {
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAreaOfEffect(AOE_PER_DARKNESS)), PRCGetSpellTargetObject(), 60.0 * GetBinderLevel(oBinder, VESTIGE_TENEBROUS));
    	object oAoE = GetAreaOfEffectObject(GetSpellTargetLocation(), "VFX_PER_DARKNESS");
    	SetAllAoEInts(SPELL_DARKNESS, oAoE, GetBinderDC(oBinder, VESTIGE_TENEBROUS), 0, GetBinderLevel(oBinder, VESTIGE_TENEBROUS));    
    }	
}
        