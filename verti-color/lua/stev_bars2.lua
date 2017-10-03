require 'cairo'

settings_table={
{
    name='cpu',
    arg='cpu0',
    max=100,
    x=0,
    y=20,
    title='CPU',
},
{
    name='memperc',
    arg='',
    max=100,
    x=30,
    y=20,
    title='MEM',
},
{
    name='upspeedf',
    arg='eth0',
    max=100,
    x=60,
    y=20,
    title='UP',
},
{
    name='downspeedf',
    arg='eth0',
    max=100,
    x=90,
    y=20,
    title='DN',
},
}

function draw_bar(pct, pt)
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr=cairo_create(cs)
    local gx=45
    local gy=185
    --[[test
    if pt['arg'] == 'cpu1' then pct=23 end
    if pt['arg'] == 'cpu2' then pct=10 end
    if pt['arg'] == 'cpu3' then pct=60 end
    if pt['title'] == 'MEM' then pct=85  end
    if pt['title'] == 'netD' then pct=40 end
    if pt['title'] == 'netU' then pct=10 end
    ]]
    cairo_move_to(cr,pt['x']+gx+5,pt['y']+gy-5)
    cairo_set_source_rgba (cr,1,0.8,0,1)
    cairo_show_text(cr,tostring(pct))
    cairo_stroke (cr)
    cairo_set_source_rgba (cr,1,1,1,1)
    cairo_move_to(cr,pt['x']+gx,pt['y']+gy-20)
	cairo_show_text(cr,pt['title'])
	cairo_stroke(cr)
    if (pt['arg'] == 'ppp0' and pct<=95) then
		cairo_set_source_rgba (cr,1,1,1,0.4)
    elseif (pt['arg'] == 'ppp0' and pct>100) then
		pct=100
		cairo_set_source_rgba (cr,1,0,0.2,0.4)
    else
		if pct<=50 then
		cairo_set_source_rgba (cr,0.5,1,0,0.4)
		elseif (pct>50 and pct<=80) then
		cairo_set_source_rgba (cr,0.8,0.8,0,0.4)
		else 
		cairo_set_source_rgba (cr,1,0,0.2,0.4)
		end
	end
    cairo_set_line_width (cr,1)
	cairo_rectangle (cr,pt['x']+gx,pt['y']+gy,25,pct)	
	cairo_fill_preserve (cr)
    cairo_stroke (cr)
    cairo_destroy(cr)
    cr=nil
end

function conky_bar_stats()
    local function setup_bars(pt)
        local str=''
        local value=0

        str=string.format('${%s %s}',pt['name'],pt['arg'])
        str=conky_parse(str)
    
        value=math.floor(tonumber(str))
        if value == nil then
        pct=0
        else
        pct=value*100/pt['max']
        end

        draw_bar(pct,pt)
    end

    if conky_window == nil then return end
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)


    if update_num>5 then
        for i in pairs(settings_table) do
            setup_bars(settings_table[i])
        end
    end
end
