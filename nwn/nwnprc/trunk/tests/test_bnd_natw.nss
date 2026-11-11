//::///////////////////////////////////////////////
//:: Binder Natural Weapons & Unarmed Strike Test Suite
//:: test_binder_natweap.nss
//:://////////////////////////////////////////////
//:: Verifies Amon's Ram Attack primary/secondary gore registration and +0.5x
//:: Strength piercing bonus, Ipos's dual Cold Iron Claws in CWEAPON_L and
//:: CWEAPON_R with +3/+5 DR bypass and Rend OnHit hook, 1-based
//:: NaturalWeaponPlayerOverride switching (gore, claws, unarmed), Ronove + Aym
//:: unarmed fist DR bypass, and RemoveVestigeNaturalWeapons cleanup.
//:://////////////////////////////////////////////

#include "prc_inc_unarmed"

int HasDamageBonusPropertyOfType(object oWeapon, int nDmgType)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS &&
            GetItemPropertySubType(ip) == nDmgType)
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return FALSE;
}

int HasOnHitUniquePowerProperty(object oWeapon)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ONHITCASTSPELL &&
            GetItemPropertySubType(ip) == IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER)
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return FALSE;
}

void RunTestSuite_BinderNatWeap_Step4(object oBinder, object oClawL, object oClawR)
{
    // Now that VESTIGE_AYM + VESTIGE_RONOVE from Step3 are active on oBinder, verify +5 on claws and unarmed fist
    ApplyVestigePrimaryNaturalWeaponProps(oBinder, oClawL, GetResRef(oClawL));
    ApplyVestigePrimaryNaturalWeaponProps(oBinder, oClawR, GetResRef(oClawR));
    AssertTrue("NW-02c: Binding Aym upgrades Ipos claw DR bypass from +3 to +5 on both claws",
        CountAttackBonusPropertyValue(oClawL) == 5 && CountAttackBonusPropertyValue(oClawR) == 5);

    SetPersistantLocalInt(oBinder, "NaturalWeaponPlayerOverride", -1);
    SetPrimaryNaturalWeapon(oBinder, -1);
    AssertInt("NW-03c: NaturalWeaponPlayerOverride = -1 clears EquippedPrimaryNatWeapL/R and NATURAL_WEAPON_ATTACK_COUNT",
        GetIsObjectValid(GetLocalObject(oBinder, "EquippedPrimaryNatWeapL")) ||
        GetIsObjectValid(GetLocalObject(oBinder, "EquippedPrimaryNatWeapR")) ||
        GetLocalInt(oBinder, NATURAL_WEAPON_ATTACK_COUNT),
        FALSE);

    SetLocalInt(oBinder, "RonovesFists", 10);
    UnarmedFists(oBinder);
    DelayCommand(0.25f, AssertInt("NW-04b: Ronove + Aym UnarmedFists upgrades unarmed creature weapon DR bypass to +5",
        CountAttackBonusPropertyValue(GetLocalObject(oBinder, "EquippedUnarmedFist")), 5));

    // -------------------------------------------------------------------------
    // NW-05: RemoveVestigeNaturalWeapons cleanup
    // -------------------------------------------------------------------------
    RemoveVestigeNaturalWeapons(oBinder, 0);
    AssertInt("NW-05a: RemoveVestigeNaturalWeapons(0) clears Amon and Ipos primary natural weapon slots",
        array_get_string(oBinder, ARRAY_NAT_PRI_WEAP_RESREF, 0) == "" &&
        array_get_string(oBinder, ARRAY_NAT_PRI_WEAP_RESREF, 1) == "" &&
        array_get_string(oBinder, ARRAY_NAT_SEC_WEAP_RESREF, 0) == "" &&
        GetPersistantLocalInt(oBinder, "NaturalWeaponPlayerOverride") == 0,
        TRUE);

    DelayCommand(0.35f, DeleteLocalInt(oBinder, "RonovesFists"));
    DelayCommand(0.35f, RemoveSpellEffectsByID(oBinder, VESTIGE_AMON));
    DelayCommand(0.35f, RemoveSpellEffectsByID(oBinder, VESTIGE_IPOS));
    DelayCommand(0.35f, RemoveSpellEffectsByID(oBinder, VESTIGE_RONOVE));
    DelayCommand(0.35f, RemoveSpellEffectsByID(oBinder, VESTIGE_AYM));
    DelayCommand(0.35f, ScrubVestigeSkinFeats(oBinder, VESTIGE_AMON));
    DelayCommand(0.35f, ScrubVestigeSkinFeats(oBinder, VESTIGE_IPOS));
    DelayCommand(0.35f, ScrubVestigeSkinFeats(oBinder, VESTIGE_RONOVE));
    DelayCommand(0.35f, ScrubVestigeSkinFeats(oBinder, VESTIGE_AYM));
}

void RunTestSuite_BinderNatWeap_Step3(object oBinder)
{
    // Verify NW-04a after UnarmedFists' DelayCommand(0.1) in Step2 processed (before Amon replaces CWEAPON_L)
    object oFist = GetLocalObject(oBinder, "EquippedUnarmedFist");
    AssertInt("NW-04a: Ronove UnarmedFists at EBL 10 applies +3 DR bypass to unarmed creature weapon",
        CountAttackBonusPropertyValue(oFist), 3);

    // Clear VESTIGE_RONOVE temporarily so Amon's bForcePrimaryGore auto-equips Amon's gore
    RemoveSpellEffectsByID(oBinder, VESTIGE_RONOVE);

    // -------------------------------------------------------------------------
    // NW-01: Amon Ram Attack primary + secondary registration & +0.5x Str bonus
    // -------------------------------------------------------------------------
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", VESTIGE_AMON);
    SetLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", TRUE);
    SetLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", oBinder);
    ExecuteScript("bnd_vest_amon", oBinder);
    DeleteLocalInt(oBinder, "PRC_SPELLID_OVERRIDE");

    object oGoreL = GetLocalObject(oBinder, "EquippedPrimaryNatWeapL");
    string sPri0 = array_get_string(oBinder, ARRAY_NAT_PRI_WEAP_RESREF, 0);
    string sSec0 = array_get_string(oBinder, ARRAY_NAT_SEC_WEAP_RESREF, 0);
    AssertTrue("NW-01a: Amon bind registers prc_mino_gore_* in both primary and secondary natural weapon arrays",
        FindSubString(sPri0, "prc_mino_gore_") == 0 && FindSubString(sSec0, "prc_mino_gore_") == 0 && GetIsObjectValid(oGoreL));
    AssertTrue("NW-01b: Amon primary gore receives +0.5x Strength piercing damage bonus synchronously",
        HasDamageBonusPropertyOfType(oGoreL, IP_CONST_DAMAGETYPE_PIERCING));

    // -------------------------------------------------------------------------
    // NW-02: Ipos Cold Iron Claws dual equip (CWEAPON_L & CWEAPON_R), +3 DR bypass & Rend OnHit
    // -------------------------------------------------------------------------
    SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", VESTIGE_IPOS);
    ExecuteScript("bnd_vest_ipos", oBinder);
    DeleteLocalInt(oBinder, "PRC_SPELLID_OVERRIDE");
    DeleteLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");
    DeleteLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");

    object oClawL = GetLocalObject(oBinder, "EquippedPrimaryNatWeapL");
    object oClawR = GetLocalObject(oBinder, "EquippedPrimaryNatWeapR");
    AssertTrue("NW-02a: Ipos bind equips dual claws (prc_claw_1d6l_*) in both CWEAPON_L and CWEAPON_R",
        GetIsObjectValid(oClawL) && GetIsObjectValid(oClawR) &&
        FindSubString(GetResRef(oClawL), "prc_claw_1d6l_") == 0 &&
        FindSubString(GetResRef(oClawR), "prc_claw_1d6l_") == 0);
    AssertTrue("NW-02b: Ipos claws receive +3 DR bypass and Rend OnHitCastSpell synchronously",
        CountAttackBonusPropertyValue(oClawL) == 3 &&
        CountAttackBonusPropertyValue(oClawR) == 3 &&
        HasOnHitUniquePowerProperty(oClawL) &&
        HasOnHitUniquePowerProperty(oClawR));

    // -------------------------------------------------------------------------
    // NW-03a/b: 1-based NaturalWeaponPlayerOverride switching (1 = Amon gore, 2 = Ipos claws)
    // -------------------------------------------------------------------------
    SetPersistantLocalInt(oBinder, "NaturalWeaponPlayerOverride", 1);
    SetPrimaryNaturalWeapon(oBinder, 0);
    object oSwitchedL = GetLocalObject(oBinder, "EquippedPrimaryNatWeapL");
    AssertTrue("NW-03a: 1-based NaturalWeaponPlayerOverride = 1 selects index 0 (Amon gore)",
        GetIsObjectValid(oSwitchedL) && FindSubString(GetResRef(oSwitchedL), "prc_mino_gore_") == 0);

    SetPersistantLocalInt(oBinder, "NaturalWeaponPlayerOverride", 2);
    SetPrimaryNaturalWeapon(oBinder, 0);
    oSwitchedL = GetLocalObject(oBinder, "EquippedPrimaryNatWeapL");
    object oSwitchedR = GetLocalObject(oBinder, "EquippedPrimaryNatWeapR");
    AssertTrue("NW-03b: 1-based NaturalWeaponPlayerOverride = 2 selects index 1 (Ipos dual claws)",
        GetIsObjectValid(oSwitchedL) && GetIsObjectValid(oSwitchedR) &&
        FindSubString(GetResRef(oSwitchedL), "prc_claw_1d6l_") == 0 &&
        FindSubString(GetResRef(oSwitchedR), "prc_claw_1d6l_") == 0);

    // Apply VESTIGE_AYM and VESTIGE_RONOVE for Step4 (+5 upgrade check)
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_AYM), oBinder, 60.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_RONOVE), oBinder, 60.0f);

    DelayCommand(0.35f, RunTestSuite_BinderNatWeap_Step4(oBinder, oSwitchedL, oSwitchedR));
}

void RunTestSuite_BinderNatWeap_Step2(object oBinder)
{
    // Trigger UnarmedFists while VESTIGE_RONOVE is active and before Amon/Ipos equip natural weapons;
    // UnarmedFists adds ItemPropertyAttackBonus(3) via DelayCommand(0.1), which we verify in Step3!
    SetLocalInt(oBinder, "RonovesFists", 10);
    UnarmedFists(oBinder);

    DelayCommand(0.30f, RunTestSuite_BinderNatWeap_Step3(oBinder));
}

void RunTestSuite_BinderNatWeap(object oHelper, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] --- Suite: Binder Natural Weapons & Unarmed Strike Overhaul ---");

    array_delete(oBinder, ARRAY_NAT_PRI_WEAP_RESREF);
    array_delete(oBinder, ARRAY_NAT_PRI_WEAP_ATTACKS);
    array_delete(oBinder, ARRAY_NAT_SEC_WEAP_RESREF);
    DeletePersistantLocalInt(oBinder, "NaturalWeaponPlayerOverride");

    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
    if (GetIsObjectValid(oRight)) DestroyObject(oRight);
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oBinder);
    if (GetIsObjectValid(oLeft)) DestroyObject(oLeft);

    // Give oBinder +4 Strength (so Str modifier >= +2 and 0.5x Str >= +1) and VESTIGE_RONOVE + VESTIGE_AMON + VESTIGE_IPOS
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 4)), oBinder, 60.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_RONOVE), oBinder, 60.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_AMON), oBinder, 60.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), VESTIGE_IPOS), oBinder, 60.0f);

    DelayCommand(0.30f, RunTestSuite_BinderNatWeap_Step2(oBinder));
}
