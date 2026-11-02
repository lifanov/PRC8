//::///////////////////////////////////////////////
//:: Binder Core Lifecycle & Pre-Epic Vestige Regression Test Suite
//:: test_binder_bugfixes.nss
//:://////////////////////////////////////////////
//:: Tests Pact Augmentation temporary HP unlinking & synchronous replacement,
//:: GetShouldNotBeRemoved protection, ScrubPCSkin & per-vestige skin scrubbing,
//:: Naberius Disguise Self feat restoration, ApplyBinderWeaponDRBypass max
//:: bonus calculation, OnHit strike arming flags, Karsus/Balam/Arete special
//:: requirements, Tenebrous/Geryon Ultravision, Focalor/Chupoclops toggleable
//:: auras, Chupoclops poor-pact fear save auto-fail vs Agares fear immunity,
//:: psionic vestige PRCMax manifester level, and Naberius skill count caps.
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "prc_nui_bnd_inc"
#include "psi_inc_core"
#include "spinc_remeffct"

int CountAttackBonusPropertyValue(object oWeapon)
{
    int nMax = 0;
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS)
        {
            int nVal = GetItemPropertyCostTableValue(ip);
            if (nVal > nMax) nMax = nVal;
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return nMax;
}

int HasEffectTypeWithSpellID(object oCreature, int nEffectType, int nSpellID)
{
    effect e = GetFirstEffect(oCreature);
    while (GetIsEffectValid(e))
    {
        if (GetEffectType(e) == nEffectType && GetEffectSpellId(e) == nSpellID)
            return TRUE;
        e = GetNextEffect(oCreature);
    }
    return FALSE;
}

void RemovePactAugmentEffectsOn(object oCreature)
{
    effect e = GetFirstEffect(oCreature);
    while (GetIsEffectValid(e))
    {
        if (GetEffectTag(e) == "BinderPactAugmentEff" || GetEffectSpellId(e) == VESTIGE_PACT_AUGMENTATION)
            RemoveEffect(oCreature, e);
        e = GetNextEffect(oCreature);
    }
}

void RunTestSuite_BinderBugfixes_Step4(object oBinder, object oTarget, object oMage, object oSword, int nBaseHP)
{
    // Verify BF-01d after engine processed RemovePactAugmentEffectsOn
    AssertInt("BF-01d: Removing standalone Pact Augmentation Temp HP cleanly restores base HP",
        GetCurrentHitPoints(oBinder), nBaseHP);

    // Verify BF-03a/b after engine processed ScrubVestigeSkinFeats(VESTIGE_DANTALION) in Step3
    AssertInt("BF-03a: ScrubVestigeSkinFeats(VESTIGE_DANTALION) removes Dantalion feat (9070)",
        GetHasFeat(9070, oBinder), FALSE);
    AssertTrue("BF-03b: ScrubVestigeSkinFeats(VESTIGE_DANTALION) leaves Tenebrous feat (9061) intact",
        GetHasFeat(9061, oBinder));

    // Verify BF-04c after engine processed ApplyBinderWeaponDRBypass removal in Step3
    AssertInt("BF-04c: Expelling Ronove removes temporary weapon DR bypass cleanly",
        CountAttackBonusPropertyValue(oSword), 0);
    DestroyObject(oSword);
    if (GetIsObjectValid(oMage))
    {
        SetPlotFlag(oMage, FALSE);
        DestroyObject(oMage);
    }

    // Clean up test effects on oBinder and oTarget
    RemoveSpellEffectsByID(oBinder, VESTIGE_TENEBROUS);
    RemoveSpellEffectsByID(oBinder, VESTIGE_GERYON);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_TENEBROUS);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_GERYON);
    ClearAllEffectsOn(oTarget);
}

void RunTestSuite_BinderBugfixes_Step3(object oHelper, object oBinder, object oTarget, object oMage, object oSword, int nBaseHP)
{
    // Verify BF-01c after second bnd_bind_pact ran in Step2, then remove Pact Augmentation
    AssertInt("BF-01c: Re-running bnd_bind_pact replaces prior augmentation without stacking 2x Temp HP",
        GetCurrentHitPoints(oBinder) - nBaseHP, 10);
    RemovePactAugmentEffectsOn(oBinder);

    // Verify BF-02c after ScrubPCSkin ran in Step2, then scrub Dantalion feat for BF-03a/b
    AssertTrue("BF-02c: ScrubPCSkin preserves Binder vestige bonus feats in range 13730..13815",
        GetHasFeat(9070, oBinder) && GetHasFeat(9061, oBinder));
    ScrubVestigeSkinFeats(oBinder, VESTIGE_DANTALION);

    // Verify BF-04b after ApplyBinderWeaponDRBypass downgraded to +3 in Step2, then strip Ronove and re-run DR bypass
    AssertInt("BF-04b: Expelling Aym while keeping Ronove downgrades weapon DR bypass to +3",
        CountAttackBonusPropertyValue(oSword), 3);
    ApplyBinderWeaponDRBypass(oBinder, oSword);

    // Verify BF-06b after mobile external AOE (AOE_PER_TELEPORTATIONCIRCLE with SPELL_STINKING_CLOUD) is applied on oMage
    AssertInt("BF-06b: Karsus DoSpecialRequirements rejects external spell AOE",
        DoSpecialRequirements(oMage, VESTIGE_KARSUS), FALSE);

    // Verify BF-10b & BF-10d after toggle OFF processed
    AssertInt("BF-10b: Focalor Aura of Sadness toggles OFF cleanly",
        GetHasSpellEffect(19081, oBinder) || GetLocalInt(oBinder, "FocalorAuraActive"), FALSE);
    AssertInt("BF-10d: Chupoclops Aura of Despair toggles OFF cleanly",
        GetHasSpellEffect(19124, oBinder) || GetLocalInt(oBinder, "ChupoclopsAuraActive"), FALSE);

    DelayCommand(0.35f, RunTestSuite_BinderBugfixes_Step4(oBinder, oTarget, oMage, oSword, nBaseHP));
}

void RunTestSuite_BinderBugfixes_Step2(object oHelper, object oBinder, object oTarget, object oMage, object oSword, int nBaseHP)
{
    // Re-run bnd_bind_pact after first tick -> replaces prior augmentation without stacking 2x
    SetLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", TRUE);
    SetLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", oBinder);
    ExecuteScript("bnd_bind_pact", oBinder);
    DeleteLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");
    DeleteLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");

    // Run ScrubPCSkin now that Dantalion (9070) and Tenebrous (9061) bonus feats from Step1 are on oSkin
    ScrubPCSkin(oBinder, GetPCSkin(oBinder));

    // Recompute weapon DR bypass now that VESTIGE_AYM removal from Step1 is processed, then remove VESTIGE_RONOVE
    ApplyBinderWeaponDRBypass(oBinder, oSword);
    RemoveSpellEffectsByID(oBinder, VESTIGE_RONOVE);

    // Verify BF-06a on oMage (13 base ranks in Lore, without FEAT_IGNORE_SPECIAL_REQUIREMENTS),
    // then apply mobile external AOE (AOE_PER_TELEPORTATIONCIRCLE with SPELL_STINKING_CLOUD)
    AssertTrue("BF-06a: Karsus DoSpecialRequirements allows fellow vestige aura (19081)",
        DoSpecialRequirements(oMage, VESTIGE_KARSUS));
    effect eExtAOE = SetEffectSpellId(EffectAreaOfEffect(AOE_PER_TELEPORTATIONCIRCLE, "****", "****", "****"), SPELL_STINKING_CLOUD);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExtAOE, oMage, 60.0f);

    // Verify BF-07b on oTarget (temporarily clearing Plot flag so damage applies)
    SetPlotFlag(oTarget, FALSE);
    int nDropDmg = GetCurrentHitPoints(oTarget) - 1;
    if (nDropDmg > 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDropDmg, DAMAGE_TYPE_MAGICAL), oTarget);
    AssertInt("BF-07b: Balam DoSpecialRequirements rejects binding at 1 HP",
        DoSpecialRequirements(oTarget, VESTIGE_BALAM), FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(500), oTarget);
    SetPlotFlag(oTarget, TRUE);

    AssertInt("BF-08a: Eurynome DoSpecialRequirements returns FALSE when Arete is bound",
        DoSpecialRequirements(oTarget, VESTIGE_EURYNOME), FALSE);
    AssertInt("BF-08b: Chupoclops DoSpecialRequirements returns FALSE when Arete is bound",
        DoSpecialRequirements(oTarget, VESTIGE_CHUPOCLOPS), FALSE);
    RemoveSpellEffectsByID(oTarget, VESTIGE_ARETE);

    AssertInt("BF-11b: Agares fear immunity overrides Chupoclops poor pact and returns immune (2)",
        PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 50, SAVING_THROW_TYPE_FEAR, oHelper, 0.0, TRUE), 2);
    RemoveSpellEffectsByID(oTarget, VESTIGE_CHUPOCLOPS);
    RemoveSpellEffectsByID(oTarget, VESTIGE_AGARES);

    // Verify BF-09 & BF-10a/c/e
    AssertTrue("BF-09a: Tenebrous bind grants direct Ultravision effect",
        HasEffectTypeWithSpellID(oBinder, EFFECT_TYPE_ULTRAVISION, VESTIGE_TENEBROUS));
    AssertTrue("BF-09b: Geryon bind grants direct Ultravision effect",
        HasEffectTypeWithSpellID(oBinder, EFFECT_TYPE_ULTRAVISION, VESTIGE_GERYON));

    AssertTrue("BF-10a: Focalor Aura of Sadness toggles ON with permanent AOE",
        GetHasSpellEffect(19081, oBinder) && GetLocalInt(oBinder, "FocalorAuraActive"));
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", 19081);
    ExecuteScript("bnd_vest_focaura", oBinder);

    AssertTrue("BF-10c: Chupoclops Aura of Despair toggles ON with permanent AOE",
        GetHasSpellEffect(19124, oBinder) && GetLocalInt(oBinder, "ChupoclopsAuraActive"));
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", 19124);
    ExecuteScript("bnd_vest_chupaur", oBinder);
    DeleteLocalInt(oBinder, "PRC_SPELLID_OVERRIDE");

    AssertTrue("BF-10e: Chupoclops Ethereal Watcher stamps VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER (19125)",
        GetHasSpellEffect(VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER, oBinder));
    PRCRemoveSpellEffects(VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER, oBinder, oBinder);

    DelayCommand(0.35f, RunTestSuite_BinderBugfixes_Step3(oHelper, oBinder, oTarget, oMage, oSword, nBaseHP));
}

void RunTestSuite_BinderBugfixes(object oHelper, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] --- Suite: Binder Core Lifecycle & Pre-Epic Vestige Bugfixes ---");

    // Sync PRC_HitDiceTracking after Suite 1's SetXP so prc_onhb_indiv does not fire prc_onleveldown mid-suite
    SetLocalInt(oBinder, "PRC_HitDiceTracking", GetHitDice(oBinder));

    ClearAllEffectsOn(oBinder);
    ClearAllEffectsOn(oTarget);

    object oMage = CreateObject(OBJECT_TYPE_CREATURE, "prc_sum_lammasu", GetLocation(oBinder), FALSE, "HARNESS_MAGE");
    SetPlotFlag(oMage, TRUE);
    effect eMageFocAura = SetEffectSpellId(SupernaturalEffect(EffectAreaOfEffect(AOE_PER_TELEPORTATIONCIRCLE, "****", "****", "****")), 19081);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMageFocAura, oMage, 60.0f);

    // -------------------------------------------------------------------------
    // BF-01: Pact Augmentation standalone unlinked Temp HP & synchronous replace
    // -------------------------------------------------------------------------
    int nBaseHP = GetCurrentHitPoints(oBinder);
    SetLocalInt(oBinder, "PactAugment1", 2); // +10 Temp HP
    SetLocalInt(oBinder, "PactAugment9", 2); // +2 AC
    SetLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", TRUE);
    SetLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", oBinder);
    ExecuteScript("bnd_bind_pact", oBinder);

    int bFoundUnlinkedTempHP = FALSE;
    effect eChk = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eChk))
    {
        if (GetEffectTag(eChk) == "BinderPactAugmentEff" && GetEffectType(eChk) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
            bFoundUnlinkedTempHP = TRUE;
        eChk = GetNextEffect(oBinder);
    }
    AssertTrue("BF-01a: Pact Augmentation applies Temp HP as standalone unlinked EFFECT_TYPE_TEMPORARY_HITPOINTS",
        bFoundUnlinkedTempHP);
    AssertInt("BF-01b: Pact Augmentation grants +10 temporary hit points",
        GetCurrentHitPoints(oBinder) - nBaseHP, 10);

    // -------------------------------------------------------------------------
    // BF-02 & BF-03: GetShouldNotBeRemoved protection, ScrubPCSkin, and skin feats
    // -------------------------------------------------------------------------
    effect eAmonEff = SetEffectSpellId(SupernaturalEffect(EffectACIncrease(1)), VESTIGE_AMON);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAmonEff, oBinder, 60.0f);

    int bAmonProtected = FALSE;
    int bPactProtected = FALSE;
    eChk = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eChk))
    {
        if (GetEffectSpellId(eChk) == VESTIGE_AMON && GetShouldNotBeRemoved(eChk))
            bAmonProtected = TRUE;
        if (GetEffectTag(eChk) == "BinderPactAugmentEff" && GetShouldNotBeRemoved(eChk))
            bPactProtected = TRUE;
        eChk = GetNextEffect(oBinder);
    }
    AssertTrue("BF-02a: GetShouldNotBeRemoved protects bound vestige effects (VESTIGE_AMON)", bAmonProtected);
    AssertTrue("BF-02b: GetShouldNotBeRemoved protects BinderPactAugmentEff / VESTIGE_PACT_AUGMENTATION", bPactProtected);
    RemoveSpellEffectsByID(oBinder, VESTIGE_AMON);

    AddSkinBonusFeat(oBinder, IP_CONST_VESTIGE_DANTALION_AWE);

    RestoreVestigeSkinFeats(oBinder, VESTIGE_NABERIUS);
    AssertTrue("BF-03c: RestoreVestigeSkinFeats(VESTIGE_NABERIUS) restores Disguise Self (9033) and Persuasive Words (9034)",
        GetHasFeat(9033, oBinder) && GetHasFeat(9034, oBinder));
    ScrubVestigeSkinFeats(oBinder, VESTIGE_NABERIUS);

    // -------------------------------------------------------------------------
    // BF-04: ApplyBinderWeaponDRBypass max(+5 Aym, +3/+1 Ronove) order independence
    // -------------------------------------------------------------------------
    object oSword = CreateItemOnObject("nw_wswls001", oBinder);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_AYM), oBinder, 60.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_RONOVE), oBinder, 60.0f);
    ApplyBinderWeaponDRBypass(oBinder, oSword);
    AssertInt("BF-04a: ApplyBinderWeaponDRBypass applies +5 (max of Aym +5 and Ronove +3)",
        CountAttackBonusPropertyValue(oSword), 5);
    RemoveSpellEffectsByID(oBinder, VESTIGE_AYM);

    // -------------------------------------------------------------------------
    // BF-05: TenebrousVoidArmed, ShaxStormStrikeArmed, EligorStrikeArmed gating
    // -------------------------------------------------------------------------
    DeleteLocalInt(oBinder, "ShaxStormStrikeArmed");
    DeleteLocalInt(oBinder, "EligorStrikeArmed");
    ExecuteScript("bnd_vest_shaxstm", oBinder);
    ExecuteScript("bnd_vest_eligorc", oBinder);
    AssertTrue("BF-05a: bnd_vest_shaxstm arms ShaxStormStrikeArmed flag",
        GetLocalInt(oBinder, "ShaxStormStrikeArmed"));
    AssertTrue("BF-05b: bnd_vest_eligorc arms EligorStrikeArmed flag",
        GetLocalInt(oBinder, "EligorStrikeArmed"));
    DeleteLocalInt(oBinder, "ShaxStormStrikeArmed");
    DeleteLocalInt(oBinder, "EligorStrikeArmed");

    // -------------------------------------------------------------------------
    // BF-06..08 & BF-11 setup
    // -------------------------------------------------------------------------
    int nHPBeforeScan = GetCurrentHitPoints(oTarget);
    SetLocalInt(oTarget, "BinderCheckingMenuReqs", TRUE);
    int bBalamScanOK = DoSpecialRequirements(oTarget, VESTIGE_BALAM);
    DeleteLocalInt(oTarget, "BinderCheckingMenuReqs");
    AssertTrue("BF-07a: Balam DoSpecialRequirements succeeds during UI scan without dealing damage",
        bBalamScanOK && GetCurrentHitPoints(oTarget) == nHPBeforeScan);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_ARETE), oTarget, 60.0f);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_CHUPOCLOPS), oTarget, 60.0f);
    DeleteLocalInt(oTarget, "PactQuality" + IntToString(VESTIGE_CHUPOCLOPS)); // Poor pact
    AssertInt("BF-11a: Chupoclops poor pact forces SAVING_THROW_TYPE_FEAR to auto-fail (0)",
        PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 5, SAVING_THROW_TYPE_FEAR, oHelper), 0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_FEAR)), VESTIGE_AGARES), oTarget, 60.0f);

    // -------------------------------------------------------------------------
    // BF-12: GetManifesterLevel PRCMax across Arete, The Triad, and Abysm
    // -------------------------------------------------------------------------
    SetLocalInt(oBinder, "AretePsion", 14);
    SetLocalInt(oBinder, "TheTriadPsion", 18);
    SetLocalInt(oBinder, "AbysmPsion", 20);
    AssertInt("BF-12: GetManifesterLevel uses PRCMax(14, 18, 20) = 20 across psionic vestiges",
        GetManifesterLevel(oBinder, CLASS_TYPE_PSION), 20);
    DeleteLocalInt(oBinder, "AretePsion");
    DeleteLocalInt(oBinder, "TheTriadPsion");
    DeleteLocalInt(oBinder, "AbysmPsion");

    // -------------------------------------------------------------------------
    // BF-13: Naberius target skill count caps at available untrained skills
    // -------------------------------------------------------------------------
    int nAvailSkills = BinderNUIAvailableNaberiusSkills(oBinder);
    int nConMod = GetAbilityModifier(ABILITY_CONSTITUTION, oBinder);
    int nExpectedNab = nConMod < nAvailSkills ? nConMod : nAvailSkills;
    if (nConMod <= 0) nExpectedNab = 0;
    AssertInt("BF-13a: BinderNUINaberiusTargetCount matches min(ConMod, AvailableUntrainedSkills)",
        BinderNUINaberiusTargetCount(oBinder), nExpectedNab);

    int s;
    for (s = 0; s < 40; s++)
        SetLocalInt(oBinder, "NaberiusSkill" + IntToString(s), TRUE);
    AssertInt("BF-13b: BinderNUINaberiusTargetCount caps at 0 when 0 untrained unranked skills remain",
        BinderNUINaberiusTargetCount(oBinder), 0);
    for (s = 0; s < 40; s++)
        DeleteLocalInt(oBinder, "NaberiusSkill" + IntToString(s));

    // -------------------------------------------------------------------------
    // BF-09 & BF-10: Tenebrous/Geryon Ultravision & Focalor/Chupoclops toggles
    // -------------------------------------------------------------------------
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_TENEBROUS), TRUE);
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", VESTIGE_TENEBROUS);
    ExecuteScript("bnd_vest_tenebrs", oBinder);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_GERYON), TRUE);
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", VESTIGE_GERYON);
    ExecuteScript("bnd_vest_geryon", oBinder);

    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", 19081);
    ExecuteScript("bnd_vest_focaura", oBinder);
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", 19124);
    ExecuteScript("bnd_vest_chupaur", oBinder);
    DeleteLocalInt(oBinder, "PRC_SPELLID_OVERRIDE");
    DeleteLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");
    DeleteLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");

    ExecuteScript("bnd_vest_chupeth", oBinder);

    DelayCommand(0.35f, RunTestSuite_BinderBugfixes_Step2(oHelper, oBinder, oTarget, oMage, oSword, nBaseHP));
}
