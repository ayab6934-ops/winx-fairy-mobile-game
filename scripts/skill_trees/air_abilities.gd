extends Node
class_name AirAbilities

static var abilities = {
    "zephyr_slice": {
        "name": "Zephyr Slice",
        "type": "melee_slash",
        "damage": 19.0,
        "cooldown": 0.9,
        "cost_dust": 8,
        "description": "Fast wind blade slashes."
    },
    "gale_force_blast": {
        "name": "Gale Force Blast",
        "type": "ranged_push",
        "damage": 21.0,
        "cooldown": 1.6,
        "cost_dust": 11,
        "description": "Launches enemies away with wind force."
    },
    "cloud_cushion": {
        "name": "Cloud Cushion",
        "type": "evasion_buff",
        "damage": 0.0,
        "cooldown": 2.2,
        "cost_dust": 12,
        "description": "Increases evasion and movement speed temporarily."
    },
    "vacuum_vortex": {
        "name": "Vacuum Vortex",
        "type": "aoe_pull",
        "damage": 17.0,
        "cooldown": 2.3,
        "cost_dust": 14,
        "description": "Creates a vortex that pulls enemies together."
    },
    "sonic_dash": {
        "name": "Sonic Dash",
        "type": "mobility_strike",
        "damage": 23.0,
        "cooldown": 1.9,
        "cost_dust": 13,
        "description": "Dash forward striking all enemies in path."
    },
    "cyclone_tempest": {
        "name": "Cyclone Tempest",
        "type": "ultimate_tornado",
        "damage": 32.0,
        "cooldown": 4.5,
        "cost_dust": 26,
        "description": "Ultimate: spawns massive damaging tornado."
    }
}

static func cast_ability(ability_id: String, caster: Node3D):
    if not abilities.has(ability_id):
        return
    var ability = abilities[ability_id]
    print("Casting %s!" % ability["name"])
