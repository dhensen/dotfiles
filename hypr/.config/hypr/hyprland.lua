-- Hyprland config. See https://wiki.hypr.land/Configuring/Start/
-- Lua API stubs: /usr/share/hypr/stubs/hl.meta.lua

------------------
---- MONITORS ----
------------------

-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-4",  mode = "preferred", position = "1920x0", scale = 1 })
hl.monitor({ output = "DP-6",  mode = "preferred", position = "4480x0", scale = 1 })


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaybg --image ~/Pictures/Wallpapers/wallhaven-2ygkp6.jpg --output '*'")
end)


------------------
---- SETTINGS ----
------------------

hl.config({
    input = {
        kb_file    = "",
        kb_layout  = "",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        repeat_delay = 180,
        repeat_rate  = 35,

        follow_mouse = 1,

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = false,
        },

        sensitivity = -0.1, -- -1.0 - 1.0, 0 means no modification.
    },

    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 3,

        col = {
            active_border   = "rgba(ffffff33)",
            inactive_border = "rgba(33333366)",
        },
    },

    decoration = {
        rounding = 5,

        blur = {
            enabled           = true,
            size              = 3, -- minimum 1
            passes            = 1, -- minimum 1
            new_optimizations = true,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + W",      hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE",  hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- mainMod + [0-9] switches workspace, mainMod + SHIFT + [0-9] moves the window there
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + TAB", hl.dsp.window.move({ workspace = "previous" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
