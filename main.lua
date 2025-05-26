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
    local corpus = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'..(hook.config.ref_table.extended_corpus and " 0!$&()<>?:{}+-=,.[]_" or '')
    
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

function create_UIBox_palette_main_menu_settings()
    local priori = palette_snapshot(palette.config)
    local t = create_UIBox_generic_options ({ back_func = 'palette', contents = {
        {n = G.UIT.C, config = { align = 'cm', id = 'palette_main_menu_settings_id' }, nodes = {
            {n = G.UIT.R, config = { align = 'cm' }, nodes = {
                {
                    n = G.UIT.T, config = {
                        text = "Splash 1: ",
                        colour = G.C.UI.TEXT_Light,
                        scale = 0.5,
                        align = 'cr'
                    }
                },
                create_text_input({
                    w = 3, max_length = 6, prompt_text = 'Enter Hex Code', ref_table = palette.config, ref_value = 'test', id = 'palette_main_menu_input', extended_corpus = true,
                    callback = function()
                        if string.len(palette.config.test) == 6 and palette_validate(palette.config.test) then
                            priori.test = palette.config.test
                            palette:save_config()
                        else
                            palette.config.test = priori.test
                        end
                    end
                })
            }}
            
        }}
    }})
    return t
end