/*
09/03/21 by Stratovarius

Dantalion, the Star Emperor
  
Dantalion, called the Star Emperor for his legend and appearance, is a composite of many souls. He grants binders the ability to teleport short distances, read thoughts, and stop foes.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Dantalions influence causes you to be aloof and use stately gestures. Dantalion cant help but be curious about the leaders of the day, 
so anytime you are within 100 feet of someone who clearly is (or professes to be) a leader of others, Dantalion requires that you try to read that 
persons thoughts. Once you have made the attempt, regardless of success or failure, you need not try to read that persons thoughts again.

Granted Abilities: 
Pact magic grimoires attest to Dantalions profound wisdom and his extensive knowledge about all subjects. Because he knows all thoughts, he can grant 
you a portion of that power, as well as the ability to travel just by thinking. You also gain a portion of his commanding presence, which many binders 
ascribe to his royal origins.

Read Thoughts: At will as a full-round action, you can attempt to read the surface thoughts of any creature you can see. If the target makes a successful 
Will save, you cannot read its thoughts for 1 minute. If you attempt to read the thoughts of a creature with an Intelligence score 10 points higher than 
your own, you automatically fail and are stunned for 1 round.
*/

#include "bnd_inc_bndfunc"

void DantalionRead(object oBinder, object oTarget, int nDC)
{
	if (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) - 10 >= GetAbilityScore(oBinder, ABILITY_INTELLIGENCE))
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectStunned()), oBinder, 6.0);
    else if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    {
    	if (!GetLocalInt(oTarget, "DantalionImmune"))
    	{
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST), oTarget);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)), oTarget, 60.0);
    		FloatingTextStringOnCreature(GetName(oTarget)+" thinks "+GetName(oBinder)+" smells of elderberries", oBinder, FALSE);
    	}	
    }	
    else // Enemy succeeded on saving throw here
    {
    	FloatingTextStringOnCreature(GetName(oTarget)+" resists your Read Thoughts for one minute!", oBinder, FALSE);
    	SetLocalInt(oTarget, "DantalionImmune", TRUE);
    	DelayCommand(60.0, DeleteLocalInt(oTarget, "DantalionImmune"));
    }
}    

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
	object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nDC = GetBinderDC(oBinder, VESTIGE_DANTALION);
    if (GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder) >= 2)
        nDC += 2;
	
	DantalionRead(oBinder, oTarget, nDC);
	
	if (GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder) >= 5)
	{
	    location lTarget = GetLocation(oBinder);
	    float fRange = FeetToMeters(5.0 * GetBinderLevel(oBinder, VESTIGE_DANTALION));
	    int nMaxExtra = PRCMax(2, GetAbilityModifier(ABILITY_CHARISMA, oBinder)) - 1;
	    int nExtraCount = 0;
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_INSANITY), oBinder);
	    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	    while(GetIsObjectValid(oAreaTarget) && nExtraCount < nMaxExtra)
	    {
	        if(oAreaTarget != oBinder && oAreaTarget != oTarget && GetIsEnemy(oBinder, oAreaTarget)) // Enemies only
	        {
				DantalionRead(oBinder, oAreaTarget, nDC);
				nExtraCount++;
	        }
	        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	    }	
	}
}