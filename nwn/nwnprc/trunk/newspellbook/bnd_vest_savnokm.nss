/////////////////////////////////////////////////////////////////////
//
// Savnok Move Ally - Swap the caster and target's positions,
// the target must be a member of the caster's party.
//
/////////////////////////////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "spinc_trans"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
	if (GetSpellId() == 19184 && !TakeSwiftAction(OBJECT_SELF)) return;
	if(!BindAbilCooldown(OBJECT_SELF, GetSpellId(), VESTIGE_SAVNOK)) return;
	DoTransposition(FALSE, FALSE);
}
