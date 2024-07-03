printl("Visual script is working\n")

//
// VScript file for visuals
//

class monitor {
    function update(ammo, delay = 0, mod = false) {
        // printl("Monitor is updated")
        EntFire("num2_*", "Disable", null, delay + 0, null)
        EntFire("num2_" + ammo, "Enable", null, delay + 0.01, null)
        if (mod) {
            EntFire("MC_brush_normal", "Color", "0 255 0", delay + 1, null)
            EntFire("MC_brush_normal", "Color", "255 0 0", delay + 1.5, null)
        }
    }
}

//
//  Simple functions
//

function wakeup_visuals(health) {
    EntFire("GLaDOS_model", "SetAnimation", "glados_its_been_fun", 0, null)
    if (health % 2 == 1) {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated_more", 0, null)
    } else {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated", 0, null)
    }
}