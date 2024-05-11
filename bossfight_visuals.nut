printl("Visual script is working\n")

//
// VScript file for visuals
//

function monitor_ammo_update(ammo) {
    EntFire("num2_*", "Disable", null, 0.00, null)
    EntFire("num2_" + ("" + ammo), "Enable", null, 0.00, null)
}