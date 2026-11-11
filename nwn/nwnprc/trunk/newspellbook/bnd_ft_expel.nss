#include "bnd_inc_bndfunc"

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
	object oBinder = OBJECT_SELF;
   	AssignCommand(oBinder, ClearAllActions(TRUE));
   	StartDynamicConversation("bnd_expelcnv", oBinder, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oBinder);   
}
