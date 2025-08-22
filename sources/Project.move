module MyModule::FoodSafetyTracking {
    use aptos_framework::signer;
    use std::string::{Self, String};
    use aptos_framework::timestamp;

    /// Struct representing a food item with safety tracking information.
    struct FoodItem has store, key {
        name: String,           // Name of the food item
        origin: String,         // Origin/source of the food
        production_date: u64,   // Timestamp when food was produced
        expiry_date: u64,       // Timestamp when food expires
        current_location: String, // Current location in supply chain
        is_safe: bool,          // Safety status of the food item
        last_updated: u64,      // Last update timestamp
    }

    /// Function to register a new food item in the tracking system.
    public fun register_food_item(
        owner: &signer, 
        name: String, 
        origin: String,
        production_date: u64,
        expiry_date: u64,
        initial_location: String
    ) {
        let current_time = timestamp::now_seconds();
        
        let food_item = FoodItem {
            name,
            origin,
            production_date,
            expiry_date,
            current_location: initial_location,
            is_safe: true,
            last_updated: current_time,
        };
        
        move_to(owner, food_item);
    }

    /// Function to update the location and safety status of a food item.
    public fun update_food_status(
        updater: &signer,
        food_owner: address,
        new_location: String,
        safety_status: bool
    ) acquires FoodItem {
        let food_item = borrow_global_mut<FoodItem>(food_owner);
        let current_time = timestamp::now_seconds();
        
        // Update the food item's location and safety status
        food_item.current_location = new_location;
        food_item.is_safe = safety_status;
        food_item.last_updated = current_time;
    }
}