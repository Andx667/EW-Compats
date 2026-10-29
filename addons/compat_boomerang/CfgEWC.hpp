/*
 * Registry of the animation sources that mark a vehicle with a Boomerang shot finder. A compat addon adds a class
 * to Boomerangs and its vehicles get the Boomerang, without any code:
 *
 *   class CfgEWC {
 *       class Boomerangs {
 *           class MY_MOD {
 *               sources[] = {"hide_boomerang"};   // animation sources of the antenna, shown at phase 0 and hidden at phase 1
 *           };
 *       };
 *   };
 *
 * The addon has to list ewc_compat_boomerang in its requiredAddons, so this class exists when it is read.
 * An addon that has to follow the Boomerang of a vehicle listens to the CBA event ewc_compat_boomerang_switchedOn.
 */
class CfgEWC {
    class Boomerangs {};
};
