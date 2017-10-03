--[[TEXT WIDGET v1.3 by giancarlo64 27/10/2012

Required conky 1.8.0 

To call this script in the conkyrc, in before-TEXT section:
    lua_load /path/to/the/lua/text.lua
    lua_draw_hook_pre draw_text
 



]]

require 'cairo'

function conky_draw_text()
	

	local col0,col1,col2=0x205b85,0xCCFF99,0x2b78ae
	local colbg=0x389be1
    text_settings={

		{
			text=conky_parse("${time %A  %d %B %Y}"),
			font_name="Verdana",
			font_size=14,
			h_align="c",
			bold=true,
			x=130,
			y=40,
			reflection_alpha=0.9,
			reflection_length=1,
			reflection_scale=1,
			colour={{0,colbg,1}},
                        
                        
                        
		},

		{
			text=conky_parse("${time %H:%M}"),
			font_name="Verdana",
			font_size=44,
			h_align="c",
			bold=true,
			x=290,
			y=50,
                        reflection_scale=1,
			reflection_alpha=0.9,
			reflection_length=0.8,
			colour={{0,col0,1},{1,colbg,1}},
			radial={0,-550,500,00,-4990,5000},
		},
 
        
        {
		    text=conky_parse('Cpu : ${cpu} %'),
		    x=40,
		    y=105,
		    v_align="t",
		    font_name="Verdana",
		    font_size=20,
                    bold=true,
		    colour={{0,col0,1},{0.3,colbg,1}},
		    orientation="sw",
    		    reflection_alpha=0.9,
    		    reflection_length=1,
                    reflection_scale=1,
                    			
        },  
        
        {
		    text=conky_parse('Mem : ${memperc} %'),
		    x=145,
		    y=85,
		    v_align="l",
		    font_name="Verdana",
		    font_size=16,
                    bold=true,
		    colour={{0,col2,1},{0.9,colbg,1}},
		    orientation="sw",
		    reflection_alpha=0.9,
		    reflection_length=1,
                    reflection_scale=1,
                    
        },         		

   	{
    		text=conky_parse('Hdd : ${fs_used_perc} %'),
    		font_size=19,
    		font_name="Verdana",
                bold=true,
    		v_align="t",
    		x=275,
    		y=90,
    		reflection_alpha=0.9,
    		reflection_length=1,
    		colour={{0,col2,1},{0.9,colbg,1}},
    		orientation="sw",
                reflection_scale=1,
               
                
    		
    	}, 


    }
	
 
           
    
    
--------------FIN DES PARAMETERES----------------
    if conky_window == nil then return end
    if tonumber(conky_parse("$updates"))<3 then return end
   	
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

    for i,v in pairs(text_settings) do	
    	cr = cairo_create (cs)
		display_text(v)
	    cairo_destroy(cr)
    end
	
	cairo_surface_destroy(cs)
	


end

function rgb_to_r_g_b2(tcolour)
    colour,alpha=tcolour[2],tcolour[3]
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function display_text(t)

	local function set_pattern()
		--this function set the pattern
		if #t.colour==1 then 
		    cairo_set_source_rgba(cr,rgb_to_r_g_b2(t.colour[1]))
		else
			local pat
			
			if t.radial==nil then
				local pts=linear_orientation(t,te)
				pat = cairo_pattern_create_linear (pts[1],pts[2],pts[3],pts[4])
			else
				pat = cairo_pattern_create_radial (t.radial[1],t.radial[2],t.radial[3],t.radial[4],t.radial[5],t.radial[6])
			end
		
		    for i=1, #t.colour do
		        cairo_pattern_add_color_stop_rgba (pat, t.colour[i][1], rgb_to_r_g_b2(t.colour[i]))
		    end
		    cairo_set_source (cr, pat)
		end
    end
    
    --set default values if needed
    if t.text==nil then t.text="Conky is good for you !" end
    if t.x==nil then t.x = conky_window.width/2 end
    if t.y==nil then t.y = conky_window.height/2 end
    if t.colour==nil then t.colour={{1,0xFFFFFF,1}} end
    if t.font_name==nil then t.font_name="Free Sans" end
    if t.font_size==nil then t.font_size=14 end
    if t.angle==nil then t.angle=0 end
    if t.italic==nil then t.italic=false end
    if t.oblique==nil then t.oblique=false end
    if t.bold==nil then t.bold=false end
    if t.radial ~= nil then
    	if #t.radial~=6 then 
    		print ("error in radial table")
    		t.radial=nil 
    	end
    end
    if t.orientation==nil then t.orientation="ww" end
    if t.h_align==nil then t.h_align="l" end
    if t.v_align==nil then t.v_align="b" end    
    if t.reflection_alpha == nil then t.reflection_alpha=0 end
    if t.reflection_length == nil then t.reflection_length=1 end
    if t.reflection_scale == nil then t.reflection_scale=1 end
    if t.rotx==nil then t.rotx=0 end
    if t.roty==nil then t.roty=0 end    
    cairo_translate(cr,t.x,t.y)
    cairo_rotate(cr,t.angle*math.pi/180)
    cairo_save(cr)       
 	
 

    local slant = CAIRO_FONT_SLANT_NORMAL
    local weight =CAIRO_FONT_WEIGHT_NORMAL
    if t.italic then slant = CAIRO_FONT_SLANT_ITALIC end
    if t.oblique then slant = CAIRO_FONT_SLANT_OBLIQUE end
    if t.bold then weight = CAIRO_FONT_WEIGHT_BOLD end
    
    cairo_select_font_face(cr, t.font_name, slant,weight)
 
    for i=1, #t.colour do    
        if #t.colour[i]~=3 then 
        	print ("error in color table")
        	t.colour[i]={1,0xFFFFFF,1} 
        end
    end

	local matrix0 = cairo_matrix_t:create()
	rotx,roty=t.rotx/t.font_size,t.roty/t.font_size
	cairo_matrix_init (matrix0, 1,roty,rotx,1,0,0)
	cairo_transform(cr,matrix0)
	cairo_set_font_size(cr,t.font_size)
	te=cairo_text_extents_t:create()
    cairo_text_extents (cr,t.text,te)
	
	set_pattern()


			
    mx,my=0,0
    
    if t.h_align=="c" then
	    mx=-te.width/2
    elseif t.h_align=="r" then
	    mx=-te.width
	end
    if t.v_align=="m" then
	    my=-te.height/2-te.y_bearing
    elseif t.v_align=="t" then
	    my=-te.y_bearing
	end
	cairo_move_to(cr,mx,my)
	
    cairo_show_text(cr,t.text)

 	
		
		
   if t.reflection_alpha ~= 0 then 
		local matrix1 = cairo_matrix_t:create()
		cairo_set_font_size(cr,t.font_size)

		cairo_matrix_init (matrix1,1,0,0,-1*t.reflection_scale,0,(te.height+te.y_bearing+my)*(1+t.reflection_scale))
		cairo_set_font_size(cr,t.font_size)
		te=cairo_text_extents_t:create()
		cairo_text_extents (cr,t.text,te)
		
				
		cairo_transform(cr,matrix1)
		set_pattern()
		cairo_move_to(cr,mx,my)
		cairo_show_text(cr,t.text)


		local pat2 = cairo_pattern_create_linear (0,
										(te.y_bearing+te.height+my),
										0,
										te.y_bearing+my)
		cairo_pattern_add_color_stop_rgba (pat2, 0,1,0,0,1-t.reflection_alpha)
		cairo_pattern_add_color_stop_rgba (pat2, t.reflection_length,0,0,0,1)	
		
		
		cairo_set_line_width(cr,0)
		dy=te.x_bearing
		if dy<0 then dy=dy*(-1) end
		cairo_rectangle(cr,mx+te.x_bearing,te.y_bearing+te.height+my,te.width+dy,-te.height*1.05)
		cairo_clip_preserve(cr)
		cairo_set_operator(cr,CAIRO_OPERATOR_CLEAR)
		--cairo_stroke(cr)
		cairo_mask(cr,pat2)
		cairo_pattern_destroy(pat2)
		cairo_set_operator(cr,CAIRO_OPERATOR_OVER)
    end
    
end


function linear_orientation(t,te)
	local w,h=te.width,te.height
	local xb,yb=te.x_bearing,te.y_bearing
	
    if t.h_align=="c" then
	    xb=xb-w/2
    elseif t.h_align=="r" then
	    xb=xb-w
   	end	
    if t.v_align=="m" then
	    yb=-h/2
    elseif t.v_align=="t" then
	    yb=0
   	end	
   	
	if t.orientation=="nn" then
		p={xb+w/2,yb,xb+w/2,yb+h}
	elseif t.orientation=="ne" then
		p={xb+w,yb,xb,yb+h}
	elseif t.orientation=="ww" then
		p={xb,h/2,xb+w,h/2}
	elseif vorientation=="se" then
		p={xb+w,yb+h,xb,yb}
	elseif t.orientation=="ss" then
		p={xb+w/2,yb+h,xb+w/2,yb}
	elseif vorientation=="ee" then
		p={xb+w,h/2,xb,h/2}		
	elseif t.orientation=="sw" then
		p={xb,yb+h,xb+w,yb}
	elseif t.orientation=="nw" then
		p={xb,yb,xb+w,yb+h}
	end
	return p
end

