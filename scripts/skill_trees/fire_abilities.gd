extends Node
class_name FireAbilities

static var abilities = {
    "blazing_sword": {
        "name": "Blazing Sword",
        "type": "melee_stance",
        "damage": 24.0,
        "cooldown": 1.0,
        "cost_dust": 10,
        "description": "Engulfs weapon in flames for melee combat."
    },
    "flame_shield": {
        "name": "Flame Shield",
        "type": "orbiting_protection",
        "damage": 8.0,
        "cooldown": 2.0,
        "cost_dust": 14,
        "description": "Fire orbs orbit the caster, damaging enemies nearby."
    },
    "nest_phoenix": {
        "name": "Nest of Phoenix",
        "type": "aoe_zone",
        "damage": 22.0,
        "cooldown": 3.0,
        "cost_dust": 18,
        "description": "Creates a healing/damaging flame zone."
    },
    "rise": {
        "name": "Rise",
        "type": "damage_buff",
        "damage": 0.0,
        "cooldown": 2.5,
        "cost_dust": 12,
        "description": "Increases spell damage for 8 seconds."
    },
    "heat_from_within": {
        "name": "Heat From Within",
        "type": "radial_wave",
        "damage": 26.0,
        "cooldown": 2.8,
        "cost_dust": 16,
        "description": "Releases a devastating radial wave blast."
    },
    "flames_phoenix": {
        "name": "Flames of Phoenix",
        "type": "solar_firebomb",
        "damage": 30.0,
        "cooldown": 4.0,
        "cost_dust": 22,
        "description": "Ultimate: massive fire explosion from the sky."
    }
}

static func cast_ability(ability_id: String, caster: Node3D):
    if not abilities.has(ability_id):
        return
    var ability = abilities[ability_id]
    print("Casting %s!" % ability["name"])
