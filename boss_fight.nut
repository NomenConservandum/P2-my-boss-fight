printl("script is working\n") 

//
// Global Variables
//

GLaDOS_health <- 4 // GLaDOS' health
GLaDOS_state <- false // is GLaDOS active?
is_hiding <- false // is player hiding?
ammo <- 0

//
// Triggers' Logic
//
function istriggered() {
	is_hiding = true
    ammo = 0
    shoot_rifle()
    // printl("Where are you!?")
}

function is_not_triggered() {
    is_hiding = false
    ammo = 0
    // printl("Here you are!")
}

//
// GLaDOS' logic
//

function activate_the_villian() {
    GLaDOS_state = true 
}

// to shoot bombs
function shoot_bombs() { // analog of bombs_shooting_logic entity
    printl("Bombs are called")
    if (is_hiding || !GLaDOS_state) return // if it's not the bombs mode or GLaDOS is inactive, we don't use it
    if (ammo == 0) {
        printl("Reloading")
        EntFire("num2_*", "Disable", null, 0.00, null)
        EntFire("portalgun_powerup1", "PlaySound", null, 1, null) // to be replaced with a playsound command
        ammo = 3
        EntFire("num2_3", "Enable", null, 0.00, null)
    }
    
    EntFire("bombs_beep", "PlaySound", null, 0, null) // to be replaced with a playsound command
    // shooting logic
    EntFire("tank_*", "Deactivate", null, 0, null)
    EntFire("MC_brush_normal", "Color", "0 255 0", 0, null)
    EntFire("bombs_visual_logic", "Trigger", null, 0, null)
    --ammo
    EntFire("num2_*", "Disable", null, 0.9, null)
    EntFire("num2_" + ("" + ammo), "Enable", null, 0.91, null)

    // visuals
    EntFire("bomb_launcher_eem", "ForceSpawn", null, 1, null)
    EntFire("bomb_shoot_sound", "PlaySound", null, 1, null) // to be replaced with a playsound command
    // muzzle-light's logic
    EntFire("bombs_shooting_light", "TurnOn", null, 1, null)
    for (local k = 5; k > 0; --k) {
        EntFire("bombs_shooting_light", "brightness", "" + k, 1.5 - 0.1*k, null)
    }
    EntFire("bombs_shooting_light", "TurnOff", null, 1.50, null)

    EntFire("tank_*", "Activate", null, 1.50, null)
}

//to shoot from the rifle
function shoot_rifle() {
    printl("Bullets are called")
    if (!is_hiding || !GLaDOS_state) return // if it's not the rifle mode or GLaDOS is inactive, we don't use it
    if (ammo == 0) {
        printl("Reloading")
        EntFire("num2_*", "Disable", null, 0.00, null)
        EntFire("portalgun_powerup1", "PlaySound", null, 1, null) // to be replaced with a playsound command
        ammo = 5
        EntFire("num2_5", "Enable", null, 0.01, null)
    }

    --ammo
    EntFire("num2_*", "Disable", null, 0.9, null)
    EntFire("num2_" + ("" + ammo), "Enable", null, 0.91, null)
    
    EntFire("shooting_light", "TurnOn", null, 1, null)
    EntFire("shooting_light", "TurnOff", null, 1.05, null)

    EntFire("smg_turret", "FireBullet", "player_target", 1, null)
    EntFire("smg_turret", "Disable", null, 1.01, null)
    
    // EntFire("num2_*", "Disable", null, 0.00, null)
    EntFire("MC_brush_normal", "Color", "0 255 0", 1, null)

    EntFire("game_n_script", "RunScriptCode", "shoot_rifle()", 1.5, null) // why use a timer when you can use self-bootstrap xd
}

function glados_wakes_up() {
    printl("GLaDOS is waking up!") 
    // can make an array of animation names where health is used as an index, as
    // lower the healthbar, the more angry and exhausted are the animations
    EntFire("GLaDOS_model", "SetAnimation", "glados_its_been_fun", 0, null) 
    EntFire("tank_*", "Activate", null, 0, null) 
    if (GLaDOS_health % 2 == 1) {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated_more", 0, null) 
    } else {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated", 0, null) 
    }
    GLaDOS_state = true  // GLaDOS' state is now "active"
    glados_attacking_abilities_update()  // Thus, she can attack now
}

function glados_is_attacked() {
    printl("GLaDOS is being attacked!!! Is nice.") 
    // plays the animations and sounds (maybe some environmental changes: lighting changes, earthquakes, etc)
    EntFire("spin_disk_" + GLaDOS_health, "Stop", null, 0, null) 
    EntFire("spin_disk_1_exp_sound", "PlaySound", null, 0.1, null) // to be replaced with a playsound command
    EntFire("spark_" + GLaDOS_health, "StartSpark", null, 0, null) 
    EntFire("power_off_01", "PlaySound", null, 0.5, null) // to be replaced with a playsound command

    EntFire("GLaDOS_model", "SetAnimation", "sp_sabotage_glados_dropped", 0, null) 
    EntFire("GLaDOS_model", "SetDefaultAnimation", "fgbwheatleytransfer03", 0, null) 
    EntFire("tank_*", "Deactivate", null, 0, null) 
    EntFire("GLaDOS_damage_beep", "PlaySound", null, 0, null) // to be replaced with a playsound command
    
    GLaDOS_state = false // GLaDOS' state is now "inactive"
    glados_attacking_abilities_update() // Thus, she cannot attack for now
    --GLaDOS_health // healthbar is lowered
    printl("GLaDOS' health: " + GLaDOS_health) 
    if (GLaDOS_health <= 0) { // checks healthbar
        SendToConsole("say GLaDOS is dead!")
    } else {
        EntFire("screen_diagnostic_slideshow", "Trigger", null, 0, null)  // diagnostics animation
        // glados_wakes_up call
    }
    
}


//
// Prework on dev stage
//
EntFire("viewoftank_trigger", "Enable", null, 0, null)
GLaDOS_state = true
ammo_tracker()
EntFire("tank_*", "SetTargetEntity", "player_target", 0, null)
EntFire("player_detector", "SetTargetEntity", "player_target", 0, null)