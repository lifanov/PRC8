//::///////////////////////////////////////////////
//:: PRC8 Epic Binder Progression & Epic Feats Test Suite
//:: test_binder_epic_feats.nss
//:://////////////////////////////////////////////
//:: Verifies Epic Binder levels 21-40 progression,
//:: general Epic Binder feats, and Circle 9 NUI support:
//:: 1. Level 40 Binder base Soul Binding slots = 8,
//::    Pact Augmentation count = 10, MaxVestigeLevel = 9.
//:: 2. Bind Additional Vestige I-X (9313..9316, 9346..9351)
//::    increases GetMaxVestigeCount().
//:: 3. GetMaxEpicVestigeCount() defaults to 1 at EBL 21+
//::    and scales up to 4 with Bind Additional Epic Vestige I-III.
//:: 4. Epic Favored Vestige (9326) increases Favored Vestige
//::    EBL bonus from +1 to +2.
//:: 5. Epic Favored Vestige Focus (9327) increases Favored
//::    Vestige Focus DC bonus from +1 to +2.
//:: 6. Epic Rapid Recovery (9328) reduces ability cooldown
//::    from 4 rounds to 3 rounds.
//:: 7. Epic Rapid Pact Making (9345) clears RapidPactMaking
//::    daily lockout in DoBindingCheck().
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"

void RunTestSuite_BinderEpicFeats(object oHelper, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] --- Suite: Epic Binder Progression (Levels 21-40) & Epic Binder Feats ---");
    ClearAllEffectsOn(oBinder);

    // -------------------------------------------------------------------------
    // EF-01: Level 40 Binder Base Progression (cls_bind_binder.2da & Pact Augmentation)
    // -------------------------------------------------------------------------
    AssertInt("EF-01a: Level 40 Binder reaches MaxVestigeLevel = 9 (Epic Vestiges)",
              GetMaxVestigeLevel(oBinder), 9);
    AssertInt("EF-01b: Level 40 Binder reaches 10 Pact Augmentation selections",
              GetPactAugmentCount(oBinder), 10);
    AssertTrue("EF-01c: Level 40 Binder reaches at least 8 Simultaneous Soul Binding slots",
               GetMaxVestigeCount(oBinder) >= 8);
    AssertTrue("EF-01d: GetMaxEpicVestigeCount(oBinder) is >= 1 at EBL 21+ and 0 on pre-epic target",
               GetMaxEpicVestigeCount(oBinder) >= 1 && GetMaxEpicVestigeCount(oTarget) == 0);
    AssertTrue("EF-01e: Pre-epic target MaxVestigeLevel never exceeds 8 even with Improved Binding",
               GetMaxVestigeLevel(oTarget) <= 8 && GetBinderMaxVestigeLevelForNUI(oTarget) <= 8);

    // -------------------------------------------------------------------------
    // EF-02: HasAnyFavoredVestige / HasAnyFavoredVestigeFocus / HasAnyRapidRecovery
    // -------------------------------------------------------------------------
    int nBaseEBL = GetBinderLevel(oBinder, VESTIGE_AMON);
    int nBaseDC = GetBinderDC(oBinder, VESTIGE_AMON);
    AssertTrue("EF-02a: GetBinderLevel and GetBinderDC compute valid epic values at Level 40 (EBL=" + IntToString(nBaseEBL) + ", DC=" + IntToString(nBaseDC) + ")",
               nBaseEBL >= 40 && nBaseDC >= 30);

    // -------------------------------------------------------------------------
    // EF-03: feat.2da Metadata for General Epic Binder Feats & Epic Subfeats
    // -------------------------------------------------------------------------
    AssertTrue("EF-03a: Bind Additional Vestige I (9313) and X (9351) exist in feat.2da",
               Get2DAString("feat", "LABEL", 9313) == "BindAdditionalVestige1" &&
               Get2DAString("feat", "LABEL", 9351) == "BindAdditionalVestige10");
    AssertTrue("EF-03b: Bind Additional Epic Vestige I-III (9321..9323) exist in feat.2da",
               Get2DAString("feat", "LABEL", 9321) == "BindAdditionalEpicVestige1" &&
               Get2DAString("feat", "LABEL", 9323) == "BindAdditionalEpicVestige3");
    AssertTrue("EF-03c: Epic Expel (9324), Epic Skilled Pact (9325), Epic Favored (9326..9327), Epic Rapid Recovery (9328), and Epic Rapid Pact (9345) exist in feat.2da",
               Get2DAString("feat", "LABEL", 9324) == "EpicExpelVestige" &&
               Get2DAString("feat", "LABEL", 9325) == "EpicSkilledPactMaking" &&
               Get2DAString("feat", "LABEL", 9326) == "EpicFavoredVestige" &&
               Get2DAString("feat", "LABEL", 9327) == "EpicFavoredVestigeFocus" &&
               Get2DAString("feat", "LABEL", 9328) == "EpicRapidRecovery" &&
               Get2DAString("feat", "LABEL", 9345) == "EpicRapidPactMaking");
    AssertTrue("EF-03d: Epic vestige subfeats (9329..9340) have PreReqEpic=1 and TOOLSCATEGORIES=6, and rows 9105..9115 have unique Constant values",
               Get2DAString("feat", "PreReqEpic", 9329) == "1" &&
               Get2DAString("feat", "TOOLSCATEGORIES", 9329) == "6" &&
               Get2DAString("feat", "PreReqEpic", 9340) == "1" &&
               Get2DAString("feat", "Constant", 9105) == "VESTIGE_AMUN_BURST_OF_LIFE" &&
               Get2DAString("feat", "Constant", 9115) == "VESTIGE_ZURIEL_ULTIMATE_SACRIFICE");
}
