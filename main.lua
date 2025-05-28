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

function palette_paste(val)
    if not G.OVERLAY_MENU then
        sendInfoMessage("NO OVERLAY")
        return
    end
    if not G.OVERLAY_MENU:get_UIE_by_ID(val) then
        sendInfoMessage("NO UIE")
        return
    else
        sendInfoMessage("UIE Exists "..tostring(G.OVERLAY_MENU:get_UIE_by_ID(val)))
    end
    G.CONTROLLER.text_input_hook = G.OVERLAY_MENU:get_UIE_by_ID(val).children[1].children[1]
    sendInfoMessage("input hook: "..tostring(G.CONTROLLER.text_input_hook))
    for i = 1, 6 do
        G.FUNCS.palette_text_input_key({key = 'right'})
    end
    for i = 1, 6 do
        G.FUNCS.palette_text_input_key({key = 'backspace'})
    end
    local clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
    for i = 1, #clipboard do
        local c = clipboard:sub(i,i)
        G.FUNCS.palette_text_input_key({key = c})
    end
    G.FUNCS.palette_text_input_key({key = 'return'})
end

--allow 0 to be input to text fields
G.FUNCS.palette_text_input_key = function(args)
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
    args.key = keymap[args.key] or string.upper(args.key)
    
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




--UIBOX FUNCTIONS
G.FUNCS.palette = function()
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


--MENU FUNCTIONS
function create_UIBox_palette_settings()
    local t = create_UIBox_generic_options ({ back_func = G.STAGE == G.STAGES.RUN and 'options' or 'exit_overlay_menu', contents = {
        {n = G.UIT.C, config = { align = 'cm' }, nodes = {
            UIBox_button({button = 'palette_main_menu_settings', label = {'Main Menu'}, minw = 3, scale = 1.5})
        }}
    }})
    return t
end

G.FUNCS.palette_testpoint = function(e)
    sendInfoMessage(e.config.ref_table.id)
    palette_paste(e.config.ref_table.id)
end

function palette_create_text_input(args)
    args = args or {}
    args.colour = copy_table(args.colour) or copy_table(G.C.BLUE)
    args.hooked_colour = copy_table(args.hooked_colour) or darken(copy_table(G.C.BLUE), 0.3)
    args.w = args.w or 2.5
    args.h = args.h or 0.7
    args.text_scale = args.text_scale or 0.4
    args.max_length = args.max_length or 16
    args.all_caps = args.all_caps or false
    args.prompt_text = args.prompt_text or localize('k_enter_text')
    args.current_prompt_text = ''
    args.id = args.id or "text_input"

    local text = {ref_table = args.ref_table, ref_value = args.ref_value, letters = {}, current_position = string.len(args.ref_table[args.ref_value])}
    local ui_letters = {}
    for i = 1, args.max_length do
        text.letters[i] = (args.ref_table[args.ref_value] and (string.sub(args.ref_table[args.ref_value], i, i) or '')) or ''
        ui_letters[i] = {n=G.UIT.T, config={ref_table = text.letters, ref_value = i, scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, id = args.id..'_letter_'..i}}
    end
    args.text = text

    local position_text_colour = lighten(copy_table(G.C.BLUE), 0.4)

    ui_letters[#ui_letters+1] = {n=G.UIT.T, config={ref_table = args, ref_value = 'current_prompt_text', scale = args.text_scale, colour = lighten(copy_table(args.colour), 0.4), id = args.id..'_prompt'}}
    ui_letters[#ui_letters+1] = {n=G.UIT.B, config={r = 0.03,w=0.1, h=0.4, colour = position_text_colour, id = args.id..'_position', func = 'flash'}}

    local t = 
        {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR}, nodes = {
            {n=G.UIT.C, config={id = args.id, align = "cm", padding = 0.05, r = 0.1, hover = true, colour = args.colour,minw = args.w, min_h = args.h, button = 'select_text_input', shadow = true}, nodes={
                {n=G.UIT.R, config={ref_table = args, padding = 0.05, align = "cm", r = 0.1, colour = G.C.CLEAR}, nodes={
                    {n=G.UIT.R, config={ref_table = args, align = "cm", r = 0.1, colour = G.C.CLEAR, func = 'text_input'}, nodes=
                        ui_letters
                    }
                }}
            }}
        }}
  return t
end

function create_UIBox_palette_main_menu_settings()
    local priori = palette_snapshot(palette.config)
    local splasho = {id = 'palette_main_menu_input'}
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n = G.UIT.C, config = { align = 'cm', id = 'palette_main_menu_settings_id' }, nodes = {
            {n = G.UIT.R, config = { align = 'cm', minh = 0.5 }, nodes = {
                {n = G.UIT.C,config = {align = 'cm'},nodes = {
                    {n = G.UIT.T, config = {text = "Splash 1: ", colour = G.C.UI.TEXT_Light, scale = 0.5, align = 'cr'}},
                    palette_create_text_input({w = 2, h = 0.5, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = palette.config, ref_value = 'test', id = 'palette_main_menu_input', extended_corpus = true,
                        callback = function()
                            if string.len(palette.config.test) == 6 and palette_validate(palette.config.test) then
                                priori.test = palette.config.test
                                palette:save_config()
                            else
                                palette.config.test = priori.test
                            end
                        end
                    })
                }},
                {n=G.UIT.B, config = {h=0.1,w=0.1}},
                {n = G.UIT.C,config = { align = 'cl' },nodes = {
                        UIBox_button {label = {"Paste"}, colour = G.C.RED,ref_table = splasho, button = 'palette_testpoint', minw = 1, minh = 0.6}
                }}
            }}
            
        }}
    }})
    return t
end