extends Node

signal inventory_updated

var fashion_inventory: Dictionary = {}
var food_inventory: Dictionary = {}
var magical_dust_count: int = 0
var potions_inventory: Dictionary = {
    "health_elixir": 0,
    "flight_boost_potion": 0,
    "spell_power_brew": 0
}

func add_fashion_item(item_id: String):
    fashion_inventory[item_id] = fashion_inventory.get(item_id, 0) + 1
    inventory_updated.emit()

func add_food_item(item_id: String):
    food_inventory[item_id] = food_inventory.get(item_id, 0) + 1
    inventory_updated.emit()

func remove_food_item(item_id: String) -> bool:
    if food_inventory.has(item_id) and food_inventory[item_id] > 0:
        food_inventory[item_id] -= 1
        if food_inventory[item_id] == 0:
            food_inventory.erase(item_id)
        inventory_updated.emit()
        return true
    return false

func add_dust_currency(amount: int):
    magical_dust_count += amount
    inventory_updated.emit()

func craft_potion(potion_id: String) -> bool:
    var dust_cost: int = 0
    match potion_id:
        "health_elixir":
            dust_cost = 20
        "flight_boost_potion":
            dust_cost = 35
        "spell_power_brew":
            dust_cost = 50
        _:
            return false

    if magical_dust_count >= dust_cost:
        magical_dust_count -= dust_cost
        potions_inventory[potion_id] = potions_inventory.get(potion_id, 0) + 1
        inventory_updated.emit()
        return true
    return false
