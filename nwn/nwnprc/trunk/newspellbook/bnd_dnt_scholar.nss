#include "bnd_inc_bndfunc"
void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSkillIncrease(SKILL_LORE, 8)), OBJECT_SELF, 6.0);
}
