--- this scropt changes the names of regions based on the occupant of that region
--- it runs through all regions *once*, and applies the occupation-string; otherwise, it's only triggered when a region changes hands

local base_loc = "campaign_localised_strings_string_"

-- default settings - edited through MctInitialized/MctFinalized if MCT 2.0 is enabled
local settings = {
    ["loreful"] = true,
    ["iffy"] = true,
    ["goofy"] = false,
    ["translation"] = false,
}

local loc_to_setting = require("groove/settlement_renames/loc_to_setting")

local function is_key_valid_for_settings(name_loc)
    ModLog("NEW SETTLEMENT WHO DIS: test with name_loc ["..name_loc.."]")
    local setting_for_loc = loc_to_setting[name_loc]
    if is_string(setting_for_loc) then
        setting_for_loc = string.lower(setting_for_loc)
        ModLog("NEW SETTLEMENT WHO DIS: setting found ["..setting_for_loc.."]")

        return settings[setting_for_loc]
    end

    ModLog("NEW SETTLEMENT WHO DIS: no setting found, returning false")
    return false
end

-- grab the loc key for the region, based on occupying subcult/faction
local function get_key_for_region(region_obj)
    local test = ""
    
    local region_key = region_obj:name()
    local faction_obj = region_obj:owning_faction()

    -- assign an abandoned loc if applicable
    if region_obj:is_abandoned() then
        if common.get_localised_string(base_loc..region_key.."_abandoned") ~= "" then
            test = base_loc..region_key.."_abandoned"
        end
    else
        if not faction_obj:is_null_interface() then
            -- subculture takes lowest prio, faction takes highest
            local subculture = faction_obj:subculture()
            local faction_key = faction_obj:name()

            if common.get_localised_string(base_loc..region_key.."_"..subculture) ~= "" then
                test = base_loc..region_key.."_"..subculture
            end

            if common.get_localised_string(base_loc..region_key.."_"..faction_key) ~= "" then
                test = base_loc..region_key.."_"..faction_key
            end
        end
    end


    -- default to the vanilla region name if no unique ones exist, or if the setting isn't valid for this region
    if test == "" or not is_key_valid_for_settings(test) then
        test = "regions_onscreen_"..region_key
    end

    return test
end

-- assign either the unique internal loc for a region based on occupant - or default to the settlement's OG name otherwise
local function setup_region(region_obj, skaven_allowed)
    local region_key = region_obj:name()
    local faction_obj = region_obj:owning_faction()

    -- skaven_allowed is `true` through the NameChangeChecker_Skv listener, allowing this to be bypassed
    if not skaven_allowed then
        -- if the settlement is owned by Skaven AI, keep its name the same until they're discovered (re: "NameChangeChecker_Skv" below)
        if not faction_obj:is_null_interface() and faction_obj:subculture() == "wh2_main_skv_skaven" and not faction_obj:is_human() then
            return
        end
    end

    local name_loc = get_key_for_region(region_obj)

    --cm:change_localised_region_name(region_obj, name_loc) ---- doesn't work atm
    cm:change_localised_settlement_name(region_obj:settlement(), name_loc)
end

-- loop through all regions and check their name
local function init()
    local region_list = cm:model():world():region_manager():region_list()

    for i = 0, region_list:num_items() -1 do
        local region = region_list:item_at(i)
        setup_region(region, false)
    end

    cm:set_saved_value("name_changes_init", true)
end

local function main()
    -- only ever run once
    if not cm:get_saved_value("name_changes_init") then
        init()
    end

    -- when a region changes hands (abandoned, conquered, etc), check its status
    core:add_listener(
        "NameChangeChecker",
        "RegionFactionChangeEvent",
        true,
        function(context)
            setup_region(context:region(), false)
        end,
        true
    )

    -- when a Skaven region is discovered by any human player, change its name
    core:add_listener(
        "NameChangeChecker_Skv",
        "GarrisonResidenceExposedToFaction",
        function(context)
            return context:garrison_residence():faction():subculture() == "wh2_main_sc_skv_skaven" and context:encountering_faction():is_human()
        end,
        function(context)
            setup_region(context:garrison_residence():region(), true)
        end,
        true
    )
end

-- MCT listeners
core:add_listener(
    "mct_init",
    "MctInitialized",
    true,
    function(context)
        local mct = context:mct()
        local mct_mod = mct:get_mod_by_key("groovy_tweaks")
    
        local loreful = mct_mod:get_option_by_key("loreful")
        local iffy = mct_mod:get_option_by_key("iffy")
        local translation = mct_mod:get_option_by_key("translation")
        local goofy = mct_mod:get_option_by_key("goofy")
    
        settings.loreful = loreful:get_finalized_setting()
        settings.iffy = iffy:get_finalized_setting()
        settings.translation = translation:get_finalized_setting()
        settings.goofy = goofy:get_finalized_setting()
    end,
    true
)

core:add_listener(
    "mct_finalized",
    "MctFinalized",
    true,
    function(context)
        local mct = context:mct()
        local mct_mod = mct:get_mod_by_key("groovy_tweaks")

        local loreful = mct_mod:get_option_by_key("loreful")
        local iffy = mct_mod:get_option_by_key("iffy")
        local translation = mct_mod:get_option_by_key("translation")
        local goofy = mct_mod:get_option_by_key("goofy")

        settings.loreful = loreful:get_finalized_setting()
        settings.iffy = iffy:get_finalized_setting()
        settings.translation = translation:get_finalized_setting()
        settings.goofy = goofy:get_finalized_setting()
    end,
    true
)

cm:add_first_tick_callback(function() main() end)

