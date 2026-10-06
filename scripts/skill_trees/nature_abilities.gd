extends Node
class_name NatureAbilities

static var abilities = {
    "wicked_veins": {
        "name": "Wicked Veins",
        "type": "vine_rooting",
        "damage": 14.0,
        "cooldown": 1.8,
        "cost_dust": 11,
        "description": "Roots enemies in place with vine tendrils."
    },
    "blooming_life": {
        "name": "Blooming Life",
        "type": "pulsing_heal",
        "damage": 0.0,
        "cooldown": 3.0,
        "cost_dust": 16,
        "description": "Pulsing flower heal for allies and self."
    },
    "moss_field": {
        "name": "Moss Field",
        "type": "aoe_slow_heal",
        "damage": 10.0,
        "cooldown": 2.5,
        "cost_dust": 13,
        "description": "Creates terrain that slows enemies and heals allies."
    },
    "beast_aura": {
        "name": "Beast Aura",
        "type": "summon_deer",
        "damage": 0.0,
        "cooldown": 2.0,
        "cost_dust": 15,
        "description": "Summons a wooden deer minion."
    },
    "beast_two": {
        "name": "Beast of Two",
        "type": "summon_rhino",
        "damage": 20.0,
        "cooldown": 3.5,
        "cost_dust": 20,
        "description": "Summons rhino stampede that charges enemies."
    },
    "beast_aura_all": {
        "name": "Beast Aura of All",
        "type": "summon_bird",
        "damage": 28.0,
        "cooldown": 4.5,
        "cost_dust": 25,
        "description": "Ultimate: summons storm bird assault."
    }
}

static func cast_ability(ability_id: String, caster: Node3D):
    if not abilities.has(ability_id):
        return
    var ability = abilities[ability_id]
    print("Casting %s!" % ability["name"])
