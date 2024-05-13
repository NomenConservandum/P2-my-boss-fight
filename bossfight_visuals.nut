printl("Visual script is working\n")

//
// VScript file for visuals
//


//
//  Simple functions
//

function monitor_ammo_update(ammo) {
    printl("Monitor is updated")
    EntFire("num2_*", "Disable", null, 0.00, null)
    EntFire("num2_" + ("" + ammo), "Enable", null, 0.00, null)
}

function bomb_shooting_seq() {
    printl("Bomb sequence")
    EntFire("bombtrain", "TeleportToPathNode", "bombpath1", 0, null)
    EntFire("grenade_preview", "EnableDraw", null, 0.1, null)
    EntFire("bombtrain", "StartForward", null, 0.1, null)
    EntFire("tube_suction_bombs", "PlaySound", null, 0.6, null) // to be replaced with a playsound command
    EntFire("grenade_preview", "DisableDraw", null, 1, null)
}

function bomb_launcher_light() {
    printl("Muzzle light")
    EntFire("bombs_shooting_light", "TurnOn", null, 1, null)
    for (local k = 5; k > 0; --k) {
        EntFire("bombs_shooting_light", "brightness", "" + k, 1.5 - 0.1*k, null)
    }
    EntFire("bombs_shooting_light", "TurnOff", null, 1.5, null)
}

function rifle_seq() {
    printl("Rifle sequence")
    EntFire("weapon_wholebodymovementreload", "Open", null, 0, null)
    EntFire("weapon_aim_sprite", "HideSprite", null, 0, null)
    EntFire("weapon_barell_door", "Open", null, 0.5, null)
    EntFire("weapon_wholebodymovementreload", "Close", null, 0.5, null)
    EntFire("robot_pos_interact", "PlaySound", null, 1, null) // to be replaced with a playsound command
    EntFire("shooting_light", "TurnOn", null, 1, null)
    EntFire("shooting_light", "TurnOff", null, 1.05, null)
}

//
//  Composed functions
//

function bomb_visuals() {
    EntFire("bombs_beep", "PlaySound", null, 0, null) // to be replaced with a playsound command
    EntFire("bomb_shoot_sound", "PlaySound", null, 1, null) // to be replaced with a playsound command
    // bomb launcher's sequence
    bomb_shooting_seq()
    // monitor's visuals
    monitor_ammo_update(ammo)
    EntFire("MC_brush_normal", "Color", "0 255 0", 0, null)
    EntFire("MC_brush_normal", "Color", "255 0 0", 1.5, null)
    // muzzle-light's logic
    bomb_launcher_light()
}

function rifle_visuals() {
    // monitor's visuals
    monitor_ammo_update(ammo)
    EntFire("MC_brush_normal", "Color", "0 255 0", 1, null)
    EntFire("MC_brush_normal", "Color", "255 0 0", 1.5, null)
    // rifle's sequence
    rifle_seq()
}

function wakeup_visuals(GLaDOS_health) {
    EntFire("GLaDOS_model", "SetAnimation", "glados_its_been_fun", 0, null)
    if (GLaDOS_health % 2 == 1) {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated_more", 0, null) 
    } else {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated", 0, null) 
    }
}