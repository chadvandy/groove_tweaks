local mct = get_mct()

local mod = mct:register_mod("groovy_tweaks")
mod:set_title("Groovy Tweaks")
mod:set_author("Groove Wizard")
mod:set_description("A collection of tweaks to the game.")
mod:set_version(0.1, "0.1")

local def = mod:get_default_settings_page()
local new_page = mod:create_settings_page("Renames", 2)
mod:set_default_settings_page(new_page)

def:remove()

local settlement_renames = mod:add_new_section("settlement_renames", "Settlement Renames")
settlement_renames:assign_to_page(new_page)

local loreful_option = mod:add_new_option("loreful", "checkbox")
loreful_option:set_text("Loreful Renames")
loreful_option:set_tooltip_text("Allow loreful settlement renames. These renames are pretty clear-cut and are backed by loreful sources.")
loreful_option:set_default_value(true)

local iffy_option = mod:add_new_option("iffy", "checkbox")
iffy_option:set_text("Semi-loreful Renames")
iffy_option:set_tooltip_text("Allow semi-loreful settlement renames. These ones are usually a bit of a stretch. I'm doing my best, ok?")
iffy_option:set_default_value(true)

local translation_option = mod:add_new_option("translation", "checkbox")
translation_option:set_text("Translations")
translation_option:set_tooltip_text("Allow translation renames. These take the name of a settlement and, if it's known, rename it to the language of the new settlement owner.")
translation_option:set_default_value(false)
local goofy_option = mod:add_new_option("goofy", "checkbox")
goofy_option:set_text("Wacky Renames")
goofy_option:set_tooltip_text("Allow wacky settlement renames. These ones are just straight up goofy, and are probably a joke. I can make jokes, can't I?")
goofy_option:set_default_value(false)

local lord_renames = mod:add_new_section("lord_renames", "Character Renames")
lord_renames:assign_to_page(new_page)

local rename_ll = mod:add_new_option("rename_legendary_lord", "checkbox")
rename_ll:set_text("Enable Legendary Lord Renames")
rename_ll:set_tooltip_text("Allows legendary lords to be renamed.")
rename_ll:set_default_value(true)

local camera_page = mod:create_settings_page("Camera", 2)

local camera = mod:add_new_section("camera", "Camera")
camera:assign_to_page(camera_page)

--- TODO this should be handled better, MCT-side.
do
    local sec_camera_settings = mod:add_new_section("camera_settings", "Camera Settings")
    sec_camera_settings:assign_to_page(camera_page)

    local high,low = 500,1

    local min = mod:add_new_option("camera_minimum_height", "slider")
    min:slider_set_min_max(low, high)
    min:set_default_value(10)

    local max = mod:add_new_option("camera_maximum_height", "slider")
    max:slider_set_min_max(low, high)
    max:set_default_value(150)

    min:add_option_set_callback (function(option)
        if min:get_selected_setting() >= max:get_selected_setting() then
            --- errmsg?
            min:set_selected_setting(math.clamp(max:get_selected_setting() - 1, low, high))
        end
    end, false)

    max:add_option_set_callback (function(option)
        if max:get_selected_setting() <= min:get_selected_setting() then
            --- errmsg?
            max:set_selected_setting(math.clamp(min:get_selected_setting() + 1, low, high))
        end
    end, false)

    local sec_shroud_settings = mod:add_new_section("shroud_settings", "Fog of War Settings")
    sec_shroud_settings:assign_to_page(camera_page)

    local shroud = mod:add_new_option("show_shroud", 'checkbox')
    shroud:set_default_value(true)
    shroud:set_text("Show Fog of War")
    shroud:set_tooltip_text("Show the Fog of War. If disabled, the Fog of War will be hidden, and you will be able to see the entire map.")

    local take_shroud_snapshot = mod:add_new_option("take_shroud_snapshot", 'action')
    take_shroud_snapshot:set_text("Take Shroud Snapshot")
    take_shroud_snapshot:set_button_text("Snapshot")

    --- TODO "lock" this if we haven't taken a snapshot yet.
    local restore_shroud_from_snapshot = mod:add_new_option("restore_shroud_from_snapshot", 'action')
    restore_shroud_from_snapshot:set_text("Restore Shroud from Snapshot")
    restore_shroud_from_snapshot:set_button_text("Restore")
    restore_shroud_from_snapshot:set_tooltip_text("This won't do anything if you haven't taken a snapshot already.")
end