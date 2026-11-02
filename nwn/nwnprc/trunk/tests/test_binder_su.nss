//::///////////////////////////////////////////////
//:: PRC8 Binder Supernatural (Su) Conversion Test Suite
//:: test_binder_su.nss
//:://////////////////////////////////////////////
//:: Verifies that all granted vestige abilities and
//:: bonus feats obey D&D 3.5e Tome of Magic (p. 21)
//:: Supernatural (Su) rules:
//:: 1. No Verbal or Somatic components (VS=0 in spells.2da,
//::    usable while Silenced, Deafened, or in 100% ASF armor).
//:: 2. No Attacks of Opportunity & uninterruptible (UserType=2/3,
//::    Counter1/2=****, GrappleConc bypassed).
//:: 3. No Spell Resistance or Power Resistance checks
//::    (PRCDoResistSpell & PRCMyResistPower return 0).
//:: 4. Cannot be dispelled (SUBTYPE_SUPERNATURAL enforced on
//::    both direct and SPApplyEffectToObject effects).
//:: 5. Subject to Antimagic Field / Null Psionics Field
//::    (active vestige abilities blocked in AMF, passive
//::    vestige effects and granted bonus feats such as
//::    Leraje Point Blank Shot suppressed on entering AMF
//::    and restored upon exiting AMF).
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "psi_inc_pwresist"

int HasEffectOfSubTypeOn(object oTarget, int nEffectType, int nSubType)
{
    effect e = GetFirstEffect(oTarget);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == nEffectType && GetEffectSubType(e) == nSubType)
            return TRUE;
        e = GetNextEffect(oTarget);
    }
    return FALSE;
}

void RunTestSuite_BinderSu_PhaseAMFExit(object oBinder, object oTarget)
{
    AssertInt("SU-05f: GetIsBinderInAntimagicField is FALSE after exiting AMF",
              GetIsBinderInAntimagicField(oBinder), FALSE);
    AssertInt("SU-05g: Leraje passive pact effect (19022) is restored on exiting AMF",
              GetHasSpellEffect(VESTIGE_LERAJE, oBinder), TRUE);
    AssertInt("SU-05h: Leraje granted Point Blank Shot bonus feat is restored on exiting AMF",
              GetHasFeat(FEAT_POINT_BLANK_SHOT, oBinder), TRUE);

    // Clean up test state
    ClearAllEffectsOn(oBinder);
    ClearAllEffectsOn(oTarget);
    RemoveSkinBonusFeat(oBinder, 4607);
    RemoveSkinBonusFeat(oBinder, IP_CONST_FEAT_POINTBLANK);
    RemoveSkinBonusFeat(oBinder, 4607);
    RemoveSkinBonusFeat(oBinder, 4610);
    RemoveSkinBonusFeat(oBinder, IP_CONST_FEAT_POINTBLANK);
    RemoveSkinBonusFeat(oBinder, IP_CONST_VESTIGE_LERAJE_RICOCHET);
}

void RunTestSuite_BinderSu_PhaseAMFEnter(object oBinder, object oTarget)
{
    AssertInt("SU-05c: GetIsBinderInAntimagicField is TRUE while inside AMF",
              GetIsBinderInAntimagicField(oBinder), TRUE);
    AssertInt("SU-05d: Leraje passive pact effect (19022) is suppressed inside AMF",
              GetHasSpellEffect(VESTIGE_LERAJE, oBinder), FALSE);
    AssertInt("SU-05e: Leraje granted Point Blank Shot bonus feat is suppressed inside AMF",
              GetHasFeat(FEAT_POINT_BLANK_SHOT, oBinder), FALSE);

    // Active vestige ability (Malphas Invisibility) is blocked while inside AMF
    ExecuteScript("bnd_vest_malinv", oBinder);
    AssertInt("SU-05i: Active vestige ability (bnd_vest_malinv) is blocked while inside AMF",
              HasEffectOfSubTypeOn(oBinder, EFFECT_TYPE_INVISIBILITY, SUBTYPE_SUPERNATURAL), FALSE);

    // Now exit AMF and verify full restoration after engine tick settles
    RestoreBinderVestigesFromAMF(oBinder);
    DelayCommand(0.4, RunTestSuite_BinderSu_PhaseAMFExit(oBinder, oTarget));
}

void RunTestSuite_BinderSu(object oHelper, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] --- Suite: Binder Supernatural (Su) Conversion Across All Vestige Abilities ---");
    ClearAllEffectsOn(oBinder);
    ClearAllEffectsOn(oTarget);

    // -------------------------------------------------------------------------
    // SU-01: spells.2da VS=0, UserType=2/3, Counter1/2=**** Across Vestige Rows
    // -------------------------------------------------------------------------
    AssertTrue("SU-01a: Amon Fire Breath (19070) has VS=0 and UserType=2 in spells.2da",
               Get2DACache("spells", "VS", 19070) == "0" && Get2DACache("spells", "UserType", 19070) == "2");
    AssertTrue("SU-01b: Naberius Command (19080) has VS=0 and UserType=2 in spells.2da",
               Get2DACache("spells", "VS", 19080) == "0" && Get2DACache("spells", "UserType", 19080) == "2");
    AssertTrue("SU-01c: Malphas Invisibility (19091) has VS=0 and UserType=2 in spells.2da",
               Get2DACache("spells", "VS", 19091) == "0" && Get2DACache("spells", "UserType", 19091) == "2");
    AssertTrue("SU-01d: Andromalius Hideous Laughter (19094) has VS=0 and UserType=2 in spells.2da",
               Get2DACache("spells", "VS", 19094) == "0" && Get2DACache("spells", "UserType", 19094) == "2");
    AssertTrue("SU-01e: Halphax Blade Barrier (19154) has VS=0 and Counter1=empty in spells.2da",
               Get2DACache("spells", "VS", 19154) == "0" && Get2DACache("spells", "Counter1", 19154) == "");
    AssertTrue("SU-01f: Zuriel Forceful Speed Magic Missile (19189) has VS=0 and UserType=3 in spells.2da",
               Get2DACache("spells", "VS", 19189) == "0" && Get2DACache("spells", "UserType", 19189) == "3");

    // -------------------------------------------------------------------------
    // SU-02: No Verbal/Somatic Failure & Uninterruptible While Grappling
    // -------------------------------------------------------------------------
    SetLocalInt(oBinder, "BinderSuSLA", TRUE);
    SetLocalInt(oBinder, "IsGrappled", TRUE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSilence()), oBinder, 6.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectDeaf()), oBinder, 6.0);

    AssertInt("SU-02a: ArcaneSpellFailure returns FALSE (0) for Supernatural vestige ability",
              ArcaneSpellFailure(oBinder, CLASS_TYPE_WIZARD, 5, METAMAGIC_NONE, "VS"), FALSE);
    AssertInt("SU-02b: SilenceDeafnessFailure returns FALSE (0) while Silenced & Deafened",
              SilenceDeafnessFailure(oBinder, 5, METAMAGIC_NONE, "VS"), FALSE);
    AssertInt("SU-02c: PnPSomaticComponents returns TRUE (1) without free hands",
              PnPSomaticComponents(oBinder, OBJECT_INVALID, "VS", METAMAGIC_NONE), TRUE);
    AssertInt("SU-02d: GrappleConc returns TRUE (1) without concentration check while grappled",
              GrappleConc(oBinder, 9), TRUE);

    DeleteLocalInt(oBinder, "IsGrappled");
    ClearAllEffectsOn(oBinder);

    // -------------------------------------------------------------------------
    // SU-03: Zero Spell Resistance (SR) and Power Resistance (PR) Checks
    // -------------------------------------------------------------------------
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectSpellResistanceIncrease(99)), oTarget, 60.0);
    AssertInt("SU-03a: PRCDoResistSpell returns SPELL_RESIST_FAIL (0) against SR 99 target",
              PRCDoResistSpell(oBinder, oTarget, 1), SPELL_RESIST_FAIL);
    AssertInt("SU-03b: PRCMyResistPower returns POWER_RESIST_FAIL (0) against PR 99 target",
              PRCMyResistPower(oBinder, oTarget, 1), POWER_RESIST_FAIL);

    // Target inside AMF is impervious to outside supernatural abilities
    SetLocalInt(oTarget, "BinderInAMF", TRUE);
    AssertInt("SU-03c: PRCDoResistSpell returns SPELL_RESIST_PASS (1) when target is inside AMF",
              PRCDoResistSpell(oBinder, oTarget, 40), SPELL_RESIST_PASS);
    DeleteLocalInt(oTarget, "BinderInAMF");
    ClearAllEffectsOn(oTarget);

    // -------------------------------------------------------------------------
    // SU-04: SUBTYPE_SUPERNATURAL Enforcement (Undispellable)
    // -------------------------------------------------------------------------
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, MagicalEffect(EffectACIncrease(2)), oTarget, 30.0, TRUE, 19096, 20, oBinder);
    AssertInt("SU-04a: SPApplyEffectToObject promotes replicated vestige spell effects to SUBTYPE_SUPERNATURAL",
              HasEffectOfSubTypeOn(oTarget, EFFECT_TYPE_AC_INCREASE, SUBTYPE_SUPERNATURAL), TRUE);
    ClearAllEffectsOn(oTarget);
    DeleteLocalInt(oBinder, "BinderSuSLA");

    ExecuteScript("bnd_vest_malinv", oBinder);
    AssertInt("SU-04b: Malphas Invisibility (bnd_vest_malinv) applies SUBTYPE_SUPERNATURAL (not Extraordinary)",
              HasEffectOfSubTypeOn(oBinder, EFFECT_TYPE_INVISIBILITY, SUBTYPE_SUPERNATURAL), TRUE);
    ClearAllEffectsOn(oBinder);

    // -------------------------------------------------------------------------
    // SU-05: Antimagic Field Suppression & Restoration (Including Bonus Feats)
    // -------------------------------------------------------------------------
    RemoveSkinBonusFeat(oBinder, IP_CONST_FEAT_POINTBLANK);
    RemoveSkinBonusFeat(oBinder, 4607);
    RemoveSkinBonusFeat(oBinder, 4610);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_LERAJE), TRUE);
    ReapplyVestigeFromAMF(oBinder, VESTIGE_LERAJE);
    AssertInt("SU-05a: Leraje (19022) is bound before entering AMF",
              GetHasSpellEffect(VESTIGE_LERAJE, oBinder), TRUE);
    AssertInt("SU-05b: Leraje grants Point Blank Shot bonus feat (4610) before entering AMF",
              GetHasFeat(FEAT_POINT_BLANK_SHOT, oBinder), TRUE);

    SuppressBinderVestigesInAMF(oBinder);
    DelayCommand(0.4, RunTestSuite_BinderSu_PhaseAMFEnter(oBinder, oTarget));
}
