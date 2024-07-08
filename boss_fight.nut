printl("script is working\n")

    
//
// Global Variables
//

IncludeScript("bossfight/bossfight_visuals") // imports Monitor class instance and visual agents for weapon classes

IncludeScript("bossfight/bossfight_logic") // imports Player and GLaDOS class instances with weapons' classes

//
// GLaDOS' logic
//

function activate_the_villian() {
    GLaDOS.sethealth(4)
    GLaDOS.wakeup()
}

function glados_wakes_up() {
    // printl("GLaDOS is waking up!")
    // can make an array of animation names where health is used as an index, as
    // lower the healthbar, the more angry and exhausted are the animations
    EntFire("tank_*", "Activate", null, 0, null)
    wakeup_visuals(GLaDOS.health())
    GLaDOS.wakeup() //state = true  // GLaDOS' state is now "active"
    GLaDOS.shoot_bomb()  // Thus, she can attack now
    GLaDOS.shoot_rifle()
}

function glados_is_attacked() {
    GLaDOS.sleep() //state = false // GLaDOS' state is now "inactive"
    GLaDOS.takedamage() // healthbar is lowered
    printl("GLaDOS' health: " + GLaDOS.health())
    if (GLaDOS.health <= 0) { // checks the healthbar
        // victory sequence
    } else {
        EntFire("screen_diagnostic_slideshow", "Trigger", null, 0, null)  // diagnostics animation
        // glados_wakes_up call
    }

    // visuals
    // plays the animations and sounds (maybe some environmental changes: lighting changes, earthquakes, etc)
    EntFire("spin_disk_" + GLaDOS.health(), "Stop", null, 0, null)
    EntFire("command", "Command", "play \"props/explosions/explo_generic_med_02.wav\"", 0.1, null)
    EntFire("spark_" + GLaDOS.health(), "StartSpark", null, 0, null)
    EntFire("command", "Command", "play \"world/light_power_off_01.wav\"", 0.5, null)

    EntFire("GLaDOS_model", "SetAnimation", "sp_sabotage_glados_dropped", 0, null)
    EntFire("GLaDOS_model", "SetDefaultAnimation", "fgbwheatleytransfer03", 0, null)
    EntFire("tank_*", "Deactivate", null, 0, null)
    EntFire("command", "Command", "play \"world/robot_parts/robot_neg_interact.wav\"", 0, null)
}


//
// Prework on dev stage
//
EntFire("viewoftank_trigger", "Enable", null, 0, null)
EntFire("tank_*", "SetTargetEntity", "player_target", 0, null)
EntFire("player_detector", "SetTargetEntity", "player_target", 0, null)
EntFire("glass_window_break_model", "DisableDraw", null, 0, null)
EntFire("glass_window_break_light", "TurnOff", null, 0, null)