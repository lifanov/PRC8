//::///////////////////////////////////////////////
//:: Binding/Vestiges main include: Miscellaneous
//:: bnd_inc_bndfunc
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to Binding.

    @author Stratovarius
    @date   Created - 2021.02.02
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines the given creature's Binder level. 
 * The vestige is used for Favored Vestige
 *
 * @param oBinder    The creature whose Binder level to determine
 * @param nVestige   The rowid of the vestige in spells.2da
 *
 * @return           The Binder level
 */
int GetBinderLevel(object oBinder, int nVestige = -1);

/**
 * Determines whether a given class is a Binding-related class or not.
 *
 * @param nClass CLASS_TYPE_* of the class to test
 * @return       TRUE if the class is a Binding-related class, FALSE otherwise
 */
int GetIsBindingClass(int nClass);

/**
 * Calculates how many Binder levels are gained by a given creature from
 * it's levels in prestige classes.
 *
 * @param oBinder Creature to calculate added Binder levels for
 * @return          The number of Binder levels gained
 */
int GetBindingPRCLevels(object oBinder);

/**
 * Returns the master 2da of all vestiges - "vestiges"
 */
string GetVestigeFile();

/**
 * Returns the master 2da of binds and bind levels - "cls_bind_binder"
 */
string GetBindingClassFile(int nClass);

/**
 * Casts a particular vestige on the binder
 * Should only ever be called via Contact Vestige
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige to attempt binding
 */
void ApplyVestige(object oBinder, int nVestige);

/**
 * Removes a particular vestige from the binder
 * Should only ever be called via Contact Vestige
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige to expel
 */
void ExpelVestige(object oBinder, int nVestige);

/**
 * Rolls the check to see whether it is a good or bad pact
 * Sets a local int to mark pact quality
 *
 * @param oBinder   The binder attempting the check
 * @param nVestige  The rowid of the vestige in vestiges.2da
 *
 * @return          The rowid of the vestige in spells.2da
 */
int DoBindingCheck(object oBinder, int nVestige);

/**
 * Does the animations and count down to bind a particular vestige
 *
 * @param oBinder   The binder
 * @param nTime     Should always be 66 seconds
 * @param nVestige  The vestige to attempt binding
 * @param nExpel    Whether this is a usage of expel vestige or not
 */
void ContactVestige(object oBinder, int nTime, int nVestige, int nExpel = FALSE);

/**
 * Does the animations and count down to bind a particular vestige
 * Should only ever be called via Contact Vestige
 *
 * @param oBinder   The binder
 * @param nTime     Should always be 60 seconds
 * @param nVestige  The vestige to attempt binding
 * @param nExpel    Whether this is a usage of expel vestige or not
 */
void BindVestige(object oBinder, int nTime, int nVestige, int nExpel = FALSE);

/**
 * Checks to see whether an ability is off cooldown or not
 * Sets the cooldown if the ability is usable
 * Informs the player via floating text
 *
 * @param oBinder   The binder
 * @param nAbil     The vestige ability (such as Amon's Fire Breath SpellId)
 * @param nVestige  The vestige the ability comes from (such as VESTIGE_AMON)
 *
 * @return          TRUE/FALSE for off cooldown or not
 */
int BindAbilCooldown(object oBinder, int nAbil, int nVestige);

/**
 * How many vestiges can the binder have bound
 *
 * @param oBinder   The binder
 *
 * @return          A number between 1 and 4
 */
int GetMaxVestigeCount(object oBinder);

/**
 * What is the highest level vestige the binder can bind?
 *
 * @param oBinder   The binder
 *
 * @return          A number between 1 and 8
 */
int GetMaxVestigeLevel(object oBinder);

/**
 * What is the vestige's level?
 *
 * @param nVestige  The vestige rowid in vestiges.2da
 *
 * @return          A number between 1 and 8
 */
int GetVestigeLevel(int nVestige);

/**
 * How many total binds are active on the binder?
 * Checks via the spellid of the vestiges
 *
 * @param oBinder   The binder
 *
 * @return          0 or higher
 */
int GetBindCount(object oBinder);

/**
 * How many uses of pact augmentation does the 
 * binder get when he binds a vestige?
 *
 * @param oBinder   The binder
 *
 * @return          0 to 5
 */
int GetPactAugmentCount(object oBinder);

/**
 * Returns the penalty to be applied if the
 * binder made a bad pact with the vestige
 * Should never be called directly
 *
 * @param oBinder   The binder
 *
 * @return          Linked effect
 */
effect EffectPact(object oBinder, int nVestige = -1);

/**
 * Checks whether the binder has the rapid recovery
 * feat for the named vestige
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige rowid in spells.2da
 *
 * @return          TRUE/FALSE
 */
int RapidRecovery(object oBinder, int nVestige);

/**
 * Checks whether the binder has the favored vestige
 * feat for the named vestige
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige rowid in spells.2da
 *
 * @return          TRUE/FALSE
 */
int FavoredVestige(object oBinder, int nVestige);

/**
 * Checks whether the binder has the favored vestige
 * focus feat for the named vestige
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige rowid in spells.2da
 *
 * @return          TRUE/FALSE
 */
int FavoredVestigeFocus(object oBinder, int nVestige);

/**
 * Returns the DC for saving against a vestige's abilities
 * 10 + 1/2 Binding level + Charisma Modifier + bonuses
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige rowid in spells.2da
 *
 * @return          A number
 */
int GetBinderDC(object oBinder, int nVestige);

/**
 * Checks for the special requirements of each vestige
 * or for the presence of the Ignore Special Requirements
 * feat. True means passing requirements, False is a fail
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige rowid in spells.2da
 *
 * @return          TRUE/FALSE
 */
int DoSpecialRequirements(object oBinder, int nVestige);
void ApplyBinderWeaponDRBypass(object oBinder, object oItem);
void ScrubVestigeSkinFeats(object oBinder, int nVestige);
void ScrubAllUnboundVestigeSkinFeats(object oBinder);
void CleanupAndrasMount(object oBinder);
void CleanupAgaresCompanion(object oBinder);
void RestoreVestigeSkinFeats(object oBinder, int nVestige);

/**
 * Checks for the special requirements of each vestige
 * or for the presence of the Ignore Special Requirements
 * feat. True means passing requirements, False is a fail
 *
 * This is for requirements that apply during the summoning process
 * due to having a cost that applies only after the user has selected
 * which vestige they wish to bind
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige rowid in spells.2da
 *
 * @return          TRUE/FALSE
 */
int DoSummonRequirements(object oBinder, int nVestige);

/**
 * Checks for whether the vestige ability was exploited (meaning not 
 * granted) by the Anima Mage class feature.
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige ability rowid in vestigeabil.2da
 *
 * @return          TRUE if exploited/FALSE otherwise
 */
int GetIsVestigeExploited(object oBinder, int nVestigeAbil);

/**
 * Marks a vestige ability as exploited (meaning it will not be
 * granted) by the Anima Mage class feature.
 *
 * @param oBinder   The binder
 * @param nVestige  The vestige ability rowid in vestigeabil.2da
 */
void SetIsVestigeExploited(object oBinder, int nVestigeAbil);
void ClearExploitVestigeState(object oBinder);

/**
 * Checks whether the patron vestige is bound to a Knight of the Sacred Seal
 * If not, the class loses all class features
 *
 * @param oBinder   The binder
 *
 * @return TRUE if bound, FALSE otherwise
 */
int GetIsPatronVestigeBound(object oBinder);

/**
 * Checks who the patron vestige is for a Knight of the Sacred Seal
 * Used to ensure they always have a good pact with their patron
 *
 * @param oBinder   The binder
 *
 * @return The VESTIGE_* const if one exists, -1 otherwise
 */
int GetPatronVestige(object oBinder);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

//////////////////////////////////////////////////
/*                  Constants                   */
//////////////////////////////////////////////////

const int VESTIGE_CONTACT_TIME = 66;
const int VESTIGE_BINDING_TIME = 60;

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetBinderLevel(object oBinder, int nVestige = -1)
{
    int nLevel;

    if(GetLevelByClass(CLASS_TYPE_BINDER, oBinder))
    {
        // Binder level is class level + prestige
        nLevel = GetLevelByClass(CLASS_TYPE_BINDER, oBinder);
        nLevel += GetBindingPRCLevels(oBinder);        
    }
    // If you have no levels in binder, but you have Bind Vestige feat
    else if (GetHasFeat(FEAT_BIND_VESTIGE, oBinder))
    {
    	nLevel = 1;
    	if (GetHasFeat(FEAT_BIND_VESTIGE_IMPROVED, oBinder)) nLevel += 4;
    }
    if (FavoredVestige(oBinder, nVestige)) nLevel += 1;
    if (GetHasSpellEffect(VESTIGE_IPOS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_IPOS_INFLUENCE) && nVestige >= VESTIGE_AMON) nLevel += 1;
    
    if(DEBUG) DoDebug("Binder Level: " + IntToString(nLevel));

    return nLevel;
}

int GetIsBindingClass(int nClass)
{
    return nClass == CLASS_TYPE_BINDER;
}

int GetBindingPRCLevels(object oBinder)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oBinder);
	nLevel += GetLevelByClass(CLASS_TYPE_KNIGHT_SACRED_SEAL, oBinder);
    nLevel += GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder);
    
    // These don't add at 1st level
    if (GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oBinder))
        nLevel += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oBinder) - 1;

    return nLevel;
}

string GetVestigeFile()
{
	return "vestiges";
}

string GetBindingClassFile(int nClass)
{
	string sFile;
	if (nClass == CLASS_TYPE_BINDER) sFile = "cls_bind_binder";
	
	return sFile;
}

int IsSkinFeatForVestige(int nSubType, int nVestige)
{
    if (nVestige == VESTIGE_AMON) return nSubType == IP_CONST_VESTIGE_AMON_BREATH;
    if (nVestige == VESTIGE_AYM) return nSubType == IP_CONST_FEAT_ARMOR_PROF_MEDIUM || nSubType == IP_CONST_FEAT_PRC_IMPROVED_DISARM || nSubType == IP_CONST_VESTIGE_AYM_HALO;
    if (nVestige == VESTIGE_LERAJE) return nSubType == 4607 || nSubType == 4610 || nSubType == IP_CONST_VESTIGE_LERAJE_RICOCHET || nSubType == IP_CONST_FEAT_POINTBLANK;
    if (nVestige == VESTIGE_NABERIUS) return nSubType == IP_CONST_VESTIGE_NABERIUS_DISGUISE || nSubType == IP_CONST_VESTIGE_NABERIUS_COMMAND;
    if (nVestige == VESTIGE_RONOVE) return nSubType == IP_CONST_VESTIGE_RONOVE_FARHAND || nSubType == IP_CONST_VESTIGE_RONOVE_BULLRUSH || nSubType == IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE;
    if (nVestige == VESTIGE_DAHLVERNAR) return nSubType == IP_CONST_VESTIGE_DAHLVER_MOAN || nSubType == IP_CONST_VESTIGE_DAHLVER_SHARE;
    if (nVestige == VESTIGE_HAAGENTI) return nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_BATTLEAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_HANDAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_THROWING_AXE || nSubType == IP_CONST_FEAT_SHIELD_PROFICIENCY || nSubType == IP_CONST_VESTIGE_HAAGENTI_TOUCH;
    if (nVestige == VESTIGE_MALPHAS) return nSubType == IP_CONST_FEAT_USE_POISON || nSubType == IP_CONST_VESTIGE_MALPHAS_EYE || nSubType == IP_CONST_VESTIGE_MALPHAS_INVIS_SW || nSubType == IP_CONST_VESTIGE_MALPHAS_INVIS_ST;
    if (nVestige == VESTIGE_SAVNOK) return nSubType == IP_CONST_VESTIGE_SAVNOK_CALL || nSubType == IP_CONST_FEAT_ARMOR_PROF_HEAVY || nSubType == IP_CONST_VESTIGE_SAVNOK_MOVE_SW || nSubType == IP_CONST_VESTIGE_SAVNOK_MOVE_ST;
    if (nVestige == VESTIGE_ANDROMALIUS) return nSubType == IP_CONST_VESTIGE_ANDRO_SEE || nSubType == IP_CONST_VESTIGE_ANDRO_LOCATE || nSubType == IP_CONST_VESTIGE_ANDRO_MIRTH;
    if (nVestige == VESTIGE_FOCALOR) return nSubType == IP_CONST_VESTIGE_FOCALOR_AURA || nSubType == IP_CONST_FEAT_WATER_BREATHING || nSubType == IP_CONST_VESTIGE_FOCALOR_BOLT || nSubType == IP_CONST_VESTIGE_FOCALOR_BREATH;
    if (nVestige == VESTIGE_KARSUS) return nSubType == IP_CONST_VESTIGE_KARSUS_SENSES || nSubType == IP_CONST_VESTIGE_KARSUS_TOUCH;
    if (nVestige == VESTIGE_PAIMON) return nSubType == IP_CONST_FEAT_UNCANNY_DODGE2 || nSubType == IP_CONST_FEAT_UNCANNY_DODGE1 || nSubType == IP_CONST_VESTIGE_PAIMON_DANCE || nSubType == IP_CONST_FEAT_WHIRLWIND || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_RAPIER || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTSWORD || nSubType == IP_CONST_FEAT_WEAPON_FINESSE;
    if (nVestige == VESTIGE_AGARES) return nSubType == IP_CONST_VESTIGE_AGARES_STEP || nSubType == IP_CONST_VESTIGE_AGARES_ELEMENTAL;
    if (nVestige == VESTIGE_ANDRAS) return nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_LONGSWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATSWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_RAPIER || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_DART || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SLING || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP || nSubType == IP_CONST_FEAT_IMPROVED_CRITICAL_MINDBLADE || nSubType == IP_CONST_VESTIGE_ANDRAS_SMITE || nSubType == IP_CONST_VESTIGE_ANDRAS_DISCORD || nSubType == IP_CONST_VESTIGE_ANDRAS_MOUNT;
    if (nVestige == VESTIGE_BUER) return nSubType == IP_CONST_VESTIGE_BUER_HEAL || nSubType == IP_CONST_FEAT_TRACK;
    if (nVestige == VESTIGE_EURYNOME) return nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_WARHAMMER;
    if (nVestige == VESTIGE_TENEBROUS) return nSubType == IP_CONST_VESTIGE_TENEBROUS_DARKNESS || nSubType == IP_CONST_VESTIGE_TENEBROUS_TOUCH_VOID || nSubType == IP_CONST_VESTIGE_TENEBROUS_TURN || nSubType == IP_CONST_VESTIGE_TENEBROUS_VESSEL || nSubType == IP_CONST_FEAT_MYST_FLICKER;
    if (nVestige == VESTIGE_ARETE) return nSubType == IP_CONST_FEAT_PSIONIC_FOCUS || nSubType == IP_CONST_VESTIGE_ARETE_RESISTANCE || nSubType == 12134 || nSubType == 12135;
    if (nVestige == VESTIGE_ASTAROTH) return nSubType == IP_CONST_VESTIGE_ASTAROTH_BREATH || nSubType == IP_CONST_VESTIGE_ASTAROTH_WORD;
    if (nVestige == VESTIGE_ACERERAK) return nSubType == IP_CONST_VESTIGE_ACERERAK_DETECT || nSubType == IP_CONST_VESTIGE_ACERERAK_HIDE || nSubType == IP_CONST_VESTIGE_ACERERAK_TOUCH;
    if (nVestige == VESTIGE_BALAM) return nSubType == IP_CONST_FEAT_IMPROVED_INIT || nSubType == IP_CONST_FEAT_THUG || nSubType == IP_CONST_VESTIGE_BALAM_CUNNING || nSubType == IP_CONST_VESTIGE_BALAM_GLARE || nSubType == IP_CONST_FEAT_WEAPON_FINESSE;
    if (nVestige == VESTIGE_DANTALION) return nSubType == IP_CONST_VESTIGE_DANTALION_AWE || nSubType == IP_CONST_VESTIGE_DANTALION_READ || nSubType == IP_CONST_VESTIGE_DANTALION_TRAVEL;
    if (nVestige == VESTIGE_GERYON) return nSubType == IP_CONST_VESTIGE_GERYON_GAZE || nSubType == IP_CONST_FEAT_UNCANNY_DODGE1 || nSubType == IP_CONST_FEAT_UNCANNY_DODGE2 || nSubType == IP_CONST_VESTIGE_GERYON_FLIGHT;
    if (nVestige == VESTIGE_OTIAX) return nSubType == IP_CONST_VESTIGE_OTIAX_AIR_BLAST || nSubType == IP_CONST_VESTIGE_OTIAX_OPEN || nSubType == IP_CONST_VESTIGE_OTIAX_UNLOCK;
    if (nVestige == VESTIGE_CHUPOCLOPS) return nSubType == IP_CONST_VESTIGE_CHUPOCLOPS_DESPAIR || nSubType == IP_CONST_VESTIGE_CHUPOCLOPS_ETHEREAL || nSubType == IP_CONST_FEAT_BLINDFIGHT;
    if (nVestige == VESTIGE_HAURES) return nSubType == IP_CONST_VESTIGE_HAURES_IMAGE || nSubType == IP_CONST_VESTIGE_HAURES_KILLER;
    if (nVestige == VESTIGE_IPOS) return nSubType == IP_CONST_FEAT_REND || nSubType == IP_CONST_FEAT_WEAPON_PROF_CREATURE || nSubType == IP_CONST_VESTIGE_IPOS_INSIGHT || nSubType == IP_CONST_FEAT_BLINDFIGHT;
    if (nVestige == VESTIGE_SHAX) return nSubType == IP_CONST_VESTIGE_SHAX_FREEDOM || nSubType == IP_CONST_VESTIGE_SHAX_STRIKE;
    if (nVestige == VESTIGE_ZAGAN) return nSubType == IP_CONST_VESTIGE_ZAGAN_AVERSION || nSubType == IP_CONST_FEAT_IMPROVED_GRAPPLE || nSubType == IP_CONST_FEAT_KEEN_SENSES;
    if (nVestige == VESTIGE_VANUS) return nSubType == IP_CONST_VESTIGE_VANUS_FREE_ALLY;
    if (nVestige == VESTIGE_THETRIAD) return nSubType == IP_CONST_FEAT_PSIONIC_FOCUS || nSubType == 12055 || nSubType == 12072 || nSubType == IP_CONST_VESTIGE_THE_TRIAD_SMITE || nSubType == 12127 || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTSWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_LONGSWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_BATTLEAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_LIGHT_FLAIL || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_WARHAMMER || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_LONGBOW || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_LIGHT_MACE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_HALBERD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTBOW || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_TWO_BLADED_SWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATSWORD || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_DART || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_DIRE_MACE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_DOUBLE_AXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_HEAVY_FLAIL || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_LIGHT_HAMMER || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_HANDAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_KAMA || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_KATANA || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_KUKRI || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_MORNINGSTAR || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_RAPIER || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SCIMITAR || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SCYTHE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTSPEAR || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SHURIKEN || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SICKLE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_SLING || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_THROWING_AXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_TRIDENT || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_DWARVEN_WARAXE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_WHIP || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_ELVEN_LIGHTBLADE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_ELVEN_THINBLADE || nSubType == IP_CONST_FEAT_WEAPON_PROFICIENCY_ELVEN_COURTBLADE || nSubType == IP_CONST_FEAT_WEAPON_PROF_MARTIAL || nSubType == IP_CONST_FEAT_WEAPON_PROF_SIMPLE || nSubType == IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
    if (nVestige == VESTIGE_DESHARIS) return nSubType == IP_CONST_VESTIGE_DESHARIS_TELEPORT || nSubType == IP_CONST_VESTIGE_DESHARIS_SMITE || nSubType == IP_CONST_VESTIGE_DESHARIS_ANIMATE;
    if (nVestige == VESTIGE_ZCERYLL) return nSubType == IP_CONST_VESTIGE_ZCERYLL_TRUE_STRIKE || nSubType == IP_CONST_FEAT_SPELL10 || nSubType == IP_CONST_VESTIGE_ZCERYLL_BOLTS || nSubType == IP_CONST_VESTIGE_ZCERYLL_SUMMON;
    if (nVestige == VESTIGE_ELIGOR) return nSubType == IP_CONST_VESTIGE_ELIGOR_STRIKE || nSubType == IP_CONST_FEAT_MOUNTED_COMBAT || nSubType == IP_CONST_FEAT_MOUNTED_ARCHERY || nSubType == IP_CONST_FEAT_ARMOR_PROF_HEAVY;
    if (nVestige == VESTIGE_MARCHOSIAS) return nSubType == IP_CONST_FEAT_PRC_DEATH_ATTACK || nSubType == IP_CONST_VESTIGE_MARCHOSIAS_SMOKE;
    if (nVestige == VESTIGE_ASHARDALON) return nSubType == IP_CONST_VESTIGE_ASHARDALON_LOCATE || nSubType == IP_CONST_VESTIGE_ASHARDALON_PRESENCE;
    if (nVestige == VESTIGE_HALPHAX) return nSubType == IP_CONST_VESTIGE_HALPHAX_IMPRISON || nSubType == IP_CONST_VESTIGE_HALPHAX_BARRIER || nSubType == IP_CONST_VESTIGE_HALPHAX_SHELTER;
    if (nVestige == VESTIGE_ORTHOS) return nSubType == IP_CONST_VESTIGE_ORTHOS_BREATH;
    if (nVestige == VESTIGE_ABYSM) return nSubType == IP_CONST_FEAT_PSIONIC_FOCUS || nSubType == 12098 || nSubType == 12119 || nSubType == 12105 || nSubType == 12051;
    return FALSE;
}

int IsSkinFeatGrantedByOtherBoundVestige(object oBinder, int nSubType, int nExcludeVestige)
{
    int nV;
    for (nV = VESTIGE_AMON; nV <= VESTIGE_ABYSM; nV++)
    {
        if (nV != nExcludeVestige && GetHasSpellEffect(nV, oBinder) && IsSkinFeatForVestige(nSubType, nV))
            return TRUE;
    }
    return FALSE;
}

int IsSkinFeatForAnyVestige(int nSubType)
{
    if (nSubType >= 13730 && nSubType <= 13815) return TRUE;
    int nV;
    for (nV = VESTIGE_AMON; nV <= VESTIGE_ABYSM; nV++)
    {
        if (IsSkinFeatForVestige(nSubType, nV))
            return TRUE;
    }
    return FALSE;
}

void ScrubVestigeSkinFeats(object oBinder, int nVestige)
{
    object oSkin = GetPCSkin(oBinder);
    if (!GetIsObjectValid(oSkin)) return;
    itemproperty ip = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
        {
            int nSub = GetItemPropertySubType(ip);
            if ((GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY || (nSub >= 13730 && nSub <= 13815)) &&
                IsSkinFeatForVestige(nSub, nVestige) &&
                !IsSkinFeatGrantedByOtherBoundVestige(oBinder, nSub, nVestige))
            {
                RemoveItemProperty(oSkin, ip);
            }
        }
        ip = GetNextItemProperty(oSkin);
    }
}

void ScrubAllUnboundVestigeSkinFeats(object oBinder)
{
    object oSkin = GetPCSkin(oBinder);
    if (!GetIsObjectValid(oSkin)) return;
    itemproperty ip = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
        {
            int nSub = GetItemPropertySubType(ip);
            if ((GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY || (nSub >= 13730 && nSub <= 13815)) &&
                IsSkinFeatForAnyVestige(nSub) &&
                !IsSkinFeatGrantedByOtherBoundVestige(oBinder, nSub, -1))
            {
                RemoveItemProperty(oSkin, ip);
            }
        }
        ip = GetNextItemProperty(oSkin);
    }
}

void CleanupAndrasMount(object oBinder)
{
    if (!GetIsObjectValid(oBinder)) return;

    int bHasOwnPaladinMount = (GetLevelByClass(CLASS_TYPE_PALADIN, oBinder) >= 5);
    object oTrackedMount = GetLocalObject(oBinder, "AndrasMountObj");
    int bHadAndrasFlag = GetLocalInt(oBinder, "AndrasMount") || GetIsObjectValid(oTrackedMount);

    DeleteLocalInt(oBinder, "AndrasMount");
    DeleteLocalObject(oBinder, "AndrasMountObj");

    // If currently mounted on Andras's summoned warhorse, dismount cleanly via bnd_vest_andmnt (which includes x3_inc_horse)
    if (bHadAndrasFlag)
        SetLocalInt(oBinder, "AndrasMountWasActive", TRUE);
    SetLocalInt(oBinder, "AndrasMountCleanupMode", TRUE);
    ExecuteScript("bnd_vest_andmnt", oBinder);
    DeleteLocalInt(oBinder, "AndrasMountCleanupMode");
    DeleteLocalInt(oBinder, "AndrasMountWasActive");

    object oPalMountVar = GetLocalObject(oBinder, "oX3PaladinMount");
    if (GetIsObjectValid(oTrackedMount))
    {
        if (oPalMountVar == oTrackedMount || !bHasOwnPaladinMount)
        {
            DeleteLocalObject(oBinder, "oX3PaladinMount");
            DeleteLocalInt(oBinder, "nX3_PALADIN_UNSUMMON");
        }
        if (oTrackedMount != oBinder)
        {
            RemoveHenchman(oBinder, oTrackedMount);
            SetPlotFlag(oTrackedMount, FALSE);
            AssignCommand(oTrackedMount, SetIsDestroyable(TRUE, FALSE, FALSE));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTrackedMount));
            DestroyObject(oTrackedMount);
        }
    }

    if (GetIsObjectValid(oPalMountVar) && oPalMountVar != oBinder && oPalMountVar != oTrackedMount)
    {
        if (GetLocalInt(oPalMountVar, "AndrasSummonedMount") ||
            (!bHasOwnPaladinMount && GetStringLeft(GetResRef(oPalMountVar), 9) == "x3_palhrs"))
        {
            DeleteLocalObject(oBinder, "oX3PaladinMount");
            DeleteLocalInt(oBinder, "nX3_PALADIN_UNSUMMON");
            RemoveHenchman(oBinder, oPalMountVar);
            SetPlotFlag(oPalMountVar, FALSE);
            AssignCommand(oPalMountVar, SetIsDestroyable(TRUE, FALSE, FALSE));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oPalMountVar));
            DestroyObject(oPalMountVar);
        }
    }

    int nIdx = 1;
    object oAssoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oBinder, nIdx);
    while (GetIsObjectValid(oAssoc))
    {
        object oNextAssoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oBinder, nIdx + 1);
        if (GetLocalInt(oAssoc, "AndrasSummonedMount") ||
            (!bHasOwnPaladinMount && GetStringLeft(GetResRef(oAssoc), 9) == "x3_palhrs"))
        {
            RemoveHenchman(oBinder, oAssoc);
            SetPlotFlag(oAssoc, FALSE);
            AssignCommand(oAssoc, SetIsDestroyable(TRUE, FALSE, FALSE));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oAssoc));
            DestroyObject(oAssoc);
            oAssoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oBinder, nIdx);
        }
        else
        {
            nIdx++;
            oAssoc = oNextAssoc;
        }
    }

    if (!bHasOwnPaladinMount && !GetIsObjectValid(GetLocalObject(oBinder, "oX3PaladinMount")))
    {
        DeleteLocalObject(oBinder, "oX3PaladinMount");
        DeleteLocalInt(oBinder, "nX3_PALADIN_UNSUMMON");
    }
}

void CleanupAgaresCompanion(object oBinder)
{
    if (!GetIsObjectValid(oBinder)) return;
    DeleteLocalInt(oBinder, "AgaresSummoned");
    int nIdx = 1;
    object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oBinder, nIdx);
    while (GetIsObjectValid(oSum))
    {
        object oNext = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oBinder, nIdx + 1);
        string sRes = GetResRef(oSum);
        if (GetLocalInt(oSum, "AgaresElementalSummon") ||
            sRes == "bnd_agares_small" || sRes == "bnd_agares_med" ||
            sRes == "bnd_agares_large" || sRes == "bnd_agares_huge")
        {
            SetPlotFlag(oSum, FALSE);
            AssignCommand(oSum, SetIsDestroyable(TRUE, FALSE, FALSE));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oSum));
            DestroyObject(oSum);
        }
        nIdx++;
        oSum = oNext;
    }
}


void RestoreVestigeSkinFeats(object oBinder, int nVestige)
{
    object oSkin = GetPCSkin(oBinder);
    if (!GetIsObjectValid(oSkin)) return;
    int nBinderLevel = GetBinderLevel(oBinder, nVestige);
    float fDur = HoursToSeconds(24);

    if (nVestige == VESTIGE_AMON && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AMON_FIREBREATH))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_AMON_BREATH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_AYM && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AYM_HALO_FIRE))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_AYM_HALO), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_LERAJE && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_LERAJE_RICOCHET))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_LERAJE_RICOCHET), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_NABERIUS && GetLevelByClass(CLASS_TYPE_BINDER, oBinder))
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_DISGUISE_SELF))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_NABERIUS_DISGUISE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_PERSUASIVE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_NABERIUS_COMMAND), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_RONOVE && GetLevelByClass(CLASS_TYPE_BINDER, oBinder))
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_RONOVE_FAR_HAND))
        {
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_RONOVE_FARHAND), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_RONOVE_BULLRUSH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
    }
    else if (nVestige == VESTIGE_DAHLVERNAR && GetLevelByClass(CLASS_TYPE_BINDER, oBinder))
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DAHLVERNAR_MADDENING_MOAN))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DAHLVER_MOAN), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DAHLVERNAR_SHIELD_SELF))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DAHLVER_SHARE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_HAAGENTI && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_HAAGENTI_CONFUSE))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_HAAGENTI_TOUCH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_MALPHAS)
    {
        if ((GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder)) && !GetIsVestigeExploited(oBinder, VESTIGE_MALPHAS_ARCANE_EYE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_MALPHAS_EYE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_MALPHAS_INVIS))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(nBinderLevel >= 15 ? IP_CONST_VESTIGE_MALPHAS_INVIS_SW : IP_CONST_VESTIGE_MALPHAS_INVIS_ST), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_SAVNOK)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_SAVNOK_CALL_ARMOR))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_SAVNOK_CALL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_SAVNOK_MOVE_ALLY))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(nBinderLevel >= 13 ? IP_CONST_VESTIGE_SAVNOK_MOVE_SW : IP_CONST_VESTIGE_SAVNOK_MOVE_ST), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ANDROMALIUS)
    {
        if ((GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder)) && !GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_SEE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRO_SEE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder))
        {
            if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_LOCATE))
                IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRO_LOCATE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_JESTER))
                IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRO_MIRTH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
    }
    else if (nVestige == VESTIGE_FOCALOR)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_AURA))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_FOCALOR_AURA), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder))
        {
            if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_LIGHTNING))
                IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_FOCALOR_BOLT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_BREATH))
                IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_FOCALOR_BREATH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
    }
    else if (nVestige == VESTIGE_KARSUS)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_KARSUS_SENSES_ABIL))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_KARSUS_SENSES), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_KARSUS_TOUCH))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_KARSUS_TOUCH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_PAIMON && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_DANCE))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_PAIMON_DANCE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_AGARES)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_AGARES_EARTHSHAKING))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_AGARES_STEP), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_AGARES_COMPANION))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_AGARES_ELEMENTAL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ANDRAS)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_SMITE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRAS_SMITE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_DISCORD))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRAS_DISCORD), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_MOUNT))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRAS_MOUNT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_BUER)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_HEALING_GIFT))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_BUER_HEAL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_TRACK))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TRACK), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_TENEBROUS)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_DARKNESS))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_DARKNESS), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_TOUCH_VOID))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_TOUCH_VOID), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_TURN_UNDEAD))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_TURN), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_EMPTY_VESSEL))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_VESSEL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ARETE && !GetIsVestigeExploited(oBinder, VESTIGE_ARETE_RESISTANCE))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ARETE_RESISTANCE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_ASTAROTH)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_BREATH))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASTAROTH_BREATH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_WORD))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASTAROTH_WORD), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ACERERAK)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_DETECT))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ACERERAK_DETECT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_HIDE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ACERERAK_HIDE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_TOUCH))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ACERERAK_TOUCH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_BALAM)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_BALAM_CUNNING))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_BALAM_CUNNING), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_BALAM_GLARE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_BALAM_GLARE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_DANTALION)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_AWE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DANTALION_AWE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_READ))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DANTALION_READ), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_TRAVEL))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DANTALION_TRAVEL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_GERYON)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_GERYON_GAZE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GERYON_GAZE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_GERYON_FLIGHT))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GERYON_FLIGHT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_OTIAX)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_AIR_BLAST))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_OTIAX_AIR_BLAST), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_OPEN))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_OTIAX_OPEN), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_UNLOCK))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_OTIAX_UNLOCK), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_CHUPOCLOPS)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_DESPAIR))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_CHUPOCLOPS_DESPAIR), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_ETHEREAL))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_CHUPOCLOPS_ETHEREAL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_HAURES)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_HAURES_IMAGE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_HAURES_IMAGE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_HAURES_KILLER))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_HAURES_KILLER), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_IPOS && !GetIsVestigeExploited(oBinder, VESTIGE_IPOS_INSIGHT))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_IPOS_INSIGHT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_SHAX)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_SHAX_FREEDOM))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_SHAX_FREEDOM), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_SHAX_STORM_STRIKE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_SHAX_STRIKE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ZAGAN && !GetIsVestigeExploited(oBinder, VESTIGE_ZAGAN_AVERSION))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZAGAN_AVERSION), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_VANUS && !GetIsVestigeExploited(oBinder, VESTIGE_VANUS_FREE_ALLY))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_VANUS_FREE_ALLY), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_THETRIAD && !GetIsVestigeExploited(oBinder, VESTIGE_THE_TRIAD_RUJSHA))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_THE_TRIAD_SMITE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_DESHARIS)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_TELEPORT))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DESHARIS_TELEPORT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_SMITE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DESHARIS_SMITE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_ANIMATE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_DESHARIS_ANIMATE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ZCERYLL)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_ALIEN_FORM))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZCERYLL_TRUE_STRIKE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_BOLTS))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZCERYLL_BOLTS), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_SUMMON))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZCERYLL_SUMMON), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ELIGOR && !GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_STRIKE))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ELIGOR_STRIKE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_MARCHOSIAS && !GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_SMOKE))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_MARCHOSIAS_SMOKE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else if (nVestige == VESTIGE_ASHARDALON)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ASHARDALON_CREED))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASHARDALON_LOCATE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_ASHARDALON_PRESENCE))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASHARDALON_PRESENCE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_HALPHAX)
    {
        if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_IMPRISON))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_HALPHAX_IMPRISON), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_BARRIER))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_HALPHAX_BARRIER), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_SHELTER))
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_HALPHAX_SHELTER), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if (nVestige == VESTIGE_ORTHOS && !GetIsVestigeExploited(oBinder, VESTIGE_ORTHOS_BREATH))
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ORTHOS_BREATH), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}

void CleanupPreEpicVestigeState(object oBinder, int nVestige)
{
    effect eClean = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eClean))
    {
        if (GetEffectSpellId(eClean) == nVestige)
            RemoveEffect(oBinder, eClean);
        eClean = GetNextEffect(oBinder);
    }
    if (nVestige == VESTIGE_ARETE)
        DeleteLocalInt(oBinder, "AretePsion");
    else if (nVestige == VESTIGE_THETRIAD)
        DeleteLocalInt(oBinder, "TheTriadPsion");
    else if (nVestige == VESTIGE_ABYSM)
        DeleteLocalInt(oBinder, "AbysmPsion");
}

void EnsureVestigeApplied(object oBinder, int nVestige, int nExpectedGen)
{
    if (!GetIsObjectValid(oBinder)) return;
    if (GetLocalInt(oBinder, "VestigeBindGen_" + IntToString(nVestige)) != nExpectedGen) return;
    if (GetHasSpellEffect(nVestige, oBinder)) return;

    string sScript = Get2DACache("spells", "ImpactScript", nVestige);
    if (sScript != "")
    {
        SetLocalInt(oBinder, "PRC_SPELLID_OVERRIDE", nVestige);
        SetLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", TRUE);
        SetLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE", oBinder);
        ExecuteScript(sScript, oBinder);
        DeleteLocalInt(oBinder, "PRC_SPELLID_OVERRIDE");
        DeleteLocalInt(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");
        DeleteLocalObject(oBinder, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");
    }
}

void ApplyVestige(object oBinder, int nVestige)
{
	//:: Remove Astaroth's crafting feat to allow leveling up.
	effect eOld = GetFirstEffect(oBinder);  
    while (GetIsEffectValid(eOld))  
    {  
        if (GetEffectTag(eOld) == "AstarothCraftingFeat")  
        {  
            RemoveEffect(oBinder, eOld);  
        }  
        eOld = GetNextEffect(oBinder);  
    } 
	
	int nBindGen = GetLocalInt(oBinder, "VestigeBindGen_" + IntToString(nVestige)) + 1;
	SetLocalInt(oBinder, "VestigeBindGen_" + IntToString(nVestige), nBindGen);
	SetLocalInt(oBinder, "VestigeWasBound_" + IntToString(nVestige), TRUE);
	PRCRemoveSpellEffects(nVestige, oBinder, oBinder);
	GZPRCRemoveSpellEffects(nVestige, oBinder, FALSE);
	ScrubVestigeSkinFeats(oBinder, nVestige);
	CleanupPreEpicVestigeState(oBinder, nVestige);
	ActionCastSpellOnSelf(nVestige, METAMAGIC_NONE, oBinder);
	DelayCommand(2.6f, EnsureVestigeApplied(oBinder, nVestige, nBindGen));
	if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) >= 2)
	{
		ExecuteScript("bnd_bind_pact", oBinder);	
	}	
	if (DEBUG) DoDebug("Applying Vestige "+IntToString(nVestige)+" on "+GetName(oBinder));
	
	// If you have hosted one of these spirits within the last 24 hours, Amon refuses to answer your call.
	if (nVestige == VESTIGE_LERAJE ||
	    nVestige == VESTIGE_CHUPOCLOPS ||
	    nVestige == VESTIGE_KARSUS ||
	    nVestige == VESTIGE_EURYNOME)
	{
		SetLocalInt(oBinder, "AmonHater", TRUE);
		DelayCommand(HoursToSeconds(48), DeleteLocalInt(oBinder, "AmonHater"));
	}		
	
	// Only good quality pacts get the bonus spell
	if (GetLocalInt(oBinder, "PactQuality"+IntToString(nVestige)) && GetLocalInt(oBinder, "ExploitVestigeConv"))
	{
		DelayCommand(0.5, StartDynamicConversation("bnd_exploitcnv", oBinder, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oBinder));
		DeleteLocalInt(oBinder, "ExploitVestigeConv");
	}	
}

void ExpelVestige(object oBinder, int nVestige)
{
	//:: Remove Astaroth's crafting feat to allow leveling up.
	effect eOld = GetFirstEffect(oBinder);  
    while (GetIsEffectValid(eOld))  
    {  
        if (GetEffectTag(eOld) == "AstarothCraftingFeat")  
        {  
            RemoveEffect(oBinder, eOld);  
        }  
        eOld = GetNextEffect(oBinder);  
    } 
    
	SetPersistantLocalInt(oBinder, "ExpelledVestige", TRUE);
    SetPersistantLocalInt(oBinder, "ExpelledVestige"+IntToString(nVestige), TRUE);
	// Here, making a good pack means we can unbind it
	if (GetLocalInt(oBinder, "PactQuality"+IntToString(nVestige)))
	{
		SetLocalInt(oBinder, "VestigeBindGen_" + IntToString(nVestige), GetLocalInt(oBinder, "VestigeBindGen_" + IntToString(nVestige)) + 1);
		DeleteLocalInt(oBinder, "VestigeWasBound_" + IntToString(nVestige));
		PRCRemoveSpellEffects(nVestige, oBinder, oBinder);
		GZPRCRemoveSpellEffects(nVestige, oBinder, FALSE);
		CleanupPreEpicVestigeState(oBinder, nVestige);
		ScrubVestigeSkinFeats(oBinder, nVestige);
		if (nVestige == VESTIGE_ANDRAS)
			CleanupAndrasMount(oBinder);
		if (nVestige == VESTIGE_AGARES)
			CleanupAgaresCompanion(oBinder);
		if (nVestige == VESTIGE_RONOVE)
		{
			DeleteLocalInt(oBinder, "RonovesFists");
			SetLocalInt(oBinder, "CALL_UNARMED_FEATS", TRUE);
			SetLocalInt(oBinder, "CALL_UNARMED_FISTS", TRUE);
			ExecuteScript("unarmed_caller", oBinder);
			DelayCommand(0.2f, ExecuteScript("prc_speed", oBinder));
		}
		else if (nVestige == VESTIGE_AYM || nVestige == VESTIGE_DESHARIS)
		{
			DelayCommand(0.2f, ExecuteScript("prc_speed", oBinder));
		}
		if (nVestige == VESTIGE_AYM || nVestige == VESTIGE_RONOVE)
		{
			ApplyBinderWeaponDRBypass(oBinder, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder));
			ApplyBinderWeaponDRBypass(oBinder, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oBinder));
		}
		FloatingTextStringOnCreature("Expelled "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nVestige)))+" successfully!", oBinder, FALSE);
	}
	else
		FloatingTextStringOnCreature("Failed to expel "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nVestige))), oBinder, FALSE);
}

int DoBindingCheck(object oBinder, int nVestige)
{
	int nApply = StringToInt(Get2DACache("vestiges", "SpellID", nVestige));
	
	// Knights of the Sacred Seal always have a good pact with their Patron
	if (GetPatronVestige(oBinder) == nApply)
	{
		SetLocalInt(oBinder, "PactQuality"+IntToString(nApply), TRUE);
		return nApply; //We don't need the rest of the function here.
	}
	// Scions of Dantalion always have a good pact with Dantalion
	if (GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder) && VESTIGE_DANTALION == nApply)
	{
		SetLocalInt(oBinder, "PactQuality"+IntToString(nApply), TRUE);
		return nApply; //We don't need the rest of the function here.
	}	
	
	int nRoll = d20()+ GetBinderLevel(oBinder) + GetAbilityModifier(ABILITY_CHARISMA, oBinder);
	if (GetHasFeat(FEAT_SKILLED_PACT_MAKING, oBinder)) nRoll += 4;
	// -10 penalty on the check
	if (GetLocalInt(oBinder, "RushedBinding"))
	{
		DeleteLocalInt(oBinder, "RushedBinding");
		nRoll -= 10;
	}
	// After expelling a vestige, take a -10 penalty on the check
	if (GetPersistantLocalInt(oBinder, "ExpelledVestige"))
	{
		DeletePersistantLocalInt(oBinder, "ExpelledVestige");
		nRoll -= 10;
	}	
	// Next time you rebind an expelled vestige, take a penalty on the check
	if (GetPersistantLocalInt(oBinder, "ExpelledVestige"+IntToString(nApply)))
	{
		DeletePersistantLocalInt(oBinder, "ExpelledVestige"+IntToString(nApply));
		nRoll -= 10;
	}
	// Exploiting a vestige grants a -5 on the check
	if (GetLocalInt(oBinder, "ExploitVestigeTemp")) 
	{
		nRoll -= 5;
		FloatingTextStringOnCreature("Exploiting vestige", oBinder);
		// This int is only for this Binding check
		DeleteLocalInt(oBinder, "ExploitVestigeTemp");
	}	
	int nDC = StringToInt(Get2DACache("vestiges", "BindDC", nVestige));
	SendMessageToPC(oBinder, "Binding Check: "+IntToString(nRoll)+" vs a DC of "+IntToString(nDC));
	DeleteLocalInt(oBinder, "PactQuality"+IntToString(nApply));
	// Mark a good pact
	if (nRoll >= nDC) SetLocalInt(oBinder, "PactQuality"+IntToString(nApply), TRUE);
	
	return nApply;
}

void BindVestige(object oBinder, int nTime, int nVestige, int nExpel = FALSE)
{
	if (0 >= nTime)
	{
		SetCutsceneMode(oBinder, FALSE);
		// We're expelling a vestige, not binding one
		if (nExpel)
			ExpelVestige(oBinder, DoBindingCheck(oBinder, nVestige));
		// Make a check and apply the vestige
		else
			ApplyVestige(oBinder, DoBindingCheck(oBinder, nVestige));
	}
	else if (!GetIsInCombat(oBinder)) // Being in combat causes this to fail
	{
		FloatingTextStringOnCreature("You must spend " + IntToString(nTime) +" more seconds to complete the binding", oBinder, FALSE);
		DelayCommand(6.0, BindVestige(oBinder, nTime - 6, nVestige, nExpel));
		SetCutsceneMode(oBinder, TRUE);
		AssignCommand(oBinder, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 6.0));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_MAZE), GetLocation(oBinder), 6.0);
	}
	else
		SetCutsceneMode(oBinder, FALSE);
}

void ContactVestige(object oBinder, int nTime, int nVestige, int nExpel = FALSE)
{
	if (0 >= nTime)
	{
		SetCutsceneMode(oBinder, FALSE);	
		if (!DoSummonRequirements(oBinder, nVestige)) return;
		int nBindTime = VESTIGE_BINDING_TIME;		
		if(GetPRCSwitch(PRC_BIND_VESTIGE_TIMER) >= 12) nBindTime = GetPRCSwitch(PRC_BIND_VESTIGE_TIMER);
		if (GetLocalInt(oBinder, "RushedBinding") || GetLocalInt(oBinder, "RapidPactMaking")) nBindTime = 6;
		BindVestige(oBinder, nBindTime, nVestige, nExpel);
	}
	else if (!GetIsInCombat(oBinder)) // Being in combat causes this to fail
	{
		FloatingTextStringOnCreature("You must draw the symbol for another " + IntToString(nTime) +" seconds", oBinder, FALSE);
		DelayCommand(6.0, ContactVestige(oBinder, nTime - 6, nVestige, nExpel));
		SetCutsceneMode(oBinder, TRUE);
		AssignCommand(oBinder, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 6.0));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SYMB_INSAN), GetLocation(oBinder), 6.0);
	}
	else
		SetCutsceneMode(oBinder, FALSE);
}

int BindAbilCooldown(object oBinder, int nAbil, int nVestige)
{
	int nCheck = GetLocalInt(oBinder, "Bind"+IntToString(nAbil));
	// On Cooldown
	if (nCheck)
	{
		// Free use
		if (GetLocalInt(oBinder, "KotSSSurge"))
		{
			DeleteLocalInt(oBinder, "KotSSSurge");
			FloatingTextStringOnCreature("Using Vestige's Surge on "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nAbil))), oBinder, FALSE);
			return TRUE;
		}
		FloatingTextStringOnCreature(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nAbil)))+" is still on cooldown!", oBinder, FALSE);
		return FALSE;
	}
	else
	{
		SetLocalInt(oBinder, "Bind"+IntToString(nAbil), TRUE);
		// Default number of rounds
		int nDelay = 5;
		// Makes it one round faster
		if (RapidRecovery(oBinder, nVestige)) nDelay -= 1;
		DelayCommand(RoundsToSeconds(nDelay), DeleteLocalInt(oBinder, "Bind"+IntToString(nAbil)));
		DelayCommand(RoundsToSeconds(nDelay), FloatingTextStringOnCreature(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nAbil)))+" is off cooldown", oBinder, FALSE));
		FloatingTextStringOnCreature("You must wait " + IntToString(nDelay) +" rounds before using "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nAbil)))+" again", oBinder, FALSE);
	}
	
	return TRUE;
}

int GetMaxVestigeCount(object oBinder)
{
	int nLevel = GetBinderLevel(oBinder);
	int nRow = (nLevel > 0 ? nLevel - 1 : 0);
	int nMax = StringToInt(Get2DACache(GetBindingClassFile(CLASS_TYPE_BINDER), "Vestiges", nRow));
	
    if (DEBUG) DoDebug("GetMaxVestigeCount is "+IntToString(nMax));
    return nMax;
}

int GetMaxVestigeLevel(object oBinder)
{
	int nLevel = GetBinderLevel(oBinder);
	if (GetHasFeat(FEAT_IMPROVED_BINDING, oBinder)) nLevel += 2;
	// Due to the 2da starting at row 0
	int nRow = (nLevel > 0 ? nLevel - 1 : 0);
	int nMax = StringToInt(Get2DACache(GetBindingClassFile(CLASS_TYPE_BINDER), "VestigeLvl", nRow));
	
    if (DEBUG) DoDebug("GetMaxVestigeLevel is "+IntToString(nMax));
    return nMax;
}

int GetVestigeLevel(int nVestige)
{
	int nMax = StringToInt(Get2DACache("Vestiges", "Level", nVestige));
	
    if (DEBUG) DoDebug("GetVestigeLevel is "+IntToString(nMax));
    return nMax;
}

int GetBindCount(object oBinder)
{
    int i, nCount;
    for(i = VESTIGE_AMON; i <= VESTIGE_ABYSM; i++)
    	if(GetHasSpellEffect(i, oBinder)) nCount++;
	
    if (DEBUG) DoDebug("GetBindCount is "+IntToString(nCount));
    return nCount;
}

int GetPactAugmentCount(object oBinder)
{
	int nClass = GetLevelByClass(CLASS_TYPE_BINDER, oBinder);
	int nCount = 0;
	
	if (nClass >= 20) nCount = 5;
	else if (nClass >= 16) nCount = 4;
	else if (nClass >= 10) nCount = 3;
	else if (nClass >= 5) nCount = 2;
	else if (nClass >= 2) nCount = 1;
	
    if (DEBUG) DoDebug("GetPactAugmentCount is "+IntToString(nCount));
    return nCount;
}

effect EffectPact(object oBinder, int nVestige = -1)
{
	int nSpellId = (nVestige >= 0) ? nVestige : PRCGetSpellId();
	effect eEffect;
	if (!GetLocalInt(oBinder, "PactQuality"+IntToString(nSpellId)))
	{
		// -1 penalty on attack rolls, saving throws, and skill checks
		// Link EffectTurnResistanceIncrease(0) so GetHasSpellEffect remains TRUE even if immune to all 3 decreases
		eEffect = EffectLinkEffects(EffectSkillDecrease(SKILL_ALL_SKILLS, 1), EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));
		eEffect = EffectLinkEffects(eEffect, EffectAttackDecrease(1));
		eEffect = EffectLinkEffects(eEffect, EffectTurnResistanceIncrease(0));
	}	
	else // NWN hates having a blank effect
		eEffect = EffectTurnResistanceIncrease(0);
	if (nSpellId >= 0)
		eEffect = SetEffectSpellId(eEffect, nSpellId);
    
    return eEffect;
}

int RapidRecovery(object oBinder, int nVestige)
{
	int nFavored;
	
	if (GetHasFeat(FEAT_RAPID_RECOVERY_AMON, oBinder) && nVestige == VESTIGE_AMON) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_AYM        , oBinder) && nVestige == VESTIGE_AYM        ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_LERAJE     , oBinder) && nVestige == VESTIGE_LERAJE     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_NABERIUS   , oBinder) && nVestige == VESTIGE_NABERIUS   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_RONOVE     , oBinder) && nVestige == VESTIGE_RONOVE     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_DAHLVERNAR , oBinder) && nVestige == VESTIGE_DAHLVERNAR ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_HAAGENTI   , oBinder) && nVestige == VESTIGE_HAAGENTI   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_MALPHAS    , oBinder) && nVestige == VESTIGE_MALPHAS    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_SAVNOK     , oBinder) && nVestige == VESTIGE_SAVNOK     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ANDROMALIUS, oBinder) && nVestige == VESTIGE_ANDROMALIUS) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_FOCALOR    , oBinder) && nVestige == VESTIGE_FOCALOR    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_KARSUS     , oBinder) && nVestige == VESTIGE_KARSUS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_PAIMON     , oBinder) && nVestige == VESTIGE_PAIMON     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_AGARES     , oBinder) && nVestige == VESTIGE_AGARES     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ANDRAS     , oBinder) && nVestige == VESTIGE_ANDRAS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_BUER       , oBinder) && nVestige == VESTIGE_BUER       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_EURYNOME   , oBinder) && nVestige == VESTIGE_EURYNOME   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_TENEBROUS  , oBinder) && nVestige == VESTIGE_TENEBROUS  ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ARETE      , oBinder) && nVestige == VESTIGE_ARETE      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ASTAROTH   , oBinder) && nVestige == VESTIGE_ASTAROTH   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ACERERAK   , oBinder) && nVestige == VESTIGE_ACERERAK   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_BALAM      , oBinder) && nVestige == VESTIGE_BALAM      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_DANTALION  , oBinder) && nVestige == VESTIGE_DANTALION  ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_GERYON     , oBinder) && nVestige == VESTIGE_GERYON     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_OTIAX      , oBinder) && nVestige == VESTIGE_OTIAX      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_CHUPOCLOPS , oBinder) && nVestige == VESTIGE_CHUPOCLOPS ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_HAURES     , oBinder) && nVestige == VESTIGE_HAURES     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_IPOS       , oBinder) && nVestige == VESTIGE_IPOS       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_SHAX       , oBinder) && nVestige == VESTIGE_SHAX       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ZAGAN      , oBinder) && nVestige == VESTIGE_ZAGAN      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_VANUS      , oBinder) && nVestige == VESTIGE_VANUS      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_THETRIAD   , oBinder) && nVestige == VESTIGE_THETRIAD   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_DESHARIS   , oBinder) && nVestige == VESTIGE_DESHARIS   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ZCERYLL    , oBinder) && nVestige == VESTIGE_ZCERYLL    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ELIGOR     , oBinder) && nVestige == VESTIGE_ELIGOR     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_MARCHOSIAS , oBinder) && nVestige == VESTIGE_MARCHOSIAS ) nFavored = TRUE;	
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ASHARDALON , oBinder) && nVestige == VESTIGE_ASHARDALON ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_HALPHAX    , oBinder) && nVestige == VESTIGE_HALPHAX    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ORTHOS     , oBinder) && nVestige == VESTIGE_ORTHOS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_RAPID_RECOVERY_ABYSM      , oBinder) && nVestige == VESTIGE_ABYSM      ) nFavored = TRUE;
	
	if (DEBUG) DoDebug("RapidRecovery return value "+IntToString(nFavored));
	return nFavored;
}

int FavoredVestige(object oBinder, int nVestige)
{
	int nFavored;
	
	if (GetHasFeat(FEAT_FAVORED_VESTIGE_AMON, oBinder) && nVestige == VESTIGE_AMON) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_AYM        , oBinder) && nVestige == VESTIGE_AYM        ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_LERAJE     , oBinder) && nVestige == VESTIGE_LERAJE     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_NABERIUS   , oBinder) && nVestige == VESTIGE_NABERIUS   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_RONOVE     , oBinder) && nVestige == VESTIGE_RONOVE     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_DAHLVERNAR , oBinder) && nVestige == VESTIGE_DAHLVERNAR ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_HAAGENTI   , oBinder) && nVestige == VESTIGE_HAAGENTI   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_MALPHAS    , oBinder) && nVestige == VESTIGE_MALPHAS    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_SAVNOK     , oBinder) && nVestige == VESTIGE_SAVNOK     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ANDROMALIUS, oBinder) && nVestige == VESTIGE_ANDROMALIUS) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCALOR    , oBinder) && nVestige == VESTIGE_FOCALOR    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_KARSUS     , oBinder) && nVestige == VESTIGE_KARSUS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_PAIMON     , oBinder) && nVestige == VESTIGE_PAIMON     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_AGARES     , oBinder) && nVestige == VESTIGE_AGARES     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ANDRAS     , oBinder) && nVestige == VESTIGE_ANDRAS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_BUER       , oBinder) && nVestige == VESTIGE_BUER       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_EURYNOME   , oBinder) && nVestige == VESTIGE_EURYNOME   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_TENEBROUS  , oBinder) && nVestige == VESTIGE_TENEBROUS  ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ARETE      , oBinder) && nVestige == VESTIGE_ARETE      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ASTAROTH   , oBinder) && nVestige == VESTIGE_ASTAROTH   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ACERERAK   , oBinder) && nVestige == VESTIGE_ACERERAK   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_BALAM      , oBinder) && nVestige == VESTIGE_BALAM      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_DANTALION  , oBinder) && nVestige == VESTIGE_DANTALION  ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_GERYON     , oBinder) && nVestige == VESTIGE_GERYON     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_OTIAX      , oBinder) && nVestige == VESTIGE_OTIAX      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_CHUPOCLOPS , oBinder) && nVestige == VESTIGE_CHUPOCLOPS ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_HAURES     , oBinder) && nVestige == VESTIGE_HAURES     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_IPOS       , oBinder) && nVestige == VESTIGE_IPOS       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_SHAX       , oBinder) && nVestige == VESTIGE_SHAX       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ZAGAN      , oBinder) && nVestige == VESTIGE_ZAGAN      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_VANUS      , oBinder) && nVestige == VESTIGE_VANUS      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_THETRIAD   , oBinder) && nVestige == VESTIGE_THETRIAD   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_DESHARIS   , oBinder) && nVestige == VESTIGE_DESHARIS   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ZCERYLL    , oBinder) && nVestige == VESTIGE_ZCERYLL    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ELIGOR     , oBinder) && nVestige == VESTIGE_ELIGOR     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_MARCHOSIAS , oBinder) && nVestige == VESTIGE_MARCHOSIAS ) nFavored = TRUE;	
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ASHARDALON , oBinder) && nVestige == VESTIGE_ASHARDALON ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_HALPHAX    , oBinder) && nVestige == VESTIGE_HALPHAX    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ORTHOS     , oBinder) && nVestige == VESTIGE_ORTHOS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_ABYSM      , oBinder) && nVestige == VESTIGE_ABYSM      ) nFavored = TRUE;
	
	if (DEBUG) DoDebug("FavoredVestige return value "+IntToString(nFavored));
	return nFavored;
}

int FavoredVestigeFocus(object oBinder, int nVestige)
{
	int nFavored;
	
	if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_AMON, oBinder) && nVestige == VESTIGE_AMON) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_AYM        , oBinder) && nVestige == VESTIGE_AYM        ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_LERAJE     , oBinder) && nVestige == VESTIGE_LERAJE     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_NABERIUS   , oBinder) && nVestige == VESTIGE_NABERIUS   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_RONOVE     , oBinder) && nVestige == VESTIGE_RONOVE     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_DAHLVERNAR , oBinder) && nVestige == VESTIGE_DAHLVERNAR ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_HAAGENTI   , oBinder) && nVestige == VESTIGE_HAAGENTI   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_MALPHAS    , oBinder) && nVestige == VESTIGE_MALPHAS    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_SAVNOK     , oBinder) && nVestige == VESTIGE_SAVNOK     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ANDROMALIUS, oBinder) && nVestige == VESTIGE_ANDROMALIUS) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_FOCALOR    , oBinder) && nVestige == VESTIGE_FOCALOR    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_KARSUS     , oBinder) && nVestige == VESTIGE_KARSUS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_PAIMON     , oBinder) && nVestige == VESTIGE_PAIMON     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_AGARES     , oBinder) && nVestige == VESTIGE_AGARES     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ANDRAS     , oBinder) && nVestige == VESTIGE_ANDRAS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_BUER       , oBinder) && nVestige == VESTIGE_BUER       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_EURYNOME   , oBinder) && nVestige == VESTIGE_EURYNOME   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_TENEBROUS  , oBinder) && nVestige == VESTIGE_TENEBROUS  ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ARETE      , oBinder) && nVestige == VESTIGE_ARETE      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ASTAROTH   , oBinder) && nVestige == VESTIGE_ASTAROTH   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ACERERAK   , oBinder) && nVestige == VESTIGE_ACERERAK   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_BALAM      , oBinder) && nVestige == VESTIGE_BALAM      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_DANTALION  , oBinder) && nVestige == VESTIGE_DANTALION  ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_GERYON     , oBinder) && nVestige == VESTIGE_GERYON     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_OTIAX      , oBinder) && nVestige == VESTIGE_OTIAX      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_CHUPOCLOPS , oBinder) && nVestige == VESTIGE_CHUPOCLOPS ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_HAURES     , oBinder) && nVestige == VESTIGE_HAURES     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_IPOS       , oBinder) && nVestige == VESTIGE_IPOS       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_SHAX       , oBinder) && nVestige == VESTIGE_SHAX       ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ZAGAN      , oBinder) && nVestige == VESTIGE_ZAGAN      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_VANUS      , oBinder) && nVestige == VESTIGE_VANUS      ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_THETRIAD   , oBinder) && nVestige == VESTIGE_THETRIAD   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_DESHARIS   , oBinder) && nVestige == VESTIGE_DESHARIS   ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ZCERYLL    , oBinder) && nVestige == VESTIGE_ZCERYLL    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ELIGOR     , oBinder) && nVestige == VESTIGE_ELIGOR     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_MARCHOSIAS , oBinder) && nVestige == VESTIGE_MARCHOSIAS ) nFavored = TRUE;	
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ASHARDALON , oBinder) && nVestige == VESTIGE_ASHARDALON ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_HALPHAX    , oBinder) && nVestige == VESTIGE_HALPHAX    ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ORTHOS     , oBinder) && nVestige == VESTIGE_ORTHOS     ) nFavored = TRUE;
	else if (GetHasFeat(FEAT_FAVORED_VESTIGE_FOCUS_ABYSM      , oBinder) && nVestige == VESTIGE_ABYSM      ) nFavored = TRUE;
	
	if (DEBUG) DoDebug("FavoredVestigeFocus return value "+IntToString(nFavored));
	return nFavored;
}

int GetBinderDC(object oBinder, int nVestige)
{
	int nDC = 10 + GetBinderLevel(oBinder, nVestige)/2 + GetAbilityModifier(ABILITY_CHARISMA, oBinder);
	if (FavoredVestigeFocus(oBinder, nVestige)) nDC += 1;
	if (GetHasSpellEffect(VESTIGE_IPOS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_IPOS_INFLUENCE)) nDC += 1;
	
	return nDC;
}

int DoSpecialRequirements(object oBinder, int nVestige)
{
	if (GetHasFeat(FEAT_IGNORE_SPECIAL_REQUIREMENTS, oBinder)) return TRUE;
	
	if (nVestige == VESTIGE_AMON && (GetLocalInt(oBinder, "AmonHater") || 
	                                 GetHasSpellEffect(VESTIGE_LERAJE, oBinder) ||
	                                 GetHasSpellEffect(VESTIGE_EURYNOME, oBinder) ||
	                                 GetHasSpellEffect(VESTIGE_KARSUS, oBinder) ||
	                                 GetHasSpellEffect(VESTIGE_CHUPOCLOPS, oBinder)))
		return FALSE;  
	if (nVestige == VESTIGE_LERAJE && GetHasSpellEffect(VESTIGE_AMON, oBinder))
		return FALSE;
	if (nVestige == VESTIGE_NABERIUS && 4 > GetSkillRank(SKILL_LORE, oBinder, TRUE) && 4 > GetSkillRank(SKILL_BLUFF, oBinder, TRUE))
		return FALSE;
	// Ronove’s seal must be drawn in the soil under the sky.	
	if (nVestige == VESTIGE_RONOVE && (GetIsAreaNatural(GetArea(oBinder)) != AREA_NATURAL || GetIsAreaAboveGround(GetArea(oBinder)) != AREA_ABOVEGROUND))
		return FALSE;
	if (nVestige == VESTIGE_HAAGENTI && (CREATURE_SIZE_LARGE > PRCGetCreatureSize(oBinder) || (GetHasFeat(FEAT_RACE_POWERFUL_BUILD, oBinder) && CREATURE_SIZE_MEDIUM > PRCGetCreatureSize(oBinder))))
		return FALSE;
	if (nVestige == VESTIGE_KARSUS && GetHasSpellEffect(VESTIGE_AMON, oBinder))
		return FALSE;	
	if (nVestige == VESTIGE_KARSUS && 5 > GetSkillRank(SKILL_LORE, oBinder, TRUE) && 5 > GetSkillRank(SKILL_SPELLCRAFT, oBinder, TRUE))
		return FALSE;		
	if (nVestige == VESTIGE_KARSUS)
	{
    	effect eTest = GetFirstEffect(oBinder);
    	while(GetIsEffectValid(eTest))
    	{
    	    if(GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT)
    	    {
    	        int nEffSpell = GetEffectSpellId(eTest);
    	        int bIsVestigeAura = ((nEffSpell >= VESTIGE_AMON && nEffSpell <= VESTIGE_ABYSM) ||
    	                              (nEffSpell >= 19064 && nEffSpell <= 19200));
    	        if (!bIsVestigeAura)
    	            return FALSE;
    	    }
    
        	eTest = GetNextEffect(oBinder);
        }	
    }		
	// Agagres’s seal must be drawn in the soil
	if (nVestige == VESTIGE_AGARES && GetIsAreaNatural(GetArea(oBinder)) != AREA_NATURAL)
		return FALSE;
	if (nVestige == VESTIGE_BUER && GetIsAreaInterior(GetArea(oBinder)))
		return FALSE;
	if (nVestige == VESTIGE_EURYNOME && (GetHasSpellEffect(VESTIGE_AMON, oBinder) || GetHasSpellEffect(VESTIGE_ARETE, oBinder)))
		return FALSE;
	if (nVestige == VESTIGE_TENEBROUS && !GetIsNight())
		return FALSE;		
	if (nVestige == VESTIGE_BALAM)		
	{
		int nCur = GetCurrentHitPoints(oBinder);
		if (nCur <= 1)
			return FALSE;
		if (!GetLocalInt(oBinder, "BinderCheckingMenuReqs"))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1, DAMAGE_TYPE_SLASHING), oBinder);
			if (GetIsDead(oBinder) || GetCurrentHitPoints(oBinder) < 1)
				return FALSE;
		}
	}
	if (nVestige == VESTIGE_GERYON && 5 > GetSkillRank(SKILL_LORE, oBinder, TRUE))
		return FALSE;	
	if (nVestige == VESTIGE_ARETE && (GetHasSpellEffect(VESTIGE_EURYNOME, oBinder) || GetHasSpellEffect(VESTIGE_CHUPOCLOPS, oBinder)))
		return FALSE; 		
	if (nVestige == VESTIGE_CHUPOCLOPS && (GetHasSpellEffect(VESTIGE_AMON, oBinder) || GetHasSpellEffect(VESTIGE_ARETE, oBinder)))
		return FALSE;
	if (nVestige == VESTIGE_IPOS && 5 > GetSkillRank(SKILL_LORE, oBinder, TRUE) && 5 > GetSkillRank(SKILL_SPELLCRAFT, oBinder, TRUE))
		return FALSE;
	if (nVestige == VESTIGE_VANUS && GetIsAreaNatural(GetArea(oBinder)) != AREA_NATURAL)
		return FALSE;
	if (nVestige == VESTIGE_DESHARIS && GetIsAreaNatural(GetArea(oBinder)) == AREA_NATURAL)
		return FALSE;		
	if (nVestige == VESTIGE_HALPHAX && !GetIsAreaInterior(GetArea(oBinder)))
		return FALSE;			
	if (nVestige == VESTIGE_HALPHAX && GetIsAreaInterior(GetArea(oBinder)) && GetIsAreaAboveGround(GetArea(oBinder)) == AREA_UNDERGROUND)
		return FALSE;	
	if (nVestige == VESTIGE_ORTHOS && GetTileMainLight1Color(GetLocation(oBinder)) != TILE_MAIN_LIGHT_COLOR_WHITE && GetTileMainLight1Color(GetLocation(oBinder)) != TILE_MAIN_LIGHT_COLOR_YELLOW)
		return FALSE;			
		
	return TRUE;
}

int DoSummonRequirements(object oBinder, int nVestige)
{
	if (GetHasFeat(FEAT_IGNORE_SPECIAL_REQUIREMENTS, oBinder)) return TRUE;
	
	int nSpellId = StringToInt(Get2DACache(GetVestigeFile(), "SpellID", nVestige));
	
	if (nSpellId == VESTIGE_LERAJE)
	{
		object oArrow = GetItemInSlot(INVENTORY_SLOT_ARROWS, oBinder);
		int nStack = GetItemStackSize(oArrow);
		if (nStack) 
			SetItemStackSize(oArrow, nStack-1);
		else 
		{
			FloatingTextStringOnCreature("You have failed to break an arrow for Leraje, and she refuses your call!", oBinder, FALSE);
			return FALSE;
		}	
	}
	
	return TRUE;
}

int GetIsVestigeExploited(object oBinder, int nVestigeAbil)
{
	if (GetLocalInt(oBinder, "ExploitVestige") == nVestigeAbil ||
	    GetLocalInt(oBinder, "ExploitVestige_" + IntToString(nVestigeAbil)) ||
	    GetLocalInt(oBinder, "ExploitVestige" + IntToString(nVestigeAbil)))
	    return TRUE;
	
	return FALSE;
}

void SetIsVestigeExploited(object oBinder, int nVestigeAbil)
{
	SetLocalInt(oBinder, "ExploitVestige", nVestigeAbil);
	SetLocalInt(oBinder, "ExploitVestige_" + IntToString(nVestigeAbil), TRUE);
	SetLocalInt(oBinder, "ExploitVestige" + IntToString(nVestigeAbil), TRUE);
	SetLocalInt(oBinder, "ExploitVestigeTemp", TRUE);
	SetLocalInt(oBinder, "ExploitVestigeConv", TRUE);
}

void ClearExploitVestigeState(object oBinder)
{
	int nOld = GetLocalInt(oBinder, "ExploitVestige");
	if (nOld > 0)
	{
		DeleteLocalInt(oBinder, "ExploitVestige_" + IntToString(nOld));
		DeleteLocalInt(oBinder, "ExploitVestige" + IntToString(nOld));
	}
	int i;
	for (i = 0; i <= 220; i++)
	{
		DeleteLocalInt(oBinder, "ExploitVestige_" + IntToString(i));
		DeleteLocalInt(oBinder, "ExploitVestige" + IntToString(i));
	}
	for (i = 19000; i <= 19200; i++)
	{
		DeleteLocalInt(oBinder, "ExploitVestige_" + IntToString(i));
		DeleteLocalInt(oBinder, "ExploitVestige" + IntToString(i));
	}
	DeleteLocalInt(oBinder, "ExploitVestige");
	DeleteLocalInt(oBinder, "ExploitVestigeTemp");
	DeleteLocalInt(oBinder, "ExploitVestigeConv");
	DeleteLocalInt(oBinder, "ExploitVestigeSpell");
}

int GetIsPatronVestigeBound(object oBinder)
{
	int nPatron;
	
	if (GetHasFeat(FEAT_PATRON_VESTIGE_AMON            , oBinder)) nPatron = VESTIGE_AMON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_AYM        , oBinder)) nPatron = VESTIGE_AYM;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_LERAJE     , oBinder)) nPatron = VESTIGE_LERAJE;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_NABERIUS   , oBinder)) nPatron = VESTIGE_NABERIUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_RONOVE     , oBinder)) nPatron = VESTIGE_RONOVE;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_DAHLVERNAR , oBinder)) nPatron = VESTIGE_DAHLVERNAR;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_HAAGENTI   , oBinder)) nPatron = VESTIGE_HAAGENTI;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_MALPHAS    , oBinder)) nPatron = VESTIGE_MALPHAS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_SAVNOK     , oBinder)) nPatron = VESTIGE_SAVNOK;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ANDROMALIUS, oBinder)) nPatron = VESTIGE_ANDROMALIUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_FOCALOR    , oBinder)) nPatron = VESTIGE_FOCALOR;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_KARSUS     , oBinder)) nPatron = VESTIGE_KARSUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_PAIMON     , oBinder)) nPatron = VESTIGE_PAIMON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_AGARES     , oBinder)) nPatron = VESTIGE_AGARES;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ANDRAS     , oBinder)) nPatron = VESTIGE_ANDRAS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_BUER       , oBinder)) nPatron = VESTIGE_BUER;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_EURYNOME   , oBinder)) nPatron = VESTIGE_EURYNOME;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_TENEBROUS  , oBinder)) nPatron = VESTIGE_TENEBROUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ARETE      , oBinder)) nPatron = VESTIGE_ARETE;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ASTAROTH   , oBinder)) nPatron = VESTIGE_ASTAROTH;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ACERERAK   , oBinder)) nPatron = VESTIGE_ACERERAK;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_BALAM      , oBinder)) nPatron = VESTIGE_BALAM;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_DANTALION  , oBinder)) nPatron = VESTIGE_DANTALION;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_GERYON     , oBinder)) nPatron = VESTIGE_GERYON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_OTIAX      , oBinder)) nPatron = VESTIGE_OTIAX;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_CHUPOCLOPS , oBinder)) nPatron = VESTIGE_CHUPOCLOPS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_HAURES     , oBinder)) nPatron = VESTIGE_HAURES;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_IPOS       , oBinder)) nPatron = VESTIGE_IPOS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_SHAX       , oBinder)) nPatron = VESTIGE_SHAX;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ZAGAN      , oBinder)) nPatron = VESTIGE_ZAGAN;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_VANUS      , oBinder)) nPatron = VESTIGE_VANUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_THETRIAD   , oBinder)) nPatron = VESTIGE_THETRIAD;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_DESHARIS   , oBinder)) nPatron = VESTIGE_DESHARIS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ZCERYLL    , oBinder)) nPatron = VESTIGE_ZCERYLL;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ELIGOR     , oBinder)) nPatron = VESTIGE_ELIGOR;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_MARCHOSIAS , oBinder)) nPatron = VESTIGE_MARCHOSIAS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ASHARDALON , oBinder)) nPatron = VESTIGE_ASHARDALON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_HALPHAX    , oBinder)) nPatron = VESTIGE_HALPHAX;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ORTHOS     , oBinder)) nPatron = VESTIGE_ORTHOS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ABYSM      , oBinder)) nPatron = VESTIGE_ABYSM;
	
	if(GetHasSpellEffect(nPatron, oBinder)) return TRUE;
	
	return FALSE;			
}

int GetPatronVestige(object oBinder)
{
	int nPatron = -1;
	
	if (GetHasFeat(FEAT_PATRON_VESTIGE_AMON            , oBinder)) nPatron = VESTIGE_AMON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_AYM        , oBinder)) nPatron = VESTIGE_AYM;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_LERAJE     , oBinder)) nPatron = VESTIGE_LERAJE;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_NABERIUS   , oBinder)) nPatron = VESTIGE_NABERIUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_RONOVE     , oBinder)) nPatron = VESTIGE_RONOVE;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_DAHLVERNAR , oBinder)) nPatron = VESTIGE_DAHLVERNAR;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_HAAGENTI   , oBinder)) nPatron = VESTIGE_HAAGENTI;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_MALPHAS    , oBinder)) nPatron = VESTIGE_MALPHAS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_SAVNOK     , oBinder)) nPatron = VESTIGE_SAVNOK;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ANDROMALIUS, oBinder)) nPatron = VESTIGE_ANDROMALIUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_FOCALOR    , oBinder)) nPatron = VESTIGE_FOCALOR;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_KARSUS     , oBinder)) nPatron = VESTIGE_KARSUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_PAIMON     , oBinder)) nPatron = VESTIGE_PAIMON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_AGARES     , oBinder)) nPatron = VESTIGE_AGARES;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ANDRAS     , oBinder)) nPatron = VESTIGE_ANDRAS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_BUER       , oBinder)) nPatron = VESTIGE_BUER;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_EURYNOME   , oBinder)) nPatron = VESTIGE_EURYNOME;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_TENEBROUS  , oBinder)) nPatron = VESTIGE_TENEBROUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ARETE      , oBinder)) nPatron = VESTIGE_ARETE;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ASTAROTH   , oBinder)) nPatron = VESTIGE_ASTAROTH;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ACERERAK   , oBinder)) nPatron = VESTIGE_ACERERAK;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_BALAM      , oBinder)) nPatron = VESTIGE_BALAM;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_DANTALION  , oBinder)) nPatron = VESTIGE_DANTALION;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_GERYON     , oBinder)) nPatron = VESTIGE_GERYON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_OTIAX      , oBinder)) nPatron = VESTIGE_OTIAX;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_CHUPOCLOPS , oBinder)) nPatron = VESTIGE_CHUPOCLOPS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_HAURES     , oBinder)) nPatron = VESTIGE_HAURES;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_IPOS       , oBinder)) nPatron = VESTIGE_IPOS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_SHAX       , oBinder)) nPatron = VESTIGE_SHAX;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ZAGAN      , oBinder)) nPatron = VESTIGE_ZAGAN;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_VANUS      , oBinder)) nPatron = VESTIGE_VANUS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_THETRIAD   , oBinder)) nPatron = VESTIGE_THETRIAD;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_DESHARIS   , oBinder)) nPatron = VESTIGE_DESHARIS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ZCERYLL    , oBinder)) nPatron = VESTIGE_ZCERYLL;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ELIGOR     , oBinder)) nPatron = VESTIGE_ELIGOR;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_MARCHOSIAS , oBinder)) nPatron = VESTIGE_MARCHOSIAS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ASHARDALON , oBinder)) nPatron = VESTIGE_ASHARDALON;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_HALPHAX    , oBinder)) nPatron = VESTIGE_HALPHAX;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ORTHOS     , oBinder)) nPatron = VESTIGE_ORTHOS;
	else if (GetHasFeat(FEAT_PATRON_VESTIGE_ABYSM      , oBinder)) nPatron = VESTIGE_ABYSM;
	
	return nPatron;			
}

//:: void main(){}

void ApplyBinderWeaponDRBypass(object oBinder, object oItem)
{
    if (!GetIsObjectValid(oItem) || !IPGetIsMeleeWeapon(oItem))
        return;

    int nReqBonus = 0;
    if (GetHasSpellEffect(VESTIGE_AYM, oBinder) &&
        GetLevelByClass(CLASS_TYPE_BINDER, oBinder) > 0 &&
        !GetIsVestigeExploited(oBinder, VESTIGE_AYM_RUINOUS_ATTACK) &&
        GetBinderLevel(oBinder, VESTIGE_AYM) >= 10)
    {
        nReqBonus = 5;
    }
    if (GetTag(oItem) == "bnd_eury_hammer" &&
        GetHasSpellEffect(VESTIGE_EURYNOME, oBinder) &&
        GetBinderLevel(oBinder, VESTIGE_EURYNOME) >= 15)
    {
        if (nReqBonus < 5) nReqBonus = 5;
    }
    if (GetLevelByClass(CLASS_TYPE_KNIGHT_SACRED_SEAL, oBinder) >= 1 &&
        GetIsPatronVestigeBound(oBinder))
    {
        if (nReqBonus < 3) nReqBonus = 3;
    }
    if (GetHasSpellEffect(VESTIGE_RONOVE, oBinder) &&
        GetLevelByClass(CLASS_TYPE_BINDER, oBinder) > 0 &&
        !GetIsVestigeExploited(oBinder, VESTIGE_RONOVE_COLD_IRON))
    {
        int nRonEBL = GetBinderLevel(oBinder, VESTIGE_RONOVE);
        int nRonBonus = (nRonEBL >= 7) ? 3 : 1;
        if (nRonBonus > nReqBonus) nReqBonus = nRonBonus;
    }

    if (nReqBonus > 0)
    {
        IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nReqBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
        IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nReqBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
        SetLocalInt(oItem, "BinderDRBypassBonus", nReqBonus);
    }
    else if (GetLocalInt(oItem, "BinderDRBypassBonus") > 0)
    {
        DeleteLocalInt(oItem, "BinderDRBypassBonus");
        IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_TEMPORARY);
        IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, DURATION_TYPE_TEMPORARY);
    }
}
