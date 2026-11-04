/*
 * Acoustic signatures of drones: source level in dB at 1 m and the dominant frequency in Hz (blade passing frequency
 * of the rotors or propeller and its strongest harmonics). A drone class or any of its parents can have an entry, the
 * closest one counts. Drones without one get a value by kind and mass, see fnc_getSignature.
 *
 *   class CfgEWC {
 *       class AcousticSignatures {
 *           class MY_Drone_base {
 *               level = 80;
 *               frequency = 300;
 *           };
 *       };
 *   };
 *
 * The addon has to list ewc_acoustic in its requiredAddons. The values are estimates from published measurements of
 * comparable real drones, none of the vanilla ones has a measured counterpart.
 */
class CfgEWC {
    class AcousticSignatures {
        // AR-2 Darter: small electric quadcopter
        class UAV_01_base_F {
            level = 78;
            frequency = 400;
        };
        // AL-6 Pelican and the utility drones: larger electric hexacopter
        class UAV_06_base_F {
            level = 84;
            frequency = 250;
        };
        // MQ-4A Greyhawk and K40 Ababil-3: piston engine with a pusher propeller
        class UAV_02_base_F {
            level = 100;
            frequency = 125;
        };
        // MQ-12 Falcon: turbine helicopter
        class UAV_03_base_F {
            level = 112;
            frequency = 100;
        };
        // KH-3A Fenghuang: piston engine with a pusher propeller
        class UAV_04_base_F {
            level = 98;
            frequency = 125;
        };
        // UCAV Sentinel: jet
        class UAV_05_base_F {
            level = 120;
            frequency = 250;
        };
    };
};
