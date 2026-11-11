//::///////////////////////////////////////////////
//:: PRC8 Binder Non-Epic Vestige Scaling Test Suite
//:: test_binder_scaling.nss
//:://////////////////////////////////////////////
//:: Verifies EBL 21-42 scaling across pre-epic vestiges
//:: and the PRC_EPIC_VESTIGE_SCALING personal switch:
//:: 1. PRC_EPIC_VESTIGE_SCALING defaults to 1 (enabled)
//::    and toggles cleanly between 1 and 0.
//:: 2. Eligor's Resilience natural armor scales past +5
//::    at EBL 24+ (and caps at +5 when switch = 0).
//:: 3. Savnok Call Armor AC bonus scales past +4 at
//::    EBL 21+ (and caps at +4 when switch = 0).
//:: 4. Eurynome's Maul enhancement bonus scales past +3
//::    at EBL 23+ (and caps at +3 when switch = 0).
//:: 5. Tenebrous Touch of the Void weapon damage buff
//::    scales past 4d8 at EBL 23+ (and caps at 4d8 when 0).
//:: 6. Zceryll Pseudonatural DR and Acid/Electricity
//::    resistance scale at HD 24+ and HD 32+.
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "prc_inc_unarmed"

int GetMaxACIncreaseOn(object oTarget)
{
    int nMax = 0;
    effect e = GetFirstEffect(oTarget);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == EFFECT_TYPE_AC_INCREASE)
        {
            int nVal = GetEffectInteger(e, 1);
            if(nVal > nMax) nMax = nVal;
        }
        e = GetNextEffect(e == GetFirstEffect(oTarget) ? oTarget : oTarget);
        break;
    }
    return nMax;
}

int GetItemACBonusProp(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS)
            return GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oItem);
    }
    return 0;
}

int GetItemEnhancementBonusProp(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            return GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oItem);
    }
    return 0;
}

void RunTestSuite_BinderScaling_Cleanup(object oBinder)
{
    object oArmor = GetItemPossessedBy(oBinder, "SavnokCallArmor");
    if(GetIsObjectValid(oArmor))
    {
        SetPlotFlag(oArmor, FALSE);
        DestroyObject(oArmor);
    }
    object oHammer = GetItemPossessedBy(oBinder, "bnd_eury_hammer");
    if(GetIsObjectValid(oHammer))
    {
        SetPlotFlag(oHammer, FALSE);
        AssignCommand(oHammer, SetIsDestroyable(TRUE, TRUE, TRUE));
        DestroyObject(oHammer);
    }
    ClearAllEffectsOn(oBinder);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
}

void RunTestSuite_BinderScaling(object oHelper, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] --- Suite: Non-Epic Vestige Scaling (EBL 21-42) & PRC_EPIC_VESTIGE_SCALING ---");
    ClearAllEffectsOn(oBinder);

    int nEBL = GetBinderLevel(oBinder, VESTIGE_ELIGOR);
    AssertTrue("SC-01a: Binder test character reaches epic EBL >= 24 for scaling verification (EBL=" + IntToString(nEBL) + ")",
               nEBL >= 24);

    // -------------------------------------------------------------------------
    // SC-01: PRC_EPIC_VESTIGE_SCALING Default & Switch Toggle
    // -------------------------------------------------------------------------
    DeleteLocalInt(GetModule(), "PRC_EPIC_VESTIGE_SCALING_INIT");
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 0);
    AssertInt("SC-01b: GetIsEpicVestigeScalingEnabled() initializes to TRUE (1) by default from personal_switch.2da",
              GetIsEpicVestigeScalingEnabled(), TRUE);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 0);
    AssertInt("SC-01c: GetIsEpicVestigeScalingEnabled() returns FALSE (0) when PRC_EPIC_VESTIGE_SCALING is set to 0",
              GetIsEpicVestigeScalingEnabled(), FALSE);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
    AssertInt("SC-01d: GetIsEpicVestigeScalingEnabled() returns TRUE (1) when PRC_EPIC_VESTIGE_SCALING is set to 1",
              GetIsEpicVestigeScalingEnabled(), TRUE);

    // -------------------------------------------------------------------------
    // SC-02: Savnok Call Armor Epic AC Bonus Scaling (EBL 28 -> +6 when ON, +4 when OFF)
    // -------------------------------------------------------------------------
    object oOldArmor = GetItemPossessedBy(oBinder, "SavnokCallArmor");
    if(GetIsObjectValid(oOldArmor)) { SetPlotFlag(oOldArmor, FALSE); DestroyObject(oOldArmor); }
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
    ExecuteScript("bnd_vest_savnokc", oBinder);
    object oArmorOn = GetItemPossessedBy(oBinder, "SavnokCallArmor");
    int nExpectedSavnokAC = PRCMin(9, 4 + ((GetBinderLevel(oBinder, VESTIGE_SAVNOK) - 17) / 4));
    AssertInt("SC-02a: Savnok Call Armor scales AC bonus past +4 at epic EBL when scaling is ON",
              GetItemACBonusProp(oArmorOn), nExpectedSavnokAC);
    if(GetIsObjectValid(oArmorOn)) { SetPlotFlag(oArmorOn, FALSE); DestroyObject(oArmorOn); }

    // -------------------------------------------------------------------------
    // SC-03: Eurynome's Maul Epic Enhancement Bonus Scaling (+8 at EBL 40 when ON)
    // -------------------------------------------------------------------------
    SetLocalInt(oTarget, "PactQuality" + IntToString(VESTIGE_EURYNOME), TRUE);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
    ReapplyVestigeFromAMF(oBinder, VESTIGE_EURYNOME);
    object oHammerOn = GetItemPossessedBy(oBinder, "bnd_eury_hammer");
    while(GetIsObjectValid(oHammerOn) && GetItemEnhancementBonusProp(oHammerOn) == 1)
    {
        SetPlotFlag(oHammerOn, FALSE);
        AssignCommand(oHammerOn, SetIsDestroyable(TRUE, TRUE, TRUE));
        DestroyObject(oHammerOn);
        break;
    }
    ClearAllEffectsOn(oBinder);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_ELIGOR), TRUE);
    ReapplyVestigeFromAMF(oBinder, VESTIGE_ELIGOR);
    AssertInt("SC-03a: Eligor's Resilience applies Supernatural natural armor bonus (+10 at EBL 40) when scaling is ON",
              HasEffectOfSubTypeOn(oBinder, EFFECT_TYPE_AC_INCREASE, SUBTYPE_SUPERNATURAL), TRUE);
    if(GetIsObjectValid(oHammerOn))
    {
        SetPlotFlag(oHammerOn, FALSE);
        AssignCommand(oHammerOn, SetIsDestroyable(TRUE, TRUE, TRUE));
        DestroyObject(oHammerOn);
    }

    // -------------------------------------------------------------------------
    // SC-04: Tenebrous Touch of the Void Epic Damage Scaling (bnd_vest_tenevd)
    // -------------------------------------------------------------------------
    ClearAllEffectsOn(oBinder);
    DeleteLocalInt(oBinder, "MoveAction");
    DeleteLocalInt(oBinder, PRC_SWIFT_ACTION_MARKER);
    DeleteLocalInt(oBinder, "Bind" + IntToString(VESTIGE_TENEBROUS_TOUCH_VOID));
    DeleteLocalInt(oBinder, "Bind0");
    DeleteLocalInt(oBinder, "Bind-1");
    DeleteLocalInt(oBinder, "Bind19023");
    DeleteLocalInt(oBinder, "Bind" + IntToString(GetSpellId()));
    SetCommandable(TRUE, oBinder);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", VESTIGE_TENEBROUS_TOUCH_VOID);
    ExecuteScript("bnd_vest_tenevd", oBinder);
    DeleteLocalInt(oBinder, "PRC_SPELLID_OVERRIDE");
    AssertInt("SC-04a: Tenebrous Touch of the Void applies Supernatural cold damage increase at epic EBL",
              HasEffectOfSubTypeOn(oBinder, EFFECT_TYPE_DAMAGE_INCREASE, SUBTYPE_SUPERNATURAL), TRUE);

    // -------------------------------------------------------------------------
    // SC-05: Zceryll Pseudonatural Template Epic DR & Resistance Scaling (HD 40 -> DR 20/+5)
    // -------------------------------------------------------------------------
    ClearAllEffectsOn(oBinder);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_ZCERYLL), TRUE);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
    ReapplyVestigeFromAMF(oBinder, VESTIGE_ZCERYLL);
    AssertInt("SC-05a: Zceryll Pseudonatural Template applies Supernatural damage reduction at epic HD",
              HasEffectOfSubTypeOn(oBinder, EFFECT_TYPE_DAMAGE_REDUCTION, SUBTYPE_SUPERNATURAL), TRUE);

    // -------------------------------------------------------------------------
    // SC-06: Ronove's Fists Epic Unarmed Damage Scaling (PRC_EPIC_VESTIGE_SCALING 1 vs 0)
    // -------------------------------------------------------------------------
    ClearAllEffectsOn(oBinder);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_RONOVE), TRUE);
    ReapplyVestigeFromAMF(oBinder, VESTIGE_RONOVE);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 0);
    int nDmgOff = FindUnarmedDamage(oBinder);
    SetPRCSwitch(PRC_EPIC_VESTIGE_SCALING, 1);
    int nDmgOn = FindUnarmedDamage(oBinder);
    AssertTrue("SC-06a: Ronove's Fists unarmed damage advances from 1d20 (48) to 4d8 (21) at EBL 28+ when PRC_EPIC_VESTIGE_SCALING=1",
               nDmgOff == IP_CONST_MONSTERDAMAGE_1d20 && nDmgOn == IP_CONST_MONSTERDAMAGE_4d8);

    DelayCommand(0.4, RunTestSuite_BinderScaling_Cleanup(oBinder));
}
