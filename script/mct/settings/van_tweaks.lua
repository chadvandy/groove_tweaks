--- TODO the different settings for each tweak

local mod = get_mct():register_mod("van_tweaks")

mod:add_new_section("allied_recruitment", "Allied Recruitment Settings")

--- TODO see if dis possibluh
-- local recruitment_enabled = mod:add_new_option("allied_recruitment_enabled", 'checkbox')
-- recruitment_enabled:set_text("Allied Recruitment Enabled")
-- recruitment_enabled:set_tooltip_text("Set to disable to prevent any allied recruitment")
-- recruitment_enabled:set_default_value(true)

--- wh3_main_effect_allied_recruitment_points
---@type MCT.Option.Slider
local points = mod:add_new_option("allied_recruitment_points", "slider")
points:slider_set_min_max(1, 8)
points:set_default_value(2)

--- TODO an allegiance modifier setting, to increase/decrease the rate at which you can get allegiance points

-- -- TODO can't really edit this right now (:
-- --- wh3_main_effect_allied_recruitment_unit_cap
-- local cap = mod:add_new_option("allied_recruitment_cap", "slider")
-- cap:slider_set_min_max(1, 19)
-- cap:set_default_value(2)
-- cap:set_uic_visibility(false, false)

mod:add_new_section("dynamic_settlement_skins")