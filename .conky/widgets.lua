--[[
Ring Meters by londonali1010 (2009)
 
This script draws percentage meters as rings. It is fully customisable; all options are described in the script.
 
To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
    lua_load ~/scripts/rings-v1.2.1.lua
    lua_draw_hook_pre ring_stats
	
Edited by SuNjACk
 
]]

-- Background settings
corner_r = 20
main_bg_colour	= 0x000000
main_bg_alpha 	= 0.1
main_border_thick 	= 0
main_border_color 	= 0x286f8a
main_border_alpha 	= .1
-- Bar ccolor settings
bar_bg_color = 0x121212
bar_bg_alpha = 1
bar_fg_color = 0x286f8a
bar_fg_alpha = 1

green_bg_color = 0x122015
green_bg_alpha = .8

green_fg_color = 0x284a28
green_fg_alpha = 1

-- Bars Settings
-- Ring color settings
ring_background_color = green_bg_color 
ring_background_alpha = green_bg_alpha
ring_foreground_color = green_fg_color
ring_foreground_alpha = green_fg_alpha
-- Rings settings
ring_settings_table = {
   {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=105,
        thickness=8,
        start_angle=-155,
        end_angle=155
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=116,
        thickness=8,
        start_angle=-150,
        end_angle=150
    },
    {
        name='cpu',
        arg='cpu3',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=127,
        thickness=8,
        start_angle=-145,
        end_angle=145
    },
    {
        name='cpu',
        arg='cpu4',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=138,
        thickness=8,
        start_angle=-140,
        end_angle=140
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=160,
        thickness=12,
        start_angle=-110,
		end_angle=110
    },
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        g_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=180,
        thickness=15,
        start_angle=-150,
        end_angle=-80
    },
    {
        name='fs_used_perc',
        arg='/media/Data',
        max=100,
        bg_colour=ring_background_color,
        bg_alpha=ring_background_alpha,
        fg_colour=ring_foreground_color,
        fg_alpha=ring_foreground_alpha,
        g_alpha=ring_foreground_alpha,
        x=260, y=170,
        radius=180,
        thickness=15,
        start_angle=80,
        end_angle=150
    },
}

require 'cairo'

-------------------------------------------------
---// Convert 0xRRGGBB into readble values //----
-------------------------------------------------
local function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function conky_gradient_color(max, red, green, blue, name, arg)
	--local val
    --local val=string.format('${%s %s}',name,arg)
    local str = ''
	local val = 0
	str = conky_parse(string.format("${%s %s}",name,arg))
	val = tonumber(str)
--	if (val > max) then val = max end
--	if (val < min) then val = min end
	
	local v = val
	local d = max/2
	local r,g,b = 0,0,0
	r = ((255 * val) / d) * red
	g = ((255 * val) / d) * green
	b = ((255 * val) / d) * blue

	color = string.format("#%02x%02x%02x", r,g,b)
	--color = "#0000ff"
	--val= "100"]]
	return string.format("str: %s - val: %s - col: %s",str,val,color)
--return string.format("${color %s}%s${color}",color,val)
end

-------------------------------------------------
---------/// Drawing Rings Function \\\----------
-------------------------------------------------
--               | Parameters |                --
-- cr: the cairo raw ( by default given by conku_widget_stats() )
-- t: a value from 0 to 1, for the foreground
-- pt: the table containg values
local function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height
    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']
 
    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)
 
    -- Draw background ring
 
    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)
 
    -- Draw indicator ring
 
    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)        
end

-------------------------------------------------
---------/// Drawing Bars Function \\\-----------
-------------------------------------------------
--               | Parameters: |               --
-- cr: the cairo raw ( by default given by conku_widget_stats() )
-- t: a value from 0 to 1, for the foreground
-- pt: the table containg values
local function draw_bar(cr,t,pt)
	  -- Window height and width
	local h,w=conky_window.height,conky_window.width
	  -- The width,thickness and padding of the background bar
	local wth,thc,pdg=pt['width'],pt['thickness'],pt['padding']
	  -- The width of the foreground bar
	local tf=(wth-2*pdg)*t
	  -- The colors [bg|fg]_[color|alpha]
	local bgc,bga,fgc,fga=pt['bg_color'],pt['bg_alpha'],pt['fg_color'],pt['fg_alpha']
	  -- Start point coordinate
	local bg_xi,bg_yi=pt['x'],pt['y']
	  -- Identify orientation and from it define the remaing points coordinate
	if pt['orientation'] == 'rightleft' then -- from right to left
		bg_xf, bg_yf = bg_xi+wth, bg_yi
		fg_xi, fg_yi = bg_xf-pdg, bg_yf
		fg_xf, fg_yf = fg_xi-tf, fg_yi
	elseif pt['orientation'] == 'updown' then -- from top to bottom
		bg_xf, bg_yf = bg_xi, bg_yi+wth
		fg_xi, fg_yi = bg_xi, bg_yi+pdg
		fg_xf, fg_yf = fg_xi, fg_yi+tf
	elseif pt['orientation'] == 'downup' then -- from bottom to top
		bg_xf, bg_yf = bg_xi, bg_yi
		bg_yi = bg_yf+wth
		fg_xi, fg_yi = bg_xi, bg_yi-pdg
		fg_xf, fg_yf = fg_xi, fg_yi-tf
	else 								-- use the default: from left to right
		bg_xf, bg_yf = bg_xi+wth, bg_yi
		fg_xi, fg_yi = bg_xi+pdg, bg_yi
		fg_xf, fg_yf = fg_xi+tf, fg_yi
	end
	  -- Draw background
	cairo_move_to(cr,bg_xi,bg_yi)
	cairo_line_to(cr,bg_xf,bg_yf)
	cairo_set_source_rgba(cr, rgb_to_r_g_b(bgc, bga))
	cairo_set_line_width(cr,thc)
	cairo_stroke(cr)
	  -- Draw foreground
	cairo_move_to(cr,fg_xi,fg_yi)
	cairo_line_to(cr,fg_xf,fg_yf)
	cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))
	cairo_set_line_width(cr, thc-(2*pdg))
	cairo_stroke(cr)
end
 
-------------------------------------------------
--/// Draw Widgets and Parse Setting Tables \\\--
-------------------------------------------------
--               | Parametres |                --
-- set_table: the setting table declared above
-- widtype: the widget type, for now only "ring" and "bar"
local function conky_widget_stats(set_table,widtype)
	-- Given the widget type do the setup
    local function setup_widgets(cr,pt,type)
        local str=''
        local value=0
 		-- Parse conky string
        str=string.format('${%s %s}',pt['name'],pt['arg'])
        str=conky_parse(str)
        value=tonumber(str)
        if value == nil then value = 0 end
        pct=value/pt['max']
 		-- Identify the type
		if type == "ring" then draw_ring(cr,pct,pt) end
		if type == "bar"  then draw_bar(cr,pct,pt) end
	end
 	-- Return nothing if there is no conky window
    if conky_window==nil then return end
	-- Create the surface
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width, conky_window.height)
    local cr=cairo_create(cs)    
	-- Pairs table
    for i in pairs(set_table) do setup_widgets(cr,set_table[i],widtype) end
	-- Destroy what you created
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
end

-------------------------------------------------
----/// Drawing Backgrounds With Borders ///-----
-------------------------------------------------
--               | Parametes: |                --
-- [ nothing ]
--                  | TODO |                   --
-- Allow insert starting coordinate and width
-- and height for the background
local function conky_draw_bg()
	if conky_window==nil then return end
	-- General parameters
	local h=conky_window.height
	local w=conky_window.width
	local th=main_border_thick
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	-- Background 
	local cr_bg=cairo_create(cs)
	-- Border setting
	local cr_br=cairo_create(cs)
	
	local function create_pattern(cr,w,h,t)
		cairo_move_to(cr,corner_r,t)
		cairo_line_to(cr,w-corner_r,t)
		cairo_curve_to(cr,w-t,t,w-t,t,w-t,corner_r)
		cairo_line_to(cr,w-t,h-corner_r)
		cairo_curve_to(cr,w-t,h-t,w-t,h-t,w-corner_r,h-t)
		cairo_line_to(cr,corner_r,h-t)
		cairo_curve_to(cr,t,h-t,t,h-t,t,h-corner_r)
		cairo_line_to(cr,t,corner_r)
		cairo_curve_to(cr,t,t,t,t,corner_r,t)
		cairo_close_path(cr)
 	end

	create_pattern(cr_bg,w,h,th)
	create_pattern(cr_br,w,h,th)

	cairo_set_source_rgba(cr_bg,rgb_to_r_g_b(main_bg_colour,main_bg_alpha))
	cairo_set_source_rgba(cr_br,rgb_to_r_g_b(main_border_color,main_border_alpha))
	
	cairo_set_line_width(cr_br,th)
	
	cairo_fill(cr_bg)
	cairo_stroke(cr_br)
	
	cairo_destroy(cr_bg)
	cairo_destroy(cr_br)
	cairo_surface_destroy(cs)
end

require "imlib2"
function conky_load_image()
	imlib_set_cache_size(4096* 1024)
	imlib_context_set_dither(1)
	
	image = imlib_load_image("/tmp/mpdcover")
	imlib_context_set_image(image)
	h, w = imlib_image_get_height(), imlib_image_get_width()
	
	buffer = imlib_create_image(w, h)
	imlib_context_set_image(buffer)
	
	imlib_blend_image_onto_image(image, 0, 0, 0, w, h, 0, 0, 100, 100)
	imlib_context_set_image(image)

	imlib_context_set_image(buffer)
	imlib_render_image_on_drawable(0,0)
	imlib_free_image()
end
--\\\\\\\\\\\\\\\\\\\\\\\\\--
--///   E X E C U T E   ///--
--\\\\\\\\\\\\\\\\\\\\\\\\\--

-- Main conky
function conky_main_first()
--	conky_draw_bg()
	conky_widget_stats(ring_settings_table,'ring')
	conky_widget_stats(bar_settings_table,'bar')
end
-- MPD conky
function conky_main_second()
	--conky_draw_bg()
	conky_widget_stats(bar_settings_table,'bar')
	--conky_load_image()
end
