printl("script is working\n") 

IncludeScript("bossfight/bossfight_visuals")

//
// Global Variables
//

Monitor <- monitor

class GLaDOS_class {
    health = 0 // GLaDOS' health
    state = false // is GLaDOS active?
    ammo = 0
    function wakeup() {
        state = true
    }
    function sleep() {
        state = false
    }
    function shoot_bomb(monitor = Monitor) {
        if (ammo == 0) {
            ammo = 3
            monitor.update(ammo)
            EntFire("portalgun_powerup1", "PlaySound", null, 1, null) // to be replaced with a playsound command
        }
        // shooting logic
        EntFire("tank_*", "Deactivate", null, 0, null)
        --ammo
        EntFire("bomb_launcher_eem", "ForceSpawn", null, 1, null)
        EntFire("tank_*", "Activate", null, 1.5, null)

        // bomb_visuals(ammo) // TO BE FIXED
    }
}

class Player_class {
    hiding = false // is player hiding?
}

Player <- Player_class()
GLaDOS <- GLaDOS_class()

//
// Triggers' Logic
//
function istriggered() {
	Player.hiding = true
    GLaDOS.ammo = 0
    shoot_rifle()
}

function is_not_triggered() {
    Player.hiding = false
    GLaDOS.ammo = 0
}

//
// GLaDOS' logic
//

function activate_the_villian() {
    GLaDOS.health = 4 // GLaDOS' health
    GLaDOS.wakeup()
}

// to shoot bombs
function shoot_bombs() {
    if (Player.hiding || !GLaDOS.state) return // if it's not the bombs mode or GLaDOS is inactive, we don't use it
    GLaDOS.shoot_bomb()
}

//to shoot from the rifle
function shoot_rifle() {
    if (!Player.hiding || !GLaDOS.state) return // if it's not the rifle mode or GLaDOS is inactive, we don't use it
    if (GLaDOS.ammo == 0) {
        GLaDOS.ammo = 5
        Monitor.update(GLaDOS.ammo)
        EntFire("MC_brush_normal", "Color", "255 255 255", 1, null)
        EntFire("portalgun_powerup1", "PlaySound", null, 1, null) // to be replaced with a playsound command
    }
    // shooting logic
    --GLaDOS.ammo
    EntFire("smg_turret", "FireBullet", "player_target", 1, null)
    EntFire("smg_turret", "Disable", null, 1.01, null)
    EntFire("game_n_script", "RunScriptCode", "shoot_rifle()", 1.5, null) // why use a timer when you can use self-bootstrap xd

    rifle_visuals(GLaDOS.ammo)
}

function glados_wakes_up() {
    printl("GLaDOS is waking up!") 
    // can make an array of animation names where health is used as an index, as
    // lower the healthbar, the more angry and exhausted are the animations
    EntFire("tank_*", "Activate", null, 0, null)
    wakeup_visuals(GLaDOS.health)
    GLaDOS.wakeup() //state = true  // GLaDOS' state is now "active"
    shoot_bombs()  // Thus, she can attack now
    shoot_rifle()
}

function glados_is_attacked() {
    GLaDOS.sleep() //state = false // GLaDOS' state is now "inactive"
    --GLaDOS.health // healthbar is lowered
    printl("GLaDOS' health: " + GLaDOS.health)
    if (GLaDOS.health <= 0) { // checks the healthbar
        //if ( DBG ) printl("GLaDOS is dead!")
        // victory sequence
    } else {
        EntFire("screen_diagnostic_slideshow", "Trigger", null, 0, null)  // diagnostics animation
        // glados_wakes_up call
    }

    // visuals
    // plays the animations and sounds (maybe some environmental changes: lighting changes, earthquakes, etc)
    EntFire("spin_disk_" + GLaDOS.health, "Stop", null, 0, null)
    EntFire("spin_disk_1_exp_sound", "PlaySound", null, 0.1, null) // to be replaced with a playsound command
    EntFire("spark_" + GLaDOS.health, "StartSpark", null, 0, null)
    EntFire("power_off_01", "PlaySound", null, 0.5, null) // to be replaced with a playsound command

    EntFire("GLaDOS_model", "SetAnimation", "sp_sabotage_glados_dropped", 0, null) 
    EntFire("GLaDOS_model", "SetDefaultAnimation", "fgbwheatleytransfer03", 0, null) 
    EntFire("tank_*", "Deactivate", null, 0, null)
    EntFire("GLaDOS_damage_beep", "PlaySound", null, 0, null) // to be replaced with a playsound command
}


//
// Prework on dev stage
//
EntFire("viewoftank_trigger", "Enable", null, 0, null)
// GLaDOS.state = true
EntFire("tank_*", "SetTargetEntity", "player_target", 0, null)
EntFire("player_detector", "SetTargetEntity", "player_target", 0, null)