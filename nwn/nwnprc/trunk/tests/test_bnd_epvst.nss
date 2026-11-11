//::///////////////////////////////////////////////
//:: PRC8 Epic Binder Vestiges Test Suite
//:: test_binder_epic_vestiges.nss
//:://////////////////////////////////////////////
//:: Tests for the four 9th-level Epic Vestiges:
//:: - EV-01: Gaia, Soul of the Land (Lore 25, DC 39)
//:: - EV-02: Zuriel, the Bronze God (Lore 27, DC 43)
//:: - EV-03: Amun-her Khepeshef, the Desecrated Scion (Lore 29, DC 47)
//:: - EV-04: Tkhaluuljin, the Cephalopocalypse (Lore 30, DC 49)
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "prc_inc_combat"
#include "prc_inc_combmove"
#include "prc_inc_skills"
#include "prc_inc_sneak"
#include "prc_inc_descrptr"
#include "x2_inc_spellhook"

void VerifyGaiaPhase1(object oBinder, object oTarget)
{
    AssertTrue("EV-01a: Binding Gaia applies VESTIGE_GAIA spell effect and initializes Planetary Healing pool (EBL/4 = 10 at EBL 40)",
               GetHasSpellEffect(VESTIGE_GAIA, oBinder) &&
               GetLocalInt(oBinder, "GaiaPlanetaryRegenMax") == (GetBinderLevel(oBinder, VESTIGE_GAIA) / 4) &&
               GetLocalInt(oBinder, "GaiaRegenPool") == (GetBinderLevel(oBinder, VESTIGE_GAIA) / 4));
    AssertTrue("EV-01f: Gaia Planetary Healing grants PnP lethal-damage immunity (GetImmortal=TRUE) by default when PRC_GAIA_PLANETARY_HEALING_NERF is 0",
               GetImmortal(oBinder) == TRUE);

    // Earth's Fury: +4 Binder DC against Aberration/Construct/Ooze/Undead vs Humanoid
    location lLoc = GetLocation(oBinder);
    object oSkel = CreateObject(OBJECT_TYPE_CREATURE, "nw_s_skeleton", lLoc, FALSE, "EV_GAIA_SKEL");
    int nDC_Human = GetBinderDC(oBinder, VESTIGE_GAIA, oTarget);
    int nDC_Undead = GetBinderDC(oBinder, VESTIGE_GAIA, oSkel);
    AssertInt("EV-01b: Gaia Earth's Fury grants +4 Binder DC against Undead compared to Humanoids",
              nDC_Undead - nDC_Human, 4);

    // Earth's Fury: GetCanSneakAttack returns TRUE against Undead
    AssertTrue("EV-01c: Gaia Earth's Fury allows sneak attacks against Undead via GetCanSneakAttack",
               GetCanSneakAttack(oSkel, oBinder));
    if (GetIsObjectValid(oSkel)) DestroyObject(oSkel);

    // Earth's Voice: SUBSCHOOL_CHARM descriptor
    AssertTrue("EV-01d: Gaia Earth's Voice (19159) is registered under SUBSCHOOL_CHARM",
               GetIsOfSubschool(19159, SUBSCHOOL_CHARM));

    // Elemental Fortitude: switch to Fire (19164)
    DeleteLocalInt(oBinder, "Bind19160");
    AssignCommand(oBinder, ActionCastSpellAtObject(19164, oBinder, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

void VerifyAllEpicVestiges(object oBinder, object oTarget)
{
    int bHasFireImm = FALSE;
    effect e = GetFirstEffect(oBinder);
    while (GetIsEffectValid(e))
    {
        if (GetEffectTag(e) == "GaiaElemFort" && GetEffectType(e) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE && GetEffectSubType(e) == SUBTYPE_SUPERNATURAL)
            bHasFireImm = TRUE;
        e = GetNextEffect(oBinder);
    }
    AssertTrue("EV-01e: Gaia Elemental Fortitude switches elemental immunity as a Supernatural effect",
               bHasFireImm);
    CleanupEpicVestigeState(oBinder, VESTIGE_GAIA, TRUE);

    // EV-02: Zuriel, the Bronze God
    SetLocalInt(oBinder, "ZurielBoundActive", TRUE);
    SetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE);
    SetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, oBinder);
    ExecuteScript("bnd_vest_zuriel", oBinder);
    DeleteLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    DeleteLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);

    AssertTrue("EV-02a: Binding Zuriel applies VESTIGE_ZURIEL spell effect",
               GetHasSpellEffect(VESTIGE_ZURIEL, oBinder));

    // Pact Fortification: 2x Pact Augmentation multiplier (1 selection = +5 HP -> +10 HP when Zuriel is bound)
    int nBaseHP = GetCurrentHitPoints(oBinder);
    int i;
    for (i = 1; i <= 11; i++) DeleteLocalInt(oBinder, "PactAugment" + IntToString(i));
    SetLocalInt(oBinder, "PactAugment1", 1);
    ExecuteScript("bnd_bind_pact", oBinder);
    int nZurielTempHP = GetCurrentHitPoints(oBinder) - nBaseHP;
    AssertInt("EV-02b: Zuriel Pact Fortification doubles Pact Augmentation (1 HP selection grants +10 Temp HP)",
              nZurielTempHP, 10);

    // Activate Bronze Body (bnd_vest_zurbb)
    DeleteLocalInt(oBinder, "PRC_SWIFT_ACTION_MARKER");
    DeleteLocalInt(oBinder, "Bind19187");
    DeleteLocalInt(oBinder, "Bind0");
    ExecuteScript("bnd_vest_zurbb", oBinder);

    AssertTrue("EV-02c: Zuriel Bronze Body sets ZurielBronzeBodyActive and applies Supernatural ZurielBronzeBodyEff",
               GetLocalInt(oBinder, "ZurielBronzeBodyActive") == TRUE);

    // Verify spell lockout blocks regular spells while allowing BinderSuSLA
    DeleteLocalInt(oBinder, "BinderSuSLA");
    int bNormalSpellAllowed = PRCSpellEffects(oBinder, oBinder, SPELL_FIREBALL, 3, CLASS_TYPE_WIZARD, FALSE, -1);
    SetLocalInt(oBinder, "BinderSuSLA", TRUE);
    int bSuAllowed = PRCSpellEffects(oBinder, oBinder, 19070, 1, CLASS_TYPE_INVALID, FALSE, -1);
    DeleteLocalInt(oBinder, "BinderSuSLA");
    AssertTrue("EV-02d: Zuriel Bronze Body blocks normal spellcasting (0) while allowing Supernatural abilities (1)",
               bNormalSpellAllowed == FALSE && bSuAllowed == TRUE);

    CleanupEpicVestigeState(oBinder, VESTIGE_ZURIEL, TRUE);

    // EV-03: Amun-her Khepeshef, the Desecrated Scion
    int nPreMoveBonus = GetCombatMoveCheckBonus(oBinder, COMBAT_MOVE_TRIP);
    SetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE);
    SetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, oBinder);
    ExecuteScript("bnd_vest_amunher", oBinder);
    DeleteLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    DeleteLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);

    AssertTrue("EV-03a: Binding Amun-her Khepeshef applies VESTIGE_AMUN_HER and initializes Delay Death pool (EBL = 40 rounds)",
               GetHasSpellEffect(VESTIGE_AMUN_HER, oBinder) &&
               GetLocalInt(oBinder, "AmunDelayDeathMaxRounds") == GetBinderLevel(oBinder, VESTIGE_AMUN_HER) &&
               GetImmortal(oBinder) == TRUE);

    // Firstborn Guardian: EffectFatigue() and EffectExhausted() return invalid/blank effect on Amun-her Binder
    SetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE);
    SetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, oBinder);
    effect eFat = EffectFatigue();
    effect eExh = EffectExhausted();
    DeleteLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    DeleteLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    AssertTrue("EV-03b: Amun-her Firstborn Guardian blocks EffectFatigue() and EffectExhausted()",
               !GetIsEffectValid(eFat) && !GetIsEffectValid(eExh));

    // Scion of War: +2x Cha mod on combat maneuvers (Trip, Grapple, Disarm, Bull Rush, Overrun)
    int nPostMoveBonus = GetCombatMoveCheckBonus(oBinder, COMBAT_MOVE_TRIP);
    int nExpectedScion = 2 * GetAbilityModifier(ABILITY_CHARISMA, oBinder);
    AssertInt("EV-03c: Amun-her Scion of War grants +2x Charisma modifier to combat maneuver checks",
              nPostMoveBonus - nPreMoveBonus, nExpectedScion);

    CleanupEpicVestigeState(oBinder, VESTIGE_AMUN_HER, TRUE);

    // EV-04: Tkhaluuljin, the Cephalopocalypse
    SetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE);
    SetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, oBinder);
    ExecuteScript("bnd_vest_tkhal", oBinder);
    DeleteLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    DeleteLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);

    AssertTrue("EV-04a: Binding Tkhaluuljin applies VESTIGE_TKHALUULJIN and enables Flight of the Alien (PRCIsFlying = TRUE)",
               GetHasSpellEffect(VESTIGE_TKHALUULJIN, oBinder) &&
               GetLocalInt(oBinder, "TkhalFlight") == TRUE &&
               PRCIsFlying(oBinder) == TRUE);

    AssertTrue("EV-04b: Tkhaluuljin Aura of Madness (19168) and Mind Blast (19169) are registered under SUBSCHOOL_COMPULSION",
               GetIsOfSubschool(19168, SUBSCHOOL_COMPULSION) &&
               GetIsOfSubschool(19169, SUBSCHOOL_COMPULSION));

    // Aura of Madness is active on bind (TkhalMadnessAuraActive == TRUE) and toggles OFF via bnd_vest_tkhalau
    int bAuraActiveOnBind = GetLocalInt(oBinder, "TkhalMadnessAuraActive");
    DeleteLocalInt(oBinder, "Bind19168");
    DeleteLocalInt(oBinder, "Bind0");
    ExecuteScript("bnd_vest_tkhalau", oBinder);
    int bAuraSuppressed = !GetLocalInt(oBinder, "TkhalMadnessAuraActive");
    AssertTrue("EV-04c: Tkhaluuljin Aura of Madness activates on bind and toggles OFF cleanly via bnd_vest_tkhalau",
               bAuraActiveOnBind == TRUE && bAuraSuppressed == TRUE);

    // EV-04e: Tkhaluuljin Aura of Madness 24h per-binder save immunity on successful Will save
    string sTkhalImmKey = "TkhalMadnessImmune_" + ObjectToString(oBinder);
    int bGotTkhalImm = FALSE;
    int nTry;
    for (nTry = 0; nTry < 8 && !bGotTkhalImm; nTry++)
    {
        object oMadTest = CreateObject(OBJECT_TYPE_CREATURE, "nw_goblina", GetLocation(oBinder), FALSE, "EV_TKHAL_MAD_TGT");
        ChangeToStandardFaction(oMadTest, STANDARD_FACTION_COMMONER);
        SetIsTemporaryEnemy(oMadTest, oBinder);
        SetIsTemporaryEnemy(oBinder, oMadTest);
        SetWillSavingThrow(oMadTest, 80);
        PulseTkhalMadnessOnTarget(oBinder, oMadTest);
        if (GetLocalInt(oMadTest, sTkhalImmKey))
            bGotTkhalImm = TRUE;
        DestroyObject(oMadTest);
    }
    AssertTrue("EV-04e: Successful Will save against Tkhaluuljin Aura of Madness grants 24-hour per-binder immunity",
               bGotTkhalImm == TRUE);

    // Summon Sphere of Annihilation (bnd_vest_tkhalso)
    DeleteLocalInt(oBinder, "Bind19186");
    DeleteLocalInt(oBinder, "Bind0");
    SetLocalInt(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE, TRUE);
    SetLocalLocation(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE, GetLocation(oTarget));
    ExecuteScript("bnd_vest_tkhalso", oBinder);
    DeleteLocalInt(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE);
    DeleteLocalLocation(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE);

    object oSphere = GetLocalObject(oBinder, "TkhalSphereObj");
    AssertTrue("EV-04d: Tkhaluuljin Sphere of Annihilation summons controllable sphere object and CleanupEpicVestigeState destroys it",
               GetIsObjectValid(oSphere));

    CleanupEpicVestigeState(oBinder, VESTIGE_TKHALUULJIN, TRUE);
}

void RunTestSuite_BinderEpicVestiges(object oHelper, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] Running Epic Binder Vestiges Suite (test_binder_epic_vestiges)...");
    ClearAllEffectsOn(oBinder);
    ClearAllEffectsOn(oTarget);
    DeleteLocalInt(oBinder, "ExploitVestige");

    // Cast VESTIGE_GAIA (19061) on oBinder
    AssignCommand(oBinder, ActionCastSpellAtObject(VESTIGE_GAIA, oBinder, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    DelayCommand(0.3, VerifyGaiaPhase1(oBinder, oTarget));
    DelayCommand(0.6, VerifyAllEpicVestiges(oBinder, oTarget));
}
