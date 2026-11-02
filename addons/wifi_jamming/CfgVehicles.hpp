class CfgVehicles {

    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Checkbox;
            class ModuleDescription;
        };

        class ModuleDescription {
        };
    };

    class GVAR(moduleAddWifiJammer): Module_F {
        scope = 2;
        displayName = CSTRING(moduleAddWifiJammer_displayName);
        icon = WIFI_JAM_ICON;
        vehicleClass = "Modules";
        category = "crowsEW_modules";
        function = QFUNC(addWifiJammer);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 0;

        class Attributes: AttributesBase {
            // class Units: Units{}; // deliberately omitted, same as the jammer module of Crows - if nothing is synced,
            // the handler spawns a Crows_dataterminal prop for us.

            class GVAR(addWifiJammer_isActiveAtMissionStart): Checkbox {
                property = QGVAR(addWifiJammer_isActiveAtMissionStart);
                displayName = CSTRING(moduleAddWifiJammer_missionStart_displayName);
                tooltip = CSTRING(moduleAddWifiJammer_missionStart_tooltip);
                typeName = "BOOL";
                defaultValue = "true";
            };

            class GVAR(addWifiJammer_effectiveRadius): Edit {
                property = QGVAR(addWifiJammer_effectiveRadius);
                displayName = CSTRING(moduleAddWifiJammer_effectiveRadius_displayName);
                tooltip = CSTRING(moduleAddWifiJammer_effectiveRadius_tooltip);
                typeName = "NUMBER";
                defaultValue = QUOTE(WIFI_JAM_DEFAULT_EFFECTIVE_RADIUS);
            };

            class GVAR(addWifiJammer_falloffRadius): Edit {
                property = QGVAR(addWifiJammer_falloffRadius);
                displayName = CSTRING(moduleAddWifiJammer_falloffRadius_displayName);
                tooltip = CSTRING(moduleAddWifiJammer_falloffRadius_tooltip);
                typeName = "NUMBER";
                defaultValue = QUOTE(WIFI_JAM_DEFAULT_FALLOFF_RADIUS);
            };

            class GVAR(addWifiJammer_frequency): Edit {
                property = QGVAR(addWifiJammer_frequency);
                displayName = CSTRING(moduleAddWifiJammer_frequency_displayName);
                tooltip = CSTRING(moduleAddWifiJammer_frequency_tooltip);
                typeName = "NUMBER";
                defaultValue = QUOTE(WIFI_JAM_DEFAULT_FREQUENCY);
            };

            class ModuleDescription: ModuleDescription {};
        };

        class ModuleDescription: ModuleDescription {
            description = CSTRING(moduleAddWifiJammer_description);
        };
    };
};
