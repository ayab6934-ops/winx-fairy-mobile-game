extends Node
class_name WaterAbilities

static var abilities = {
    "bubble_jail": {
        "name": "Bubble Jail",
        "type": "lockdown",
        "damage": 12.0,
        "cooldown": 1.2,
        "cost_dust": 8,
        "description": "Traps enemies in crystalline bubbles."
    },
    "springs_whirlwind": {
        "name": "Springs Whirlwind",
        "type": "suction",
        "damage": 18.0,
        "cooldown": 2.0,
        "cost_dust": 12,
        "description": "Pulls enemies inward with water vortex."
    },
    "tide_wall": {
        "name": "Tide Wall",
        "type": "physics_push",
        "damage": 15.0,
        "cooldown": 1.8,
        "cost_dust": 10,
        "description": "Pushes enemies away with hydraulic force."
    },
    "hydro_drop": {
        "name": "Hydro Drop",
        "type": "vertical_stun",
        "damage": 20.0,
        "cooldown": 2.5,
        "cost_dust": 15,
        "description": "Drops a column of water that stuns on impact."
    },
    "bubble_shield": {
        "name": "Bubble Shield",
        "type": "invulnerability",
        "damage": 0.0,
        "cooldown": 3.5,
        "cost_dust": 20,
        "description": "Grants temporary invulnerability in a water bubble."
    },
    "water_orbs": {
        "name": "Water Orbs",
        "type": "retaliation",
        "damage": 16.0,
        "cooldown": 1.5,
        "cost_dust": 9,
        "description": "Launches multiple water spheres at enemies."
    }
}

static func cast_ability(ability_id: String, caster: Node3D):
    if not abilities.has(ability_id):
        return
    var ability = abilities[ability_id]
    print("Casting %s!" % ability["name"])
    # Future: implement full ability logic
