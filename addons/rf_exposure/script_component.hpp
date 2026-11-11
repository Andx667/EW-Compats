#define COMPONENT rf_exposure
#define COMPONENT_BEAUTIFIED RF Exposure

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// Seconds between two updates of the exposure of the player, while a jammer is on or there is exposure left
#define LOOP_INTERVAL 1

// Values of the setting for the jammers that count (initSettings.inc.sqf)
#define SOURCES_ALL 0
#define SOURCES_VEHICLES 1

// Classes of a vehicle-mounted jammer. A static jammer (the data terminal) or a prop is none
#define VEHICLE_CLASSES ["LandVehicle", "Air", "Ship"]

// A jammer of GVAR(jammers) that counts: alive, and a vehicle if only those count. Entries are [object, is a vehicle,
// bounding radius]
#define JAMMER_COUNTS(entry) (alive (entry select 0) && {GVAR(sources) != SOURCES_VEHICLES || {entry select 1}})

// Pain of ACE medical: the variable, the setting above which a unit can go unconscious from damage, and the pain the
// headache never gets above, as a share of it (it stays a mild one)
#define ACE_VAR_PAIN "ace_medical_pain"
#define ACE_VAR_PAIN_UNCONSCIOUS "ace_medical_painUnconsciousThreshold"
#define ACE_PAIN_UNCONSCIOUS_DEFAULT 0.5
#define MAX_PAIN_SHARE 0.5

// Id of our duty factor in ACE advanced fatigue
#define FATIGUE_FACTOR_ID "ewc_rf_exposure"
// Change of the factor that is worth telling ACE about, so it is not set every second
#define FATIGUE_FACTOR_STEP 0.02
// Share of the fatigue effect that applies as soon as the threshold is reached, it grows to the full one from there
#define FATIGUE_START_SHARE 0.5
// Fatigue per second at a factor of 2 for the vanilla fatigue, used without ACE advanced fatigue
#define VANILLA_FATIGUE_PER_SECOND 0.004

// Exposure at which the player is told about the headache, and below which the hints can come again
#define HINT_HEADACHE_EXPOSURE 0.25
#define HINT_RESET_EXPOSURE 0.05
