//::///////////////////////////////////////////////
//:: Binder Core Lifecycle & Pre-Epic Vestige Regression Test Suite
//:: test_binder_basic.nss
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
#include "x3_inc_skin"

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

void RunTestSuite_BinderBasic_Step6(object oBinder, object oMount2, object oAllyHench)
{
    AssertInt("BF-16e: ExpelVestige(VESTIGE_ANDRAS) destroys Andras warhorse after dismounting rider",
        GetIsObjectValid(oMount2) || GetIsObjectValid(GetLocalObject(oBinder, "oX3PaladinMount")), FALSE);

    DeletePersistantLocalInt(oBinder, "ExpelledVestige");
    DeletePersistantLocalInt(oBinder, "ExpelledVestige" + IntToString(VESTIGE_ANDRAS));
    DeleteLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_ANDRAS));
    if (GetIsObjectValid(oAllyHench))
    {
        RemoveHenchman(oBinder, oAllyHench);
        SetPlotFlag(oAllyHench, FALSE);
        DestroyObject(oAllyHench);
    }
    RemoveSpellEffectsByID(oBinder, VESTIGE_BUER);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_BUER);
}

void RunTestSuite_BinderBasic_Step5(object oBinder, object oMount, object oAllyHench)
{
    // Verify BF-15b/c after EVENT_ONPLAYERREST_FINISHED processed in Step4
    AssertInt("BF-15b: EVENT_ONPLAYERREST_FINISHED scrubs unbound Focalor (9049..9051) and Andras (9057..9059) skin feats",
        GetHasFeat(9049, oBinder) || GetHasFeat(9050, oBinder) || GetHasFeat(9051, oBinder) ||
        GetHasFeat(9057, oBinder) || GetHasFeat(9058, oBinder) || GetHasFeat(9059, oBinder), FALSE);
    AssertTrue("BF-15c: EVENT_ONPLAYERREST_FINISHED preserves skin feats of still-bound VESTIGE_BUER (9060)",
        GetHasFeat(9060, oBinder));

    // Verify BF-16b/c after EVENT_ONPLAYERREST_FINISHED ran CleanupAndrasMount
    AssertInt("BF-16b: EVENT_ONPLAYERREST_FINISHED destroys Andras warhorse and clears oX3PaladinMount / nX3_PALADIN_UNSUMMON",
        GetIsObjectValid(oMount) ||
        GetIsObjectValid(GetLocalObject(oBinder, "oX3PaladinMount")) ||
        GetLocalInt(oBinder, "AndrasMount") ||
        GetLocalInt(oBinder, "nX3_PALADIN_UNSUMMON"), FALSE);
    AssertTrue("BF-16c: CleanupAndrasMount preserves non-mount campaign henchman",
        GetIsObjectValid(oAllyHench) && GetMaster(oAllyHench) == oBinder);

    // Test ExpelVestige(VESTIGE_ANDRAS) while mounted on Andras's heavy warhorse
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_ANDRAS), TRUE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_ANDRAS), oBinder, 60.0f);
    ExecuteScript("bnd_vest_andmnt", oBinder);
    object oMount2 = GetLocalObject(oBinder, "AndrasMountObj");
    SetSkinInt(oBinder, "nX3_StoredFootstep", GetFootstepType(oBinder));
    SetSkinInt(oBinder, "nX3_HorseRiderPhenotype", GetPhenoType(oBinder));
    SetSkinInt(oBinder, "nX3_HorseRiderAppearance", GetAppearanceType(oBinder));
    SetSkinInt(oBinder, "nX3_HorseRiderTail", GetCreatureTailType(oBinder));
    SetSkinString(oBinder, "sX3_HorseResRef", "x3_palhrs2");
    SetSkinInt(oBinder, "bX3_IS_MOUNTED", TRUE);

    ExpelVestige(oBinder, VESTIGE_ANDRAS);
    AssertInt("BF-16d: ExpelVestige(VESTIGE_ANDRAS) dismounts rider from Andras warhorse and clears AndrasMount flag",
        GetSkinInt(oBinder, "bX3_IS_MOUNTED") || GetLocalInt(oBinder, "AndrasMount"), FALSE);

    DelayCommand(0.45f, RunTestSuite_BinderBasic_Step6(oBinder, oMount2, oAllyHench));
}

void RunTestSuite_BinderBasic_Step4(object oBinder, object oTarget, object oMage, object oSword, int nBaseHP)
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

    // Clean up prior test effects on oBinder and oTarget
    RemoveSpellEffectsByID(oBinder, VESTIGE_TENEBROUS);
    RemoveSpellEffectsByID(oBinder, VESTIGE_GERYON);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_TENEBROUS);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_GERYON);
    ClearAllEffectsOn(oTarget);

    // -------------------------------------------------------------------------
    // BF-15 & BF-16: Rest unbound skin-feat scrubbing & Andras Mount cleanup
    // (VESTIGE_BUER + Focalor/Andras/Buer skin feats were applied in Step3 so
    //  engine effect & item-property queues are already materialized here)
    // -------------------------------------------------------------------------
    AssertTrue("BF-15a: Pre-rest skin holds Focalor (9049), Andras (9059), and Buer (9060) bonus feats",
        GetHasFeat(9049, oBinder) && GetHasFeat(9059, oBinder) && GetHasFeat(9060, oBinder));

    object oAllyHench = CreateObject(OBJECT_TYPE_CREATURE, "nw_bandit001", GetLocation(oBinder), FALSE, "HARNESS_ALLY_HENCH");
    SetPlotFlag(oAllyHench, TRUE);
    AddHenchman(oBinder, oAllyHench);

    DeleteLocalInt(oBinder, "AndrasMount");
    DeleteLocalObject(oBinder, "AndrasMountObj");
    DeleteLocalObject(oBinder, "oX3PaladinMount");
    ExecuteScript("bnd_vest_andmnt", oBinder);
    object oMount = GetLocalObject(oBinder, "AndrasMountObj");
    AssertTrue("BF-16a: bnd_vest_andmnt summons heavy warhorse henchman and records AndrasMountObj / oX3PaladinMount",
        GetLocalInt(oBinder, "AndrasMount") &&
        GetIsObjectValid(oMount) &&
        GetLocalObject(oBinder, "oX3PaladinMount") == oMount &&
        GetMaster(oMount) == oBinder);

    SetLocalInt(GetModule(), "prc_eventhook_running", EVENT_ONPLAYERREST_FINISHED);
    ExecuteScript("bnd_events", oBinder);
    DeleteLocalInt(GetModule(), "prc_eventhook_running");

    DelayCommand(0.35f, RunTestSuite_BinderBasic_Step5(oBinder, oMount, oAllyHench));
}

void RunTestSuite_BinderBasic_Step3(object oHelper, object oBinder, object oTarget, object oMage, object oSword, int nBaseHP)
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

    // Stage BF-15 setup one tick ahead so VESTIGE_BUER effect and skin bonus feats are materialized in Step4
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_BUER), oBinder, 60.0f);
    RestoreVestigeSkinFeats(oBinder, VESTIGE_BUER);
    RestoreVestigeSkinFeats(oBinder, VESTIGE_FOCALOR);
    RestoreVestigeSkinFeats(oBinder, VESTIGE_ANDRAS);

    DelayCommand(0.35f, RunTestSuite_BinderBasic_Step4(oBinder, oTarget, oMage, oSword, nBaseHP));
}

void RunTestSuite_BinderBasic_Step2(object oHelper, object oBinder, object oTarget, object oMage, object oSword, int nBaseHP)
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

    DelayCommand(0.35f, RunTestSuite_BinderBasic_Step3(oHelper, oBinder, oTarget, oMage, oSword, nBaseHP));
}

void RunTestSuite_BinderBasic(object oHelper, object oBinder, object oTarget)
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

    // BF-03d: Shared skin feat (IP_CONST_FEAT_BLINDFIGHT) is preserved when scrubbing Chupoclops while Ipos is still bound
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_IPOS), oBinder, 60.0f);
    RestoreVestigeSkinFeats(oBinder, VESTIGE_CHUPOCLOPS);
    RestoreVestigeSkinFeats(oBinder, VESTIGE_IPOS);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_CHUPOCLOPS);
    AssertTrue("BF-03d: ScrubVestigeSkinFeats(VESTIGE_CHUPOCLOPS) preserves shared FEAT_BLIND_FIGHT while VESTIGE_IPOS is still bound",
        GetHasFeat(FEAT_BLIND_FIGHT, oBinder));
    RemoveSpellEffectsByID(oBinder, VESTIGE_IPOS);
    ScrubVestigeSkinFeats(oBinder, VESTIGE_IPOS);

    // BF-14: Per-ability ExploitVestige_<id> multi-vestige support & ClearExploitVestigeState
    SetLocalInt(oBinder, "ExploitVestige_19070", TRUE);
    SetLocalInt(oBinder, "ExploitVestige_19088", TRUE);
    AssertTrue("BF-14a: GetIsVestigeExploited tracks multiple exploited vestige abilities independently without blocking unexploited abilities",
        GetIsVestigeExploited(oBinder, 19070) && GetIsVestigeExploited(oBinder, 19088) && !GetIsVestigeExploited(oBinder, 19096));
    ClearExploitVestigeState(oBinder);
    AssertInt("BF-14b: ClearExploitVestigeState clears all per-ability ExploitVestige_<id> locals",
        GetIsVestigeExploited(oBinder, 19070) || GetIsVestigeExploited(oBinder, 19088), FALSE);

    // -------------------------------------------------------------------------
    // BF-04: ApplyBinderWeaponDRBypass max(+5 Aym, +3/+1 Ronove) order independence
    // -------------------------------------------------------------------------
    object oSword = CreateItemOnObject("nw_wswls001", oBinder);
    object oBow = CreateItemOnObject("nw_wbwln001", oBinder);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_AYM), oBinder, 60.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_RONOVE), oBinder, 60.0f);
    ApplyBinderWeaponDRBypass(oBinder, oSword);
    ApplyBinderWeaponDRBypass(oBinder, oBow);
    AssertInt("BF-04a: ApplyBinderWeaponDRBypass applies +5 (max of Aym +5 and Ronove +3)",
        CountAttackBonusPropertyValue(oSword), 5);
    AssertInt("BF-04d: ApplyBinderWeaponDRBypass does not apply melee-only Aym/Ronove DR bypass to ranged weapons",
        CountAttackBonusPropertyValue(oBow), 0);
    DestroyObject(oBow);
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

    DelayCommand(0.35f, RunTestSuite_BinderBasic_Step2(oHelper, oBinder, oTarget, oMage, oSword, nBaseHP));
}
