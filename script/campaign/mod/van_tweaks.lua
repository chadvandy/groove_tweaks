local mct = get_mct()

local defaults = {
    allied_recruitment_points = 2,
    -- allied_recruitment_cap = 2,
}

--- TODO localize the MCT stuff
--- TODO option to apply the overriden values to AI as well as players
--- TODO add in allegiance-increase-percent effect 
--- TODO add in an option to "prevent AI outposts from the same faction"
--- TODO add in an action to "open an outpost slot for targeted ally"
local points_effect = "wh3_main_effect_allied_recruitment_points"
-- local cap_effect = "wh3_main_effect_allied_recruitment_unit_cap"
local eb_key = "van_tweaks_allied_recruitment"

local function update()
    VLib.Log("Updating Allied Recruitment, new values are cap: %d; points: %d", defaults.allied_recruitment_cap, defaults.allied_recruitment_points)
    local player_bundle = cm:create_new_custom_effect_bundle(eb_key)
    player_bundle:add_effect(points_effect, "faction_to_faction_own_unseen", defaults.allied_recruitment_points)
    -- player_bundle:add_effect(cap_effect, "faction_to_faction_own_unseen", defaults.allied_recruitment_cap)

    for i,faction_key in ipairs(cm:get_human_factions()) do
        local faction = cm:get_faction(faction_key, false)
        cm:apply_custom_effect_bundle_to_faction(player_bundle, faction)
    end
end

local function init()
    if not cm:get_saved_value("van_tweaks") then
        local f_list = cm:model():world():faction_list()

        --- Apply the default values to all AI factions.
        local ai_bundle = cm:create_new_custom_effect_bundle(eb_key)
        ai_bundle:add_effect(points_effect, "faction_to_faction_own_unseen", 2)
        -- ai_bundle:add_effect(cap_effect, "faction_to_faction_own_unseen", 2)

        local player_bundle = cm:create_new_custom_effect_bundle(eb_key)
        player_bundle:add_effect(points_effect, "faction_to_faction_own_unseen", defaults.allied_recruitment_points)
        -- player_bundle:add_effect(cap_effect, "faction_to_faction_own_unseen", defaults.allied_recruitment_cap)

        -- --- DEBUG
        -- player_bundle:add_effect("")
        
        ---@param i number
        ---@param faction FACTION_SCRIPT_INTERFACE
        for i,faction in model_pairs(f_list) do
            if faction:is_human() then
                cm:apply_custom_effect_bundle_to_faction(player_bundle, faction)
            else
                cm:apply_custom_effect_bundle_to_faction(ai_bundle, faction)
            end
        end

        cm:set_saved_value("van_tweaks", true)
    end
end

core:add_listener(
    "MctInit",
    "MctInitialized",
    true,
    function(context)
        local mod = mct:get_mod_by_key("van_tweaks")
        defaults = mod:get_settings()
    end,
    true
)

core:add_listener(
    "MctFinalized",
    "MctFinalized",
    true,
    function(context)
        local mod = mct:get_mod_by_key("van_tweaks")
        defaults = mod:get_settings()
        update()
    end,
    true
)

cm:add_first_tick_callback(init)