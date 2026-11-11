#include "bnd_inc_bndfunc"
#include "inc_dynconv"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    if (GetHasFeat(FEAT_EPIC_EXPEL_VESTIGE, oBinder))
        IncrementRemainingFeatUses(oBinder, FEAT_EXPEL_VESTIGE);
    AssignCommand(oBinder, ClearAllActions(TRUE));
    StartDynamicConversation("bnd_expelcnv", oBinder, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oBinder);
}
