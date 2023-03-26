local settings = {
    camera_minimum_height = 10,
    camera_maximum_height = 150,
    show_shroud = false,
}

local function camera()

    cm:set_camera_minimum_height(settings.camera_minimum_height)
    cm:set_camera_maximum_height(settings.camera_maximum_height)

    cm:show_shroud(settings.show_shroud)
    -- if settings.show_shroud == false then
    --     cm:take_shroud_snapshot()
    -- else
    --     cm:restore_shroud_from_snapshot()
    --     cm:show_shroud(settings.show_shroud)
    -- end
end

local is_ok = false
local function update(first)
    local mct = get_mct()
    local mod = mct:get_mod_by_key("groovy_tweaks")

    local camera_minimum_height = mod:get_option_by_key("camera_minimum_height")
    local camera_maximum_height = mod:get_option_by_key("camera_maximum_height")
    local show_shroud = mod:get_option_by_key("show_shroud")

    settings.camera_minimum_height = camera_minimum_height:get_finalized_setting()
    settings.camera_maximum_height = camera_maximum_height:get_finalized_setting()
    settings.show_shroud = show_shroud:get_finalized_setting()

    if first then
        is_ok = true
    end

    if is_ok then
        camera()
    end
end

local function init()
    local mct = get_mct()
    local mod = mct:get_mod_by_key("groovy_tweaks")

    local take_shroud_snapshot = mod:get_option_by_key("take_shroud_snapshot")
    local restore_shroud_from_snapshot = mod:get_option_by_key("restore_shroud_from_snapshot")

    take_shroud_snapshot:set_callback(function() cm:take_shroud_snapshot() end)
    restore_shroud_from_snapshot:set_callback(function() cm:restore_shroud_from_snapshot() end)

    update(true)
end

cm:add_first_tick_callback(init)

core:add_listener(
    "mct_camera_settings",
    "MctFinalized",
    true,
    function(context)
        update()
    end,
    true
)

core:add_listener(
    "mct_camera_settings",
    "MctInitialized",
    true,
    function(context)
        update()
    end,
    true
)

-- return {
--     section_key = "camera_settings",

--     game_mode = __lib_type_campaign,

--     --- Called on First Tick Callback
--     init = function(settings) camera(settings) end,

--     --- Called on MctFinalized
--     update = function(settings) camera(settings) end,
-- }