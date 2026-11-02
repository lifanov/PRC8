/*
03/02/21 by Stratovarius

Amon, the Void Before the Altar

Special Requirement: Amon particularly despises four
other vestiges: Chupoclops, Eurynome, Karsus, and Leraje. If
you have hosted one of these spirits within the last 24 hours,
Amon refuses to answer your call. Similarly, these spirits will
not answer your call if you are already bound to Amon.

Granted Abilities: Amon grants you his sight and his
breath, as well as the deadly use of his horns.

Darkvision: You gain darkvision out to 60 feet.

Fire Breath: You can vomit forth a line of fi re as a standard
action. The line extends 10 feet per effective binder level
(maximum 50 feet) and deals 1d6 points of fi re damage per
binder level to every creature in its area. A successful Refl ex
save halves this damage. Once you have used this ability, you
cannot do so again for 5 rounds.

Ram Attack: You can use the rams horns that you gain
from Amons sign as a natural weapon that deals 1d6 points
of damage (plus 1-1/2 times your Strength bonus). When
you charge a foe with your ram attack, you deal an extra 1d8
points of damage on a successful hit. You cannot use this
ability if you do not show Amons sign.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_natweap"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CROWN_OF_GLORY), EffectPact(oBinder));
           
	if (!GetIsVestigeExploited(oBinder, VESTIGE_AMON_DARKVISION)) eLink = EffectLinkEffects(eLink, EffectUltravision());
           
      
    
    eLink = SetEffectSpellId(eLink, VESTIGE_AMON);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(eLink), PRCGetSpellId()), oBinder, HoursToSeconds(24));
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		if (!GetIsVestigeExploited(oBinder, VESTIGE_AMON_RAMATTACK))     
		{
			SetLocalInt(oBinder, "AmonRam", TRUE);
    		string sResRef = "prc_mino_gore_";
    		int nSize = PRCGetCreatureSize(oBinder);
    		sResRef += GetAffixForSize(nSize);
    		AddNaturalSecondaryWeapon(oBinder, sResRef, 1);
    		int bForcePrimaryGore = (!GetHasSpellEffect(VESTIGE_IPOS, oBinder) && !GetHasSpellEffect(VESTIGE_RONOVE, oBinder));
    		if (bForcePrimaryGore)
    			DeletePersistantLocalInt(oBinder, "NaturalWeaponPlayerOverride");
    		AddNaturalPrimaryWeapon(oBinder, sResRef, 1, bForcePrimaryGore);
    	}	
    }	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AMON_FIREBREATH)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_AMON_BREATH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}