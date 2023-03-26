local function start_listener()
    core:add_listener(
        "gw_rename_lord",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "character_details_panel"
        end,
        function(context)
            cm:repeat_real_callback(function()
                local p = find_uicomponent("character_details_panel")
                if not is_uicomponent(p) then
                    cm:remove_real_callback("rename_ll")
                    core:remove_listener("char_details_panel_close")
                    return
                end
    
                local button = find_uicomponent(p, "character_context_parent", "holder_br", "bottom_buttons", "button_rename")
                if is_uicomponent(button) then
                    if button:CurrentState() == "inactive" then
                        button:SetState("active")
                    end
                end
            end, 50, "rename_ll")
    
            core:add_listener(
                "char_details_panel_close",
                "PanelClosedCampaign",
                function(context)
                    return context.string == "character_details_panel"
                end,
                function()
                    cm:remove_real_callback("rename_ll")
                end,
                false
            )
        end,
        true
    )
end

local function stop_listener()
    core:remove_listener("gw_rename_lord")
end

local function init()
    local mct = get_mct()
    local mod = mct:get_mod_by_key("groovy_tweaks")
    local option = mod:get_option_by_key("rename_legendary_lord")

    if option:get_finalized_setting() then
        start_listener()
    else
        stop_listener()
    end
end

core:add_listener(
    "gw_rename_lord_init",
    "MctInitialized",
    true,
    function(context)
        init()
    end,
    true
)

core:add_listener(
    "gw_rename_lord_finalized",
    "MctFinalized",
    true,
    function(context)
        init()
    end,
    true
)