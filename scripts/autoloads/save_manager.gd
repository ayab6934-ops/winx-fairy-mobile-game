extends Node

const SAVE_PATH = "user://winx_fairy_save.cfg"

func save_game_data():
    var config = ConfigFile.new()
    config.set_value("Inventory", "fashion", InventoryManager.fashion_inventory)
    config.set_value("Inventory", "food", InventoryManager.food_inventory)
    config.set_value("Inventory", "dust", InventoryManager.magical_dust_count)
    config.set_value("Inventory", "potions", InventoryManager.potions_inventory)
    config.set_value("PlayerState", "gender", GlobalCharacterManager.selected_gender)

    var error = config.save(SAVE_PATH)
    if error == OK:
        print("Fairy game profile saved to device storage.")

func load_game_data():
    var config = ConfigFile.new()
    var error = config.load(SAVE_PATH)
    if error != OK:
        return

    InventoryManager.fashion_inventory = config.get_value("Inventory", "fashion", {})
    InventoryManager.food_inventory = config.get_value("Inventory", "food", {})
    InventoryManager.magical_dust_count = config.get_value("Inventory", "dust", 0)
    InventoryManager.potions_inventory = config.get_value("Inventory", "potions", {})
    GlobalCharacterManager.selected_gender = config.get_value("PlayerState", "gender", "female")
    InventoryManager.inventory_updated.emit()
