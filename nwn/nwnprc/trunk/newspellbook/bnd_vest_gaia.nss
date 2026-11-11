/*
Gaia, Soul of the Land (Epic Vestige, Level 9, DC 39)
*/
#include "bnd_inc_bndfunc"

effect MakeEarthsFuryForRace(int nRace)
{
    effect eR = VersusRacialTypeEffect(EffectACIncrease(4, AC_DODGE_BONUS), nRace);
    eR = EffectLinkEffects(eR, VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 4), nRace));
    return eR;
}

void main()
{
    if (GetIsBinderInAntimagicField(OBJECT_SELF)) { FloatingTextStringOnCreature("Vestige supernatural abilities do not function inside an Antimagic Field!", OBJECT_SELF, FALSE); return; }
    object oBinder = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_GAIA);
    object oSkin = GetPCSkin(oBinder);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_BARKSKIN), EffectPact(oBinder, VESTIGE_GAIA));

    // Earth's Fury (+4 insight bonus to AC and +4 Saving Throws vs. Aberrations, Constructs, Oozes, and Undead,
    // +4 DC in GetBinderDC(), and critical hit / sneak attack immunity bypass in prc_inc_combat.nss and prc_inc_sneak.nss.
    // PnP / NWN Engine Divergence: NWN lacks an AC_INSIGHT_BONUS constant, so AC_DODGE_BONUS is used because dodge AC stacks in NWN.)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_FURY))
    {
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_ABERRATION));
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_CONSTRUCT));
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_OOZE));
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_UNDEAD));
        int nSlot;
        for (nSlot = 0; nSlot < 8; nSlot++)
        {
            int nInvSlot = -1;
            if (nSlot == 0) nInvSlot = INVENTORY_SLOT_RIGHTHAND;
            else if (nSlot == 1) nInvSlot = INVENTORY_SLOT_LEFTHAND;
            else if (nSlot == 2) nInvSlot = INVENTORY_SLOT_ARMS;
            else if (nSlot == 3) nInvSlot = INVENTORY_SLOT_CWEAPON_L;
            else if (nSlot == 4) nInvSlot = INVENTORY_SLOT_CWEAPON_R;
            else if (nSlot == 5) nInvSlot = INVENTORY_SLOT_CWEAPON_B;
            else if (nSlot == 6) nInvSlot = INVENTORY_SLOT_BOLTS;
            else if (nSlot == 7) nInvSlot = INVENTORY_SLOT_ARROWS;
            object oEq = GetItemInSlot(nInvSlot, oBinder);
            if (GetIsObjectValid(oEq))
            {
                AddEventScript(oEq, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
                IPSafeAddItemProperty(oEq, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
        }
        object oBullets = GetItemInSlot(INVENTORY_SLOT_BULLETS, oBinder);
        if (GetIsObjectValid(oBullets))
        {
            AddEventScript(oBullets, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
            IPSafeAddItemProperty(oBullets, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }

    // Earthsense (Dragon #363 p. 71: darkvision, low-light vision, tremorsense 30 ft., scent, and Track.
    // PnP / NWN Engine Divergence: NWN lacks distinct tremorsense/scent engine effects, so they are represented via
    // EffectUltravision(), EffectTrueSeeing(), +10 Spot & Search, and IP_CONST_FEAT_TRACK.)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHSENSE))
    {
        eLink = EffectLinkEffects(eLink, EffectUltravision());
        eLink = EffectLinkEffects(eLink, EffectTrueSeeing());
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 10));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 10));
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TRACK), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Earth's Voice (+10 Persuade & +10 Animal Empathy + persistent toggleable 30-ft Charm aura on non-friendly living creatures)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_VOICE))
    {
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE, 10));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 10));
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GAIA_VOICE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        effect eVoiceAura = EffectLinkEffects(
            EffectAreaOfEffect(136, "bnd_vest_gaiavce", "bnd_vest_gaiavch", "bnd_vest_gaiavcx"),
            EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_YELLOW)
        );
        eVoiceAura = TagEffect(SupernaturalEffect(eVoiceAura), "GaiaVoiceAura");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVoiceAura, oBinder);
        SetLocalInt(oBinder, "GaiaVoiceAuraActive", TRUE);
    }

    // Elemental Fortitude (4-element switchable radial, defaults to 100% Acid immunity on bind)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_ELEMENTAL_FORTITUDE))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GAIA_ELEMENTAL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        effect eElem = TagEffect(SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100)), "GaiaElemFort");
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eElem, oBinder, HoursToSeconds(24));
        SetLocalInt(oBinder, "GaiaElemFortType", DAMAGE_TYPE_ACID);
    }

    // Planetary Healing (Classic NWN Troll Regeneration = nBinderLevel / 4 overcome by fire/acid, shareable 1 point at a time & recallable;
    // controlled by PRC_GAIA_PLANETARY_HEALING_NERF: 0 = everyone with >=1 pt is a Troll, 1 = Option 1a single-creature Troll cap, 2 = fast healing only)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_PLANETARY_HEALING))
    {
        int nRegen = PRCMax(1, nBinderLevel / 4);
        SetLocalInt(oBinder, "GaiaPlanetaryRegen", nRegen);
        SetLocalInt(oBinder, "GaiaPlanetaryRegenMax", nRegen);
        SetLocalInt(oBinder, "GaiaPlanetaryRegenSelf", nRegen);
        DeleteLocalInt(oBinder, "GaiaRegenFireAcidLock");
        SetCreatureGaiaRegenEff(oBinder, nRegen, "GaiaPlanetaryRegenEff", HoursToSeconds(24));
        ReconcileGaiaTrollImmunity(oBinder);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GAIA_PLANETARY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(SetEffectSpellId(SupernaturalEffect(eLink), VESTIGE_GAIA), "VestigeMain_Gaia"), oBinder, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oBinder);
}
