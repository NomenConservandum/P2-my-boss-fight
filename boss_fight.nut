printl("script is working\n");
//
// Global Variables
//
GLaDOS_health <- 4; // GLaDOS' health
GLaDOS_state <- false // is GLaDOS active?
is_hiding <- false; // is player hiding?

//
// Triggers' Logic
//
function istriggered() {
	is_hiding = true;
    printl("Where are you!?");
}

function is_not_triggered() {
	is_hiding = false;
    printl("Here you are!");
}

//
// GLaDOS' logic
//

function activate_the_villian() {
    GLaDOS_state = true;
}

// attacks according to the players state, or not if disabled
function glados_attacking_abilities_update() {
    if (GLaDOS_state) { // GLaDOS is active
        local mode_rifle = is_hiding ? "Enable" : "Disable"
        local mode_bombs = is_hiding ? "Disable" : "Enable"
        // bombs
        EntFire("bombs_shooting_logic", mode_bombs, null, 0, null)
        EntFire("viewoftank_trigger", mode_bombs, null, 0, null)
        EntFire("bombs_reload_relay", mode_bombs, null, 0, null)
        if (!is_hiding) {EntFire("SMG_alt_counter", "SetValue", 3, 0, null)}
        // rifles
        EntFire("shooting_logic", mode_rifle, null, 0, null)
        EntFire("shooting_logic_timer", mode_rifle, null, 0, null)
        if (is_hiding) {EntFire("turret_holder_counter", "SetValue", 5, 0, null)}
    } else { // GLaDOS is inactive
        // disable both
        local arr = ["bombs_shooting_logic", "viewoftank_trigger", "bombs_reload_relay", "shooting_logic", "shooting_logic_timer"]
        for (local k = 0; k < 5; ++k) {
            EntFire(arr[k], "Disable", null, 0, null)
            printl("Disabling " + arr[k] + "!")
        }
    }
}

function glados_wakes_up() {
    printl("GLaDOS is waking up!");
    // can make an array of animation names where health is used as an index, as lower the healthbar, the more angry and exhausted are the animations
    EntFire("GLaDOS_model", "SetAnimation", "glados_its_been_fun", 0, null);
    EntFire("tank_*", "Activate", null, 0, null);
    if (GLaDOS_health % 2 == 1) {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated_more", 0, null);
    } else {
        EntFire("GLaDOS_model", "SetDefaultAnimation", "glados_idle_agitated", 0, null);
    }
    GLaDOS_state = true; // GLaDOS' state is now "active"
    glados_attacking_abilities_update(); // Thus, she can attack now
}

function glados_is_attacked() {
    printl("GLaDOS is being attacked!!! Is nice.");
    // plays the animations and sounds (maybe some environmental changes: lighting changes, earthquakes, etc)
    EntFire("spin_disk_" + GLaDOS_health, "Stop", null, 0, null);
    EntFire("spin_disk_1_exp_sound", "PlaySound", null, 0.1, null);
    EntFire("spark_" + GLaDOS_health, "StartSpark", null, 0, null);
    EntFire("power_off_01", "PlaySound", null, 0.5, null);

    EntFire("GLaDOS_model", "SetAnimation", "sp_sabotage_glados_dropped", 0, null);
    EntFire("GLaDOS_model", "SetDefaultAnimation", "fgbwheatleytransfer03", 0, null);
    EntFire("tank_*", "Deactivate", null, 0, null);
    EntFire("GLaDOS_damage_beep", "PlaySound", null, 0, null);
    
    GLaDOS_state = false; // GLaDOS' state is now "inactive"
    glados_attacking_abilities_update(); // Thus, she cannot attack for now
    GLaDOS_health--; // healthbar is lowered
    printl("GLaDOS' health: " + GLaDOS_health);
    if (GLaDOS_health <= 0) { // checks healthbar
        SendToConsole("say GLaDOS is dead!")
    } else {
        EntFire("screen_diagnostic_slideshow", "Trigger", null, 0, null); // diagnostics animation
        // glados_wakes_up call
    }
    
}