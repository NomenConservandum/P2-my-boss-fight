printl("logic script is on-line")

//
// WEAPONS
//

class weapon {
    ammo = 0
    function reload_seq(amount = 3) {
        // printl("reload sequence")
        ammo = amount
        SendToConsole("play \"weapons/portalgun_powerup1.wav\"")
    }
}

class bomb_launcher extends weapon {
    function load_seq(monitor = Monitor) { //: VISUALS
        // printl("load sequence")
        monitor.update(ammo, 0.6)
        EntFire("command", "Command", "play \"weapons/rocket/rocket_locking_beep1.wav\"", 0, null)
        EntFire("bombtrain", "TeleportToPathNode", "bombpath1", 0, null)
        EntFire("grenade_preview", "EnableDraw", null, 0.1, null)
        EntFire("bombtrain", "StartForward", null, 0.1, null)
        EntFire("command", "Command", "play \"world/tube_suction_object_01.wav\"", 0.6, null)

    }
    function light_seq() { //: VISUALS
        // printl("muzzle light")
        EntFire("bombs_shooting_light", "TurnOn", null, 1, null)
        for (local k = 5; k > 0; --k) {
            EntFire("bombs_shooting_light", "brightness", "" + k, 1.5 - 0.1*k, null)
        }
        EntFire("bombs_shooting_light", "TurnOff", null, 1.5, null)
    }
    function shoot_seq(monitor = Monitor) {
        monitor.update(ammo, 1)
        EntFire("grenade_preview", "DisableDraw", null, 1, null)
        EntFire("command", "Command", "play \"labs/chicken_tube.wav\"", 1, null)
    }
}

class rifle extends weapon{
    function body_seq() { // rifle's sequence: VISUALS
        //printl("Rifle sequence")
        EntFire("weapon_wholebodymovementreload", "Open", null, 0, null)
        EntFire("weapon_aim_sprite", "HideSprite", null, 0, null)
        EntFire("weapon_barell_door", "Open", null, 0.5, null)
        EntFire("weapon_wholebodymovementreload", "Close", null, 0.5, null)
        EntFire("command", "Command", "play \"world/robot_parts/robot_pos_interact.wav\"", 1, null)
        EntFire("shooting_light", "TurnOn", null, 1, null)
        EntFire("shooting_light", "TurnOff", null, 1.05, null)
    }
}

//
// CHARACTERS
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

    function shoot_bomb(player = Player, monitor = Monitor) {
        if (player.hiding || !state) return // if it's not the bombs mode or GLaDOS is inactive, we don't use it
        if (Bomb_launcher.ammo == 0) {
            Bomb_launcher.reload_seq(3)
        }
        EntFire("tank_*", "Deactivate", null, 1, null)
        EntFire("bomb_launcher_eem", "ForceSpawn", null, 1, null)
        EntFire("tank_*", "Activate", null, 2, null)
        Bomb_launcher.load_seq()
        --Bomb_launcher.ammo
        Bomb_launcher.shoot_seq()
        Bomb_launcher.light_seq()
    }
    function shoot_rifle(player = Player, monitor = Monitor) {
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