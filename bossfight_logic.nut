printl("logic script is on-line")

//
// WEAPONS
//

class weapon {
    ammo = 0
    function reload_seq(amount) {
        ammo = amount
        SendToConsole("play \"weapons/portalgun_powerup1.wav\"")
    }
}

class bomb_launcher extends weapon {
    visual_agent = bomb_launcher_visuals()
    function shoot() {
        // if (hiding = false || !state = false) return // if it's not the bombs mode or GLaDOS is inactive, we don't use it
        if (ammo == 0) {
            this.reload_seq(3)
        }
        EntFire("tank_*", "Deactivate", null, 1, null)
        EntFire("bomb_launcher_eem", "ForceSpawn", null, 1, null)
        EntFire("tank_*", "Activate", null, 2, null)
        --ammo
    }
}

class rifle extends weapon {
    visual_agent = rifle_visuals()
    function shoot(target) {
        // if (!hiding || !state) return // if it's not the rifle mode or GLaDOS is inactive, we don't use it
        if (ammo == 0) {
            this.reload_seq(5)
        }
        // shooting logic
        --ammo
        EntFire("smg_turret", "FireBullet", target, 1, null)
        EntFire("smg_turret", "Disable", null, 1.01, null)
        EntFire("game_n_script", "RunScriptCode", "GLaDOS.shoot_rifle()", 1.5, null) // why use a timer when you can use self-bootstrap xd
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
        Bomb_launcher.visual_agent.load_seq(Bomb_launcher.ammo)
        
        Bomb_launcher.shoot()
        
        Bomb_launcher.visual_agent.shoot_seq(Bomb_launcher.ammo)
        Bomb_launcher.visual_agent.light_seq()
    }
    function shoot_rifle(player = Player, monitor = Monitor) {
        if (!player.hiding || !state) return // if it's not the rifle mode or GLaDOS is inactive, we don't use it
        Rifle.shoot(player.target)
        
        Rifle.visual_agent.shoot_seq(Rifle.ammo)
    }
}

GLaDOS <- glados()