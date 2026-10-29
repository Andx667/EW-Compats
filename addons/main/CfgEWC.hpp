/*
 * Registry of the vehicles that are a radio jammer in Crows Electronic Warfare. A compat addon adds a class
 * to Jammers and the vehicles are registered without any code:
 *
 *   class CfgEWC {
 *       class Jammers {
 *           class MY_JAMMER {
 *               property = "my_jammer_type";            // config entry of the vehicle that marks it
 *               value = 1;                              // optional, the entry has to be this number. Without it the entry has to be a non-empty text
 *               radius = 50;                            // full jamming radius in m
 *               falloffFactor = 1.5;                    // the effect has faded out at this times the radius
 *               capabilities[] = {"VoiceCommsJammer"};  // optional, Crows capabilities, defaults to radio
 *               enableVariable = "my_addon_enable";     // optional, name of a (setting) variable. Vehicles are skipped while it is false
 *           };
 *       };
 *   };
 *
 * An addon that has to follow the vehicle listens to the CBA event ewc_main_vehicleInit, [vehicle, class name of the entry].
 */
class CfgEWC {
    class Jammers {};
};
