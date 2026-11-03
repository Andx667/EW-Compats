class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Combo;
            class ModuleDescription;
        };

        class ModuleDescription {};
    };

    class GVAR(moduleAddSensor): Module_F {
        scope = 2;
        displayName = CSTRING(moduleAddSensor_displayName);
        icon = SENSOR_ICON;
        vehicleClass = "Modules";
        category = QGVAR(modules);
        function = QFUNC(moduleAddSensor);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 0;

        class Attributes: AttributesBase {
            class GVAR(side): Combo {
                property = QGVAR(side);
                displayName = CSTRING(module_side_displayName);
                tooltip = CSTRING(module_side_tooltip);
                defaultValue = QUOTE(SENSOR_SIDE_WEST);
                typeName = "NUMBER";
                class Values {
                    class West {
                        name = CSTRING(side_west);
                        value = SENSOR_SIDE_WEST;
                    };
                    class East {
                        name = CSTRING(side_east);
                        value = SENSOR_SIDE_EAST;
                    };
                    class Independent {
                        name = CSTRING(side_independent);
                        value = SENSOR_SIDE_INDEPENDENT;
                    };
                };
            };

            class ModuleDescription: ModuleDescription {};
        };

        class ModuleDescription: ModuleDescription {
            description = CSTRING(moduleAddSensor_description);
            sync[] = {"AnyStaticObject", "AnyVehicle"};
        };
    };
};
