printl("script is working\n")

IncludeScript("bossfight/bossfight_visuals")

//
// Global Variables
//

class player {
    target = "player_target"
    hiding = false // is player hiding?
}

Player <- player()

class glados {
    Bomb_launcher = bomb_launcher()
    Rifle = rifle()
    health = 0 // GLaDOS' health
    state = false // is GLaDOS active?

    function wakeup() {
        state = true
    }
    function sleep() {
        state = false
    }

    function shoot_bomb(monitor = Monitor, player = Player) {
        if (player.hiding || !state) return // if it's not the bombs mode or GLaDOS is inactive, we don't use it
        if (Bomb_launcher.ammo == 0) {
            Bomb_launcher.reload_seq(3)
        }
        EntFire("tank_*", "Deactivate", null, 0, null)
        EntFire("bomb_launcher_eem", "ForceSpawn", null, 1, null)
        EntFire("tank_*", "Activate", null, 1.5, null)
        Bomb_launcher.load_seq()
        --Bomb_launcher.ammo
        Bomb_launcher.shoot_seq()
        Bomb_launcher.light_seq()
    }
    function shoot_rifle(monitor = Monitor, player = Player) {
        if (!player.hiding || !state) return // if it's not the rifle mode or GLaDOS is inactive, we don't use it
        if (Rifle.ammo == 0) {
            monitor.update(5)
            Rifle.reload_seq(5)
        }
        // shooting logic
        --Rifle.ammo
        EntFire("smg_turret", "FireBullet", player.target, 1, null)
        EntFire("smg_turret", "Disable", null, 1.01, null)
        EntFire("game_n_script", "RunScriptCode", "GLaDOS.shoot_rifle()", 1.5, null) // why use a timer when you can use self-bootstrap xd

        Rifle.body_seq()

        // monitor's visuals
        monitor.update(Rifle.ammo, 1)
    }
}

GLaDOS <- glados()

//
// Triggers' Logic
//
function istriggered() {
	Player.hiding = true
    GLaDOS.shoot_rifle()
}

function is_not_triggered() {
    Player.hiding = false
}

function settarget(target_id, player = Player) {
    local targets = ["glass_window_break_target", "player_target"]
    player.target = targets[target_id]
    EntFire("tank_*", "SetTargetEntityName", player.target, 1, null)
}

//
// GLaDOS' logic
//

function activate_the_villian() {
    GLaDOS.health = 4 // GLaDOS' health
    GLaDOS.wakeup()
}

function glados_wakes_up() {
    printl("GLaDOS is waking up!")
    // can make an array of animation names where health is used as an index, as
    // lower the healthbar, the more angry and exhausted are the animations
    EntFire("tank_*", "Activate", null, 0, null)
    wakeup_visuals(GLaDOS.health)
    GLaDOS.wakeup() //state = true  // GLaDOS' state is now "active"
    GLaDOS.shoot_bomb()  // Thus, she can attack now
    GLaDOS.shoot_rifle()
}

function glados_is_attacked() {
    GLaDOS.sleep() //state = false // GLaDOS' state is now "inactive"
    --GLaDOS.health // healthbar is lowered
    printl("GLaDOS' health: " + GLaDOS.health)
    if (GLaDOS.health <= 0) { // checks the healthbar
        // victory sequence
    } else {
        EntFire("screen_diagnostic_slideshow", "Trigger", null, 0, null)  // diagnostics animation
        // glados_wakes_up call
    }

    // visuals
    // plays the animations and sounds (maybe some environmental changes: lighting changes, earthquakes, etc)
    EntFire("spin_disk_" + GLaDOS.health, "Stop", null, 0, null)
    EntFire("command", "Command", "play \"props/explosions/explo_generic_med_02.wav\"", 0.1, null)
    EntFire("spark_" + GLaDOS.health, "StartSpark", null, 0, null)
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