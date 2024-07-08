printl("logic script is on-line")

//
// WEAPONS
//

class weapon {
    ammo = 0
    
    function reload(amount) {
        ammo = amount
        SendToConsole("play \"weapons/portalgun_powerup1.wav\"")
    }
}

class bomb_launcher extends weapon {
    visual_agent = bomb_launcher_visuals()
    
    function shoot() {
        if (ammo == 0) {
            this.reload(3)
        }
        // shooting logic
        --ammo
        EntFire("tank_*", "Deactivate", null, 1, null)
        EntFire("bomb_launcher_eem", "ForceSpawn", null, 1, null)
        EntFire("tank_*", "Activate", null, 2, null)
    }
}

class rifle extends weapon {
    visual_agent = rifle_visuals()
    
    function shoot(target) {
        if (ammo == 0) {
            this.reload(5)
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

class creature {
    health = 0
    state = false // is player hiding? Is GLaDOS active?
    
    function wakeup() {
        state = true
    }
    function sleep() {
        state = false
    }
    function state() {
        return state
    }
    
    function health() {
        return health
    }
    function sethealth(hp = 4) {
        health = hp
    }
    function takedamage(hp = 1) {
        health -= hp
    }
}

class player extends creature {
    target = "player_target"
    
    function changetarget(target_id) {
        local targets = ["glass_window_break_target", "player_target"]
        this.target = targets[target_id]
        EntFire("tank_*", "SetTargetEntityName", this.target, 1, null)
    }
}

Player <- player()

class glados extends creature {
    // local weapons = [bomb_launcher(), rifle()]
    Bomb_launcher = bomb_launcher()
    Rifle = rifle()
    
    function shoot_bomb(player = Player) {
        if (player.state() || !state) return // if it's not the bombs mode or GLaDOS is inactive, we don't use it
        Bomb_launcher.visual_agent.load_seq(Bomb_launcher.ammo)
        
        Bomb_launcher.shoot()
        
        Bomb_launcher.visual_agent.shoot_seq(Bomb_launcher.ammo)
        Bomb_launcher.visual_agent.light_seq()
    }
    function shoot_rifle(player = Player) {
        if (!player.state() || !state) return // if it's not the rifle mode or GLaDOS is inactive, we don't use it
        Rifle.shoot(player.target)
        
        Rifle.visual_agent.shoot_seq(Rifle.ammo)
    }
}

GLaDOS <- glados()

//
// Triggers' Logic
//

function istriggered() {
	Player.wakeup()
    GLaDOS.shoot_rifle()
}

function is_not_triggered() {
    Player.sleep()
}