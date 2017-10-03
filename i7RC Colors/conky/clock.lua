require 'cairo'
function conky_draw_clock()
	if conky_window==nil then return end
	local w=conky_window.width
	local h=conky_window.height
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr=cairo_create(cs)
			
	-- Settings
	
		-- What radius should the clock face (not including border) be, in pixels?
		
		local clock_r=32
	
		-- x and y coordinates, relative to the top left corner of Conky, in pixels
		
		local xc=w/2
		local yc=h/2
	
	
		-- Do you want to show the second hand? Use this if you use a Conky update_interval > 1s. Can be true or false.
		
		show_seconds=true
	
	-- Grab time
	
	local hours=os.date("%I")
	local mins=os.date("%M")
	local secs=os.date("%S")
	
	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins
	hours_arc=(2*math.pi/12)*hours+mins_arc/12
	
	-- Draw hour hand
	
	xh=xc+0.7*clock_r*math.sin(hours_arc)
	yh=yc-0.7*clock_r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)
	
	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,0,0,0,0.5)
	cairo_stroke(cr)
	
	-- Draw minute hand
	
	xm=xc+0.9*clock_r*math.sin(mins_arc)
	ym=yc-0.9*clock_r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)
	
	cairo_set_line_width(cr,3)
	cairo_stroke(cr)
	
	-- Draw seconds hand
	
	if show_seconds then
		xs=xc+0.9*clock_r*math.sin(secs_arc)
		ys=yc-0.9*clock_r*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)
		cairo_set_source_rgba(cr,1,0,0,1)
		cairo_set_line_width(cr,1)
		cairo_stroke(cr)
	end
end
