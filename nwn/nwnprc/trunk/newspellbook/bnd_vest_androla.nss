/**
 * @file
 * Hideous Laughter for Andromalius (Jester's Mirth)
 *
 */

#include "bnd_inc_bndfunc"

void RecurringMirthSave(object oTarget, int nSpellId, int nDC, object oBinder)
{
    if (GetHasSpellEffect(SPELL_TASHAS_HIDEOUS_LAUGHTER, oTarget) || GetHasSpellEffect(nSpellId, oTarget))
    {
        if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            PRCRemoveSpellEffects(SPELL_TASHAS_HIDEOUS_LAUGHTER, oBinder, oTarget);
            GZPRCRemoveSpellEffects(SPELL_TASHAS_HIDEOUS_LAUGHTER, oTarget, FALSE);
            PRCRemoveSpellEffects(nSpellId, oBinder, oTarget);
            GZPRCRemoveSpellEffects(nSpellId, oTarget, FALSE);
            return;
        }
        DelayCommand(6.0, RecurringMirthSave(oTarget, nSpellId, nDC, oBinder));
    }
}

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellId = GetSpellId();
    int nDC = GetBinderDC(oBinder, VESTIGE_ANDROMALIUS);
    if(!BindAbilCooldown(oBinder, nSpellId, VESTIGE_ANDROMALIUS)) return;
    DoRacialSLA(SPELL_TASHAS_HIDEOUS_LAUGHTER, GetBinderLevel(oBinder, VESTIGE_ANDROMALIUS), nDC);
    if (GetIsObjectValid(oTarget))
        DelayCommand(6.0, RecurringMirthSave(oTarget, nSpellId, nDC, oBinder));
}
