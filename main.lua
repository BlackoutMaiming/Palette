palette = SMODS.current_mod

--UTIL FUNCTIONS
palette.save_config = function(self)
    SMODS.save_mod_config(self)
end

function palette_snapshot(val)
    local copy = {}
    for k, v in pairs(val) do
        if type(v) == "table" then
            copy[k] = palette_snapshot(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function palette_validate(val)
    local hexvals = "ABCDEF0123456789"
    for i = 1, 6 do
        local char = val:sub(i,i)
        if not string.find(hexvals,char) then
            return false
        end
    end
    return true
end

--allow 0 to be input to text fields
G.FUNCS.palette_text_input_key_hex = function(args)
    args = args or {}

    if args.key == '[' or args.key == ']' then return end
    if args.key == '0' then args.key = '0' end

    --shortcut to hook config
    local hook_config = G.CONTROLLER.text_input_hook.config.ref_table
    hook_config.orig_colour = hook_config.orig_colour or copy_table(hook_config.colour)

    args.key = args.key or '%'
    args.caps = args.caps or G.CONTROLLER.capslock or hook_config.all_caps --capitalize if caps lock or hook requires

    --Some special keys need to be mapped accordingly before passing through the corpus
    local keymap = {
        space = ' ',
        backspace = 'BACKSPACE',
        delete = 'DELETE',
        ['return'] = 'RETURN',
        right = 'RIGHT',
        left = 'LEFT'
    }
    local hook = G.CONTROLLER.text_input_hook
    local corpus = '0123456789ABCDEFabcdef'
    
    local text = hook_config.text

    --set key to mapped key or upper if caps is true
    args.key = string.upper(args.key)
    
    --Start by setting the cursor position to the correct location
    TRANSPOSE_TEXT_INPUT(0)

    if string.len(text.ref_table[text.ref_value]) > 0 and args.key == 'BACKSPACE' then --If not at start, remove preceding letter
        MODIFY_TEXT_INPUT{
            letter = '',
            text_table = text,
            pos = text.current_position,
            delete = true
        }
        TRANSPOSE_TEXT_INPUT(-1)
    elseif string.len(text.ref_table[text.ref_value]) > 0 and args.key == 'DELETE' then --if not at end, remove following letter
        MODIFY_TEXT_INPUT{
            letter = '',
            text_table = text,
            pos = text.current_position+1,
            delete = true
        }
        TRANSPOSE_TEXT_INPUT(0)
    elseif args.key == 'RETURN' then --Release the hook
        if hook.config.ref_table.callback then hook.config.ref_table.callback() end
        hook.parent.parent.config.colour = hook_config.colour
        local temp_colour = copy_table(hook_config.orig_colour)
        hook_config.colour[1] = G.C.WHITE[1]
        hook_config.colour[2] = G.C.WHITE[2]
        hook_config.colour[3] = G.C.WHITE[3]
        ease_colour(hook_config.colour, temp_colour)
        G.CONTROLLER.text_input_hook = nil
    elseif args.key == 'LEFT' then --Move cursor position to the left
        TRANSPOSE_TEXT_INPUT(-1)
    elseif args.key == 'RIGHT' then --Move cursor position to the right
        TRANSPOSE_TEXT_INPUT(1)
    elseif hook_config.max_length > string.len(text.ref_table[text.ref_value]) and
        (string.len(args.key) == 1) and
        string.find( corpus,  args.key , 1, true) then --check to make sure the key is in the valid corpus, add it to the string
        MODIFY_TEXT_INPUT{
            letter = args.key,
            text_table = text,
            pos = text.current_position+1
        }
        TRANSPOSE_TEXT_INPUT(1)
    end
end

G.FUNCS.palette_text_input_key_jid = function(args)
    args = args or {}

    if args.key == '[' or args.key == ']' then return end
    if args.key == '0' then args.key = '0' end

    --shortcut to hook config
    local hook_config = G.CONTROLLER.text_input_hook.config.ref_table
    hook_config.orig_colour = hook_config.orig_colour or copy_table(hook_config.colour)

    args.key = args.key or '%'
    args.caps = args.caps or G.CONTROLLER.capslock or hook_config.all_caps --capitalize if caps lock or hook requires

    --Some special keys need to be mapped accordingly before passing through the corpus
    local keymap = {
        space = ' ',
        backspace = 'BACKSPACE',
        delete = 'DELETE',
        ['return'] = 'RETURN',
        right = 'RIGHT',
        left = 'LEFT'
    }
    local hook = G.CONTROLLER.text_input_hook
    local corpus = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_'
    if args.key == '-' then args.key = '_' end
    
    local text = hook_config.text

    --set key to mapped key or upper if caps is true
    args.key = keymap[args.key] or (args.caps and string.upper(args.key) or args.key)
    
    --Start by setting the cursor position to the correct location
    TRANSPOSE_TEXT_INPUT(0)

    if string.len(text.ref_table[text.ref_value]) > 0 and args.key == 'BACKSPACE' then --If not at start, remove preceding letter
        MODIFY_TEXT_INPUT{
            letter = '',
            text_table = text,
            pos = text.current_position,
            delete = true
        }
        TRANSPOSE_TEXT_INPUT(-1)
    elseif string.len(text.ref_table[text.ref_value]) > 0 and args.key == 'DELETE' then --if not at end, remove following letter
        MODIFY_TEXT_INPUT{
            letter = '',
            text_table = text,
            pos = text.current_position+1,
            delete = true
        }
        TRANSPOSE_TEXT_INPUT(0)
    elseif args.key == 'RETURN' then --Release the hook
        if hook.config.ref_table.callback then hook.config.ref_table.callback() end
        hook.parent.parent.config.colour = hook_config.colour
        local temp_colour = copy_table(hook_config.orig_colour)
        hook_config.colour[1] = G.C.WHITE[1]
        hook_config.colour[2] = G.C.WHITE[2]
        hook_config.colour[3] = G.C.WHITE[3]
        ease_colour(hook_config.colour, temp_colour)
        G.CONTROLLER.text_input_hook = nil
    elseif args.key == 'LEFT' then --Move cursor position to the left
        TRANSPOSE_TEXT_INPUT(-1)
    elseif args.key == 'RIGHT' then --Move cursor position to the right
        TRANSPOSE_TEXT_INPUT(1)
    elseif hook_config.max_length > string.len(text.ref_table[text.ref_value]) and
        (string.len(args.key) == 1) and
        string.find( corpus,  args.key , 1, true) then --check to make sure the key is in the valid corpus, add it to the string
        MODIFY_TEXT_INPUT{
            letter = args.key,
            text_table = text,
            pos = text.current_position+1
        }
        TRANSPOSE_TEXT_INPUT(1)
    end
end

G.FUNCS.palette_paste_hex = function(e)
    if not G.OVERLAY_MENU then return end
    if not G.OVERLAY_MENU:get_UIE_by_ID(e.config.ref_table.id) then return end
    G.CONTROLLER.text_input_hook = G.OVERLAY_MENU:get_UIE_by_ID(e.config.ref_table.id).children[1].children[1]
    G.CONTROLLER.text_input_id = e.config.ref_table.id
    for i = 1, 6 do
        G.FUNCS.palette_text_input_key_hex({key = 'right'})
    end
    for i = 1, 6 do
        G.FUNCS.palette_text_input_key_hex({key = 'backspace'})
    end
    local clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
    for i = 1, #clipboard do
        local c = clipboard:sub(i,i)
        G.FUNCS.palette_text_input_key_hex({key = c})
    end
    G.FUNCS.palette_text_input_key_hex({key = 'return'})
end

G.FUNCS.palette_paste_jid = function(e)
    if not G.OVERLAY_MENU then return end
    if not G.OVERLAY_MENU:get_UIE_by_ID(e.config.ref_table.id) then return end
    G.CONTROLLER.text_input_hook = G.OVERLAY_MENU:get_UIE_by_ID(e.config.ref_table.id).children[1].children[1]
    G.CONTROLLER.text_input_id = e.config.ref_table.id
    for i = 1, 20 do
        G.FUNCS.palette_text_input_key_jid({key = 'right'})
    end
    for i = 1, 20 do
        G.FUNCS.palette_text_input_key_jid({key = 'backspace'})
    end
    local clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
    for i = 1, #clipboard do
        local c = clipboard:sub(i,i)
        G.FUNCS.palette_text_input_key_jid({key = c})
    end
    G.FUNCS.palette_text_input_key_jid({key = 'return'})
end


--UIBOX FUNCTIONS
G.FUNCS.palette = function()
    palette:save_config()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_settings()
    }
end

G.FUNCS.palette_main_menu_settings = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_main_menu_settings()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_main_menu_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_startup_settings = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_startup_settings()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_startup_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_buffoon = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_buffoon()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_buffoon_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_arcana = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_arcana()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_arcana_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_celestial = function()
    palette:save_config()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_celestial()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_celestial_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_celestial_stars = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_celestial_stars()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_celestial_stars_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_celestial_meteors = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_celestial_meteors()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_celestial_meteors_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_spectral = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_spectral()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_spectral_settings_id").UIBox:recalculate()
end

G.FUNCS.palette_standard = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_palette_standard()
    }
    G.OVERLAY_MENU:get_UIE_by_ID("palette_standard_settings_id").UIBox:recalculate()
end


--MENU FUNCTIONS
function create_UIBox_palette_settings()
    local main_menu = UIBox_button({button = 'palette_main_menu_settings', label = {'Main Menu'}, minw = 3})
    local startup = UIBox_button({button = 'palette_startup_settings', label = {'Startup'}, minw = 3})

    local t = create_UIBox_generic_options ({ back_func = G.STAGE == G.STAGES.RUN and 'options' or 'exit_overlay_menu', contents = {
        {n=G.UIT.C,config={align='cm',padding=0.15},nodes={
            main_menu,
            startup
        }},
        {n=G.UIT.C,config={align='cm',padding=0.15},nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.1, r=0.2, colour = G.C.BLACK}, nodes={
                {n=G.UIT.C, config={align = "cm", maxh=2.9}, nodes={
                    {n=G.UIT.T, config={text = 'PACKS', scale = 0.45, colour = G.C.L_BLACK, vert = true, maxh=2.2}},
                }},
                {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes={
                    UIBox_button({button = 'palette_buffoon', label = {'Buffoon Pack'}, minw = 4, colour = G.C.FILTER}),
                    UIBox_button({button = 'palette_arcana', label = {'Arcana Pack'}, minw = 4, colour = G.C.SECONDARY_SET.Tarot}),
                    UIBox_button({button = 'palette_celestial', label = {'Celestial Pack'}, minw = 4, colour = G.C.SECONDARY_SET.Planet}),
                    UIBox_button({button = 'palette_spectral', label = {'Spectral Pack'}, minw = 4, colour = G.C.SECONDARY_SET.Spectral}),
                    UIBox_button({button = 'palette_standard', label = {'Standard Pack'}, minw = 4, colour = G.C.RED})
                }}
            }},
        }}
    }})
    return t
end

function create_UIBox_palette_main_menu_settings()
    local priori = palette_snapshot(palette.config)
    local splasho = {id = 'palette_main_menu_splash_one_hex'}
    local splasht = {id = 'palette_main_menu_splash_two_hex'}
    local playb = {id = 'palette_main_menu_button_play_hex'}
    local optionsb = {id = 'palette_main_menu_button_options_hex'}
    local quitb = {id = 'palette_main_menu_button_quit_hex'}
    local collectionb = {id = 'palette_main_menu_button_collection_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n = G.UIT.C, config = { align = 'cm', id = 'palette_main_menu_settings_id', r = 0.1, emboss = 0.1, colour = HEX('96999e'), padding = 0.2 }, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPLASH",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Splash 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.MAIN_MENU.SPLASH, ref_value = 'COLOURO', id = 'palette_main_menu_splash_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.MAIN_MENU.SPLASH.COLOURO) == 6 then
                                palette.config.MAIN_MENU.SPLASH.COLOURO = priori.MAIN_MENU.SPLASH.COLOURO 
                                palette:save_config()
                            else
                                priori.MAIN_MENU.SPLASH.COLOURO = palette.config.MAIN_MENU.SPLASH.COLOURO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = splasho, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n=G.UIT.R,config={align='cm'},nodes={{n=G.UIT.B,config={h=0.1,w=0.1}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Splash 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.MAIN_MENU.SPLASH, ref_value = 'COLOURT', id = 'palette_main_menu_splash_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.MAIN_MENU.SPLASH.COLOURT) == 6 then
                                palette.config.MAIN_MENU.SPLASH.COLOURT = priori.MAIN_MENU.SPLASH.COLOURT
                                palette:save_config()
                            else
                                priori.MAIN_MENU.SPLASH.COLOURT = palette.config.MAIN_MENU.SPLASH.COLOURT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = splasht, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm' }, nodes = {
                create_slider({label = "Vortex Speed", scale = 0.8, label_scale = 0.5, ref_table = palette.config.MAIN_MENU.SPLASH, ref_value = 'VORTSPEED', w = 3.5, min = 0.1, max = 10, step = 0.1, decimal_places = 1})
            }}
        }},
        {n = G.UIT.C, config = { align = 'cm', colour = HEX('6c6e73'), r = 0.1, emboss = 0.1, padding = 0.2 }, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="BUTTONS",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cl', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cl'},nodes = {
                    {n = G.UIT.T, config = {text = "PLAY: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.MAIN_MENU.BUTTONS, ref_value = 'PLAY', id = 'palette_main_menu_button_play_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.MAIN_MENU.BUTTONS.PLAY) == 6 then
                                palette.config.MAIN_MENU.BUTTONS.PLAY = priori.MAIN_MENU.BUTTONS.PLAY 
                                palette:save_config()
                            else
                                priori.MAIN_MENU.BUTTONS.PLAY = palette.config.MAIN_MENU.BUTTONS.PLAY
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = playb, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cl', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cl'},nodes = {
                    {n = G.UIT.T, config = {text = "OPTIONS: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cl'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.MAIN_MENU.BUTTONS, ref_value = 'OPTIONS', id = 'palette_main_menu_button_options_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.MAIN_MENU.BUTTONS.OPTIONS) == 6 then
                                palette.config.MAIN_MENU.BUTTONS.OPTIONS = priori.MAIN_MENU.BUTTONS.OPTIONS
                                palette:save_config()
                            else
                                priori.MAIN_MENU.BUTTONS.OPTIONS = palette.config.MAIN_MENU.BUTTONS.OPTIONS
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = optionsb, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cl', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cl'},nodes = {
                    {n = G.UIT.T, config = {text = "QUIT: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cl'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.MAIN_MENU.BUTTONS, ref_value = 'QUIT', id = 'palette_main_menu_button_quit_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.MAIN_MENU.BUTTONS.QUIT) == 6 then
                                palette.config.MAIN_MENU.BUTTONS.QUIT = priori.MAIN_MENU.BUTTONS.QUIT
                                palette:save_config()
                            else
                                priori.MAIN_MENU.BUTTONS.QUIT = palette.config.MAIN_MENU.BUTTONS.QUIT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = quitb, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cl', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cl'},nodes = {
                    {n = G.UIT.T, config = {text = "COLLECTION: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cl'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.MAIN_MENU.BUTTONS, ref_value = 'COLLECTION', id = 'palette_main_menu_button_collection_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.MAIN_MENU.BUTTONS.COLLECTION) == 6 then
                                palette.config.MAIN_MENU.BUTTONS.COLLECTION = priori.MAIN_MENU.BUTTONS.COLLECTION
                                palette:save_config()
                            else
                                priori.MAIN_MENU.BUTTONS.COLLECTION = palette.config.MAIN_MENU.BUTTONS.COLLECTION
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = collectionb, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
        }}
    }})
    return t
end

G.FUNCS.palette_sudopt = function(args)
    args = args.to_key
    palette.config.STARTUP.DECK_POS = palette.config.UTILITY.SUDP[args]
    palette.config.UTILITY.SUDCO = args
    palette:save_config()
end

function create_UIBox_palette_startup_settings()
    local priori = palette_snapshot(palette.config)
    local splasho = {id='palette_startup_splash_one_hex'}
    local splasht = {id='palette_startup_splash_two_hex'}
    local cardid = {id='palette_startup_card_jid'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n = G.UIT.C, config = { align = 'cm', id = 'palette_startup_settings_id', r = 0.1, emboss = 0.1, colour = HEX('96999e'), padding = 0.2 }, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPLASH",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Splash 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.STARTUP, ref_value = 'COLOURO', id = 'palette_startup_splash_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.STARTUP.COLOURO) == 6 then
                                palette.config.STARTUP.COLOURO = priori.STARTUP.COLOURO
                                palette:save_config()
                            else
                                priori.STARTUP.COLOURO = palette.config.STARTUP.COLOURO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = splasho, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Splash 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.STARTUP, ref_value = 'COLOURT', id = 'palette_startup_splash_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.STARTUP.COLOURT) == 6 then
                                palette.config.STARTUP.COLOURT = priori.STARTUP.COLOURT
                                palette:save_config()
                            else
                                priori.STARTUP.COLOURT = palette.config.STARTUP.COLOURT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = splasht, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Card: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 20, prompt_text = 'Enter ID', ref_table = priori.STARTUP, ref_value = 'CARD', id = 'palette_startup_card_jid', extended_corpus = true,
                        callback = function()
                            if G.P_CENTERS[priori.STARTUP.CARD] then
                                palette.config.STARTUP.CARD = priori.STARTUP.CARD
                                palette:save_config()
                            else
                                priori.STARTUP.CARD = palette.config.STARTUP.CARD
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = cardid, button = 'palette_paste_jid', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                create_option_cycle({scale = 1, text_scale = 0.5, options = palette.config.UTILITY.SUDO, w = 2, current_option = palette.config.UTILITY.SUDCO, opt_callback = 'palette_sudopt'})
            }}
        }}
    }})
    return t
end

function create_UIBox_palette_buffoon()
    local priori = palette_snapshot(palette.config)
    local buffoono = {id='palette_buffoon_back_one_hex'}
    local buffoont = {id='palette_buffoon_back_two_hex'}
    local buffoonh = {id='palette_buffoon_hud_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n=G.UIT.C, config={align='cm',id='palette_buffoon_settings_id',r = 0.1,emboss = 0.1,colour = HEX('96999e'),padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="BACKGROUND",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.BUFFOON, ref_value = 'COLOURO', id = 'palette_buffoon_back_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.BUFFOON.COLOURO) == 6 then
                                palette.config.PACKS.BUFFOON.COLOURO = priori.PACKS.BUFFOON.COLOURO
                                palette:save_config()
                            else
                                priori.PACKS.BUFFOON.COLOURO = palette.config.PACKS.BUFFOON.COLOURO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = buffoono, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.BUFFOON, ref_value = 'COLOURT', id = 'palette_buffoon_back_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.BUFFOON.COLOURT) == 6 then
                                palette.config.PACKS.BUFFOON.COLOURT = priori.PACKS.BUFFOON.COLOURT
                                palette:save_config()
                            else
                                priori.PACKS.BUFFOON.COLOURT = palette.config.PACKS.BUFFOON.COLOURT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = buffoont, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="HUD",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "HUD Colour: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.BUFFOON, ref_value = 'HUDCOLOUR', id = 'palette_buffoon_hud_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.BUFFOON.HUDCOLOUR) == 6 then
                                palette.config.PACKS.BUFFOON.HUDCOLOUR = priori.PACKS.BUFFOON.HUDCOLOUR
                                palette:save_config()
                            else
                                priori.PACKS.BUFFOON.HUDCOLOUR = palette.config.PACKS.BUFFOON.HUDCOLOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = buffoonh, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            create_slider({label = "Contrast", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.BUFFOON, ref_value = 'CONTRAST', w = 3, min = 0.1, max = 8, step = 0.1, decimal_places = 1, colour = G.C.BLUE})
        }}
    }})
    return t
end


function create_UIBox_palette_arcana()
    local priori = palette_snapshot(palette.config)
    local arcanao = {id='palette_arcana_back_one_hex'}
    local arcanat = {id='palette_arcana_back_two_hex'}
    local arcanah = {id='palette_arcana_sparkles_one_hex'}
    local arcanaso = {id='palette_arcana_sparkles_one_hex'}
    local arcanast = {id='palette_arcana_sparkles_two_hex'}
    local arcanash = {id='palette_arcana_sparkles_three_hex'}
    local arcanasf = {id='palette_arcana_sparkles_four_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n=G.UIT.C, config={align='tm',id='palette_arcana_settings_id',r = 0.1,emboss = 0.1,colour = HEX('96999e'),padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="BACKGROUND",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA, ref_value = 'COLOURO', id = 'palette_arcana_back_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.COLOURO) == 6 then
                                palette.config.PACKS.ARCANA.COLOURO = priori.PACKS.ARCANA.COLOURO
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.COLOURO = palette.config.PACKS.ARCANA.COLOURO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanao, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA, ref_value = 'COLOURT', id = 'palette_arcana_back_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.COLOURT) == 6 then
                                palette.config.PACKS.ARCANA.COLOURT = priori.PACKS.ARCANA.COLOURT
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.COLOURT = palette.config.PACKS.ARCANA.COLOURT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanat, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="HUD",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "HUD Colour: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA, ref_value = 'HUDCOLOUR', id = 'palette_arcana_hud_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.HUDCOLOUR) == 6 then
                                palette.config.PACKS.ARCANA.HUDCOLOUR = priori.PACKS.ARCANA.HUDCOLOUR
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.HUDCOLOUR = palette.config.PACKS.ARCANA.HUDCOLOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanah, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.PURPLE,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'tm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPARKLES",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA.SPARKLES.COLOURS, ref_value = 'ONE', id = 'palette_arcana_sparkles_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.SPARKLES.COLOURS.ONE) == 6 then
                                palette.config.PACKS.ARCANA.SPARKLES.COLOURS.ONE = priori.PACKS.ARCANA.SPARKLES.COLOURS.ONE
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.SPARKLES.COLOURS.ONE = palette.config.PACKS.ARCANA.SPARKLES.COLOURS.ONE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanaso, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA.SPARKLES.COLOURS, ref_value = 'TWO', id = 'palette_arcana_sparkles_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.SPARKLES.COLOURS.TWO) == 6 then
                                palette.config.PACKS.ARCANA.SPARKLES.COLOURS.TWO = priori.PACKS.ARCANA.SPARKLES.COLOURS.TWO
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.SPARKLES.COLOURS.TWO = palette.config.PACKS.ARCANA.SPARKLES.COLOURS.TWO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanast, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 3: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA.SPARKLES.COLOURS, ref_value = 'THREE', id = 'palette_arcana_sparkles_three_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.SPARKLES.COLOURS.THREE) == 6 then
                                palette.config.PACKS.ARCANA.SPARKLES.COLOURS.THREE = priori.PACKS.ARCANA.SPARKLES.COLOURS.THREE
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.SPARKLES.COLOURS.THREE = palette.config.PACKS.ARCANA.SPARKLES.COLOURS.THREE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanash, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 4: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.ARCANA.SPARKLES.COLOURS, ref_value = 'FOUR', id = 'palette_arcana_sparkles_four_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.ARCANA.SPARKLES.COLOURS.FOUR) == 6 then
                                palette.config.PACKS.ARCANA.SPARKLES.COLOURS.FOUR = priori.PACKS.ARCANA.SPARKLES.COLOURS.FOUR
                                palette:save_config()
                            else
                                priori.PACKS.ARCANA.SPARKLES.COLOURS.FOUR = palette.config.PACKS.ARCANA.SPARKLES.COLOURS.FOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = arcanasf, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.GOLD,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPARKLES",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            create_slider({label = "Scale", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.ARCANA.SPARKLES, ref_value = 'SCALE', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.PURPLE}),
            create_slider({label = "Lifespan", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.ARCANA.SPARKLES, ref_value = 'LIFESPAN', w = 3, min = 0.1, max = 20, step = 1, decimal_places = 0, colour = G.C.PURPLE}),
            create_slider({label = "Speed", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.ARCANA.SPARKLES, ref_value = 'SPEED', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.PURPLE})
        }}
    }})
    return t
end

function create_UIBox_palette_celestial()
    local priori = palette_snapshot(palette.config)
    local celestialo = {id='palette_celestial_back_hex'}
    local celestialh = {id='palette_celestial_hud_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n=G.UIT.C, config={align='cm',id='palette_celestial_settings_id',r = 0.1,emboss = 0.1,colour = HEX('96999e'),padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="BACKGROUND",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.CELESTIAL, ref_value = 'COLOUR', id = 'palette_celestial_back_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.CELESTIAL.COLOUR) == 6 then
                                palette.config.PACKS.CELESTIAL.COLOUR = priori.PACKS.CELESTIAL.COLOUR
                                palette:save_config()
                            else
                                priori.PACKS.CELESTIAL.COLOUR = palette.config.PACKS.CELESTIAL.COLOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = celestialo, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="HUD",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "HUD Colour: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.CELESTIAL, ref_value = 'HUDCOLOUR', id = 'palette_celestial_hud_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.CELESTIAL.HUDCOLOUR) == 6 then
                                palette.config.PACKS.CELESTIAL.HUDCOLOUR = priori.PACKS.CELESTIAL.HUDCOLOUR
                                palette:save_config()
                            else
                                priori.PACKS.CELESTIAL.HUDCOLOUR = palette.config.PACKS.CELESTIAL.HUDCOLOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = celestialh, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            create_slider({label = "Contrast", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL, ref_value = 'CONTRAST', w = 3, min = 0.1, max = 8, step = 0.1, decimal_places = 1, colour = G.C.GOLD}),
        }},
        {n=G.UIT.C, config={align='cm',r = 0.1,emboss = 0.1,colour = HEX('13afce'),padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="OTHERS",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            UIBox_button({button = 'palette_celestial_stars', label = {'Stars'}, minw = 3, colour = HEX('A7D6E0')}),
            UIBox_button({button = 'palette_celestial_meteors', label = {'Meteors'}, minw = 3, colour = HEX('FDDCA0')})
        }}
    }})
    return t
end

function create_UIBox_palette_celestial_stars()
    local priori = palette_snapshot(palette.config)
    local celestialo = {id='palette_celestial_stars_one_hex'}
    local celestialt = {id='palette_celestial_stars_two_hex'}
    local celestialh = {id='palette_celestial_stars_three_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette_celestial', contents = {
        {n=G.UIT.C, config={align='tm',id='palette_celestial_stars_settings_id',r = 0.1,emboss = 0.1,colour = G.C.SECONDARY_SET.Planet,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="STARS",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.CELESTIAL.STARS.COLOURS, ref_value = 'ONE', id = 'palette_celestial_stars_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.CELESTIAL.STARS.COLOURS.ONE) == 6 then
                                palette.config.PACKS.CELESTIAL.STARS.COLOURS.ONE = priori.PACKS.CELESTIAL.STARS.COLOURS.ONE
                                palette:save_config()
                            else
                                priori.PACKS.CELESTIAL.STARS.COLOURS.ONE = palette.config.PACKS.CELESTIAL.STARS.COLOURS.ONE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = celestialo, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.CELESTIAL.STARS.COLOURS, ref_value = 'TWO', id = 'palette_celestial_stars_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.CELESTIAL.STARS.COLOURS.TWO) == 6 then
                                palette.config.PACKS.CELESTIAL.STARS.COLOURS.TWO = priori.PACKS.CELESTIAL.STARS.COLOURS.TWO
                                palette:save_config()
                            else
                                priori.PACKS.CELESTIAL.STARS.COLOURS.TWO = palette.config.PACKS.CELESTIAL.STARS.COLOURS.TWO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = celestialt, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 3: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.CELESTIAL.STARS.COLOURS, ref_value = 'THREE', id = 'palette_celestial_stars_three_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.CELESTIAL.STARS.THREE) == 6 then
                                palette.config.PACKS.CELESTIAL.STARS.COLOURS.THREE = priori.PACKS.CELESTIAL.STARS.COLOURS.THREE
                                palette:save_config()
                            else
                                priori.PACKS.CELESTIAL.STARS.COLOURS.THREE = palette.config.PACKS.CELESTIAL.STARS.COLOURS.THREE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = celestialh, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.GOLD,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="STARS",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            create_slider({label = "Scale", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL.STARS, ref_value = 'SCALE', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.SECONDARY_SET.Planet}),
            create_slider({label = "Lifespan", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL.STARS, ref_value = 'LIFESPAN', w = 3, min = 0.1, max = 20, step = 1, decimal_places = 0, colour = G.C.SECONDARY_SET.Planet}),
            create_slider({label = "Speed", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL.STARS, ref_value = 'SPEED', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.SECONDARY_SET.Planet})
        }}
    }})
    return t
end

function create_UIBox_palette_celestial_meteors()
    local priori = palette_snapshot(palette.config)
    local celestialo = {id='palette_celestial_meteors_one_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette_celestial', contents = {
        {n=G.UIT.C, config={align='tm',id='palette_celestial_meteors_settings_id',r = 0.1,emboss = 0.1,colour = G.C.SECONDARY_SET.Planet,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="METEORS",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.CELESTIAL.METEORS.COLOURS, ref_value = 'ONE', id = 'palette_celestial_meteors_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.CELESTIAL.METEORS.COLOURS.ONE) == 6 then
                                palette.config.PACKS.CELESTIAL.METEORS.COLOURS.ONE = priori.PACKS.CELESTIAL.METEORS.COLOURS.ONE
                                palette:save_config()
                            else
                                priori.PACKS.CELESTIAL.METEORS.COLOURS.ONE = palette.config.PACKS.CELESTIAL.METEORS.COLOURS.ONE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = celestialo, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }}
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.GOLD,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="METEORS",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            create_slider({label = "Scale", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL.METEORS, ref_value = 'SCALE', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.SECONDARY_SET.Planet}),
            create_slider({label = "Lifespan", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL.METEORS, ref_value = 'LIFESPAN', w = 3, min = 0.1, max = 20, step = 1, decimal_places = 0, colour = G.C.SECONDARY_SET.Planet}),
            create_slider({label = "Speed", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.CELESTIAL.METEORS, ref_value = 'SPEED', w = 3, min = 0.1, max = 8, step = 0.1, decimal_places = 1, colour = G.C.SECONDARY_SET.Planet})
        }}
    }})
    return t
end


function create_UIBox_palette_spectral()
    local priori = palette_snapshot(palette.config)
    local spectralo = {id='palette_spectral_back_one_hex'}
    local spectralt = {id='palette_spectral_back_two_hex'}
    local spectralh = {id='palette_spectral_sparkles_one_hex'}
    local spectralso = {id='palette_spectral_sparkles_one_hex'}
    local spectralst = {id='palette_spectral_sparkles_two_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n=G.UIT.C, config={align='tm',id='palette_spectral_settings_id',r = 0.1,emboss = 0.1,colour = HEX('96999e'),padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="BACKGROUND",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.SPECTRAL, ref_value = 'COLOURO', id = 'palette_spectral_back_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.SPECTRAL.COLOURO) == 6 then
                                palette.config.PACKS.SPECTRAL.COLOURO = priori.PACKS.SPECTRAL.COLOURO
                                palette:save_config()
                            else
                                priori.PACKS.SPECTRAL.COLOURO = palette.config.PACKS.SPECTRAL.COLOURO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = spectralo, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.SPECTRAL, ref_value = 'COLOURT', id = 'palette_spectral_back_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.SPECTRAL.COLOURT) == 6 then
                                palette.config.PACKS.SPECTRAL.COLOURT = priori.PACKS.SPECTRAL.COLOURT
                                palette:save_config()
                            else
                                priori.PACKS.SPECTRAL.COLOURT = palette.config.PACKS.SPECTRAL.COLOURT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = spectralt, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "HUD Colour: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.SPECTRAL, ref_value = 'HUDCOLOUR', id = 'palette_spectral_hud_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.SPECTRAL.HUDCOLOUR) == 6 then
                                palette.config.PACKS.SPECTRAL.HUDCOLOUR = priori.PACKS.SPECTRAL.HUDCOLOUR
                                palette:save_config()
                            else
                                priori.PACKS.SPECTRAL.HUDCOLOUR = palette.config.PACKS.SPECTRAL.HUDCOLOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = spectralh, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.SECONDARY_SET.Spectral,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'tm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPARKLES",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.SPECTRAL.SPARKLES.COLOURS, ref_value = 'ONE', id = 'palette_spectral_sparkles_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.SPECTRAL.SPARKLES.COLOURS.ONE) == 6 then
                                palette.config.PACKS.SPECTRAL.SPARKLES.COLOURS.ONE = priori.PACKS.SPECTRAL.SPARKLES.COLOURS.ONE
                                palette:save_config()
                            else
                                priori.PACKS.SPECTRAL.SPARKLES.COLOURS.ONE = palette.config.PACKS.SPECTRAL.SPARKLES.COLOURS.ONE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = spectralso, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.SPECTRAL.SPARKLES.COLOURS, ref_value = 'TWO', id = 'palette_spectral_sparkles_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.SPECTRAL.SPARKLES.COLOURS.TWO) == 6 then
                                palette.config.PACKS.SPECTRAL.SPARKLES.COLOURS.TWO = priori.PACKS.SPECTRAL.SPARKLES.COLOURS.TWO
                                palette:save_config()
                            else
                                priori.PACKS.SPECTRAL.SPARKLES.COLOURS.TWO = palette.config.PACKS.SPECTRAL.SPARKLES.COLOURS.TWO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = spectralst, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }}
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.GOLD,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPARKLES",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            create_slider({label = "Scale", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.SPECTRAL.SPARKLES, ref_value = 'SCALE', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.SECONDARY_SET.Spectral}),
            create_slider({label = "Lifespan", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.SPECTRAL.SPARKLES, ref_value = 'LIFESPAN', w = 3, min = 0.1, max = 20, step = 1, decimal_places = 0, colour = G.C.SECONDARY_SET.Spectral}),
            create_slider({label = "Speed", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.SPECTRAL.SPARKLES, ref_value = 'SPEED', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.SECONDARY_SET.Spectral})
        }}
    }})
    return t
end

function create_UIBox_palette_standard()
    local priori = palette_snapshot(palette.config)
    local standardo = {id='palette_standard_back_one_hex'}
    local standardt = {id='palette_standard_back_two_hex'}
    local standardh = {id='palette_standard_sparkles_one_hex'}
    local standardso = {id='palette_standard_sparkles_one_hex'}
    local standardst = {id='palette_standard_sparkles_two_hex'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n=G.UIT.C, config={align='tm',id='palette_standard_settings_id',r = 0.1,emboss = 0.1,colour = HEX('96999e'),padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="BACKGROUND",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.STANDARD, ref_value = 'COLOURO', id = 'palette_standard_back_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.STANDARD.COLOURO) == 6 then
                                palette.config.PACKS.STANDARD.COLOURO = priori.PACKS.STANDARD.COLOURO
                                palette:save_config()
                            else
                                priori.PACKS.STANDARD.COLOURO = palette.config.PACKS.STANDARD.COLOURO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = standardo, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Background 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.STANDARD, ref_value = 'COLOURT', id = 'palette_standard_back_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.STANDARD.COLOURT) == 6 then
                                palette.config.PACKS.STANDARD.COLOURT = priori.PACKS.STANDARD.COLOURT
                                palette:save_config()
                            else
                                priori.PACKS.STANDARD.COLOURT = palette.config.PACKS.STANDARD.COLOURT
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = standardt, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "HUD Colour: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.STANDARD, ref_value = 'HUDCOLOUR', id = 'palette_standard_hud_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.STANDARD.HUDCOLOUR) == 6 then
                                palette.config.PACKS.STANDARD.HUDCOLOUR = priori.PACKS.STANDARD.HUDCOLOUR
                                palette:save_config()
                            else
                                priori.PACKS.STANDARD.HUDCOLOUR = palette.config.PACKS.STANDARD.HUDCOLOUR
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = standardh, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.RED,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'tm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPARKLES",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 1: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.STANDARD.SPARKLES.COLOURS, ref_value = 'ONE', id = 'palette_standard_sparkles_one_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.STANDARD.SPARKLES.COLOURS.ONE) == 6 then
                                palette.config.PACKS.STANDARD.SPARKLES.COLOURS.ONE = priori.PACKS.STANDARD.SPARKLES.COLOURS.ONE
                                palette:save_config()
                            else
                                priori.PACKS.STANDARD.SPARKLES.COLOURS.ONE = palette.config.PACKS.STANDARD.SPARKLES.COLOURS.ONE
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = standardso, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }},
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Colour 2: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = 'cr'}},
                    create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = priori.PACKS.STANDARD.SPARKLES.COLOURS, ref_value = 'TWO', id = 'palette_standard_sparkles_two_hex', extended_corpus = true,
                        callback = function()
                            if string.len(priori.PACKS.STANDARD.SPARKLES.COLOURS.TWO) == 6 then
                                palette.config.PACKS.STANDARD.SPARKLES.COLOURS.TWO = priori.PACKS.STANDARD.SPARKLES.COLOURS.TWO
                                palette:save_config()
                            else
                                priori.PACKS.STANDARD.SPARKLES.COLOURS.TWO = palette.config.PACKS.STANDARD.SPARKLES.COLOURS.TWO
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = standardst, button = 'palette_paste_hex', minw = 1, minh = 0.6}}}
            }}
        }},
        {n=G.UIT.C, config={align='tm',r = 0.1,emboss = 0.1,colour = G.C.BLACK,padding = 0.2}, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {{n=G.UIT.T,config={text="SPARKLES",colour=G.C.L_BLACK,scale=0.5,align='cm'}}}},
            create_slider({label = "Scale", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.STANDARD.SPARKLES, ref_value = 'SCALE', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.RED}),
            create_slider({label = "Lifespan", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.STANDARD.SPARKLES, ref_value = 'LIFESPAN', w = 3, min = 0.1, max = 20, step = 1, decimal_places = 0, colour = G.C.RED}),
            create_slider({label = "Speed", scale = 0.5, label_scale = 0.5, ref_table = palette.config.PACKS.STANDARD.SPARKLES, ref_value = 'SPEED', w = 3, min = 0.1, max = 2, step = 0.1, decimal_places = 1, colour = G.C.RED})
            
        }}
    }})
    return t
end