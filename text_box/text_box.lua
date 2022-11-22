--------------------
---text_box class---
--------------------

text_box = {}

-----------------
---constructer---
-----------------
function text_box:new(txt,x,y,w,bdr,shade_offset, palette)
    local o={}

    setmetatable(o,self)
    self.__index = self

    ----------------------
    -------private--------
    ----------------------
    local wrapped_txt = nil
    --variable to store truncated txt when showing txt in each frame
    local printed_txt = ""
    local cor = nil
    local old_width = nil
    local old_txt = nil

    local function draw_box(self)
        local s = self
        rectfill(s.x,s.y,s.x+s.w,s.y+s.h,s.palette.col)
    end

    local function draw_txt(self)
        local s = self
        local shade = s.shade_offset
        local pal = s.palette 

        print(printed_txt,s.x+s.bdr + shade.x,s.y+s.bdr+shade.y,pal.s_col)
        print(printed_txt,s.x+s.bdr,s.y+s.bdr,pal.t_col)
    end

    --coroutine to update the trancated txt each on each call
    function update_printed_txt()
        c_count = 1
        while c_count <= #wrapped_txt do
            yield()
            printed_txt = sub(wrapped_txt, 1, c_count)
            c_count += 2
        end
    end

    ----------------------
    --------public--------
    ----------------------

    o.txt = txt or ""
    o.x = x or 0
    o.y = y or 0
    o.w = w or 0
    o.h = 0
    o.bdr = bdr or 0
    o.shade_offset = shade_offset or {x=0,y=0}
    o.palette = palette or {col=13, t_col=7, s_col=5}

    function o:update()
        local cpl=flr((self.w-1.5*self.bdr)/4)

        --update wrapped_txt only when txt is changed or width is changed
        if self.w != old_width or self.txt != old_txt then
            --update wrapped
            wrapped_txt = text_box:wrap_str(self.txt,cpl)

            --recreate coroutine to draw txt
            cor = cocreate(update_printed_txt) 
            printed_txt = ""

            --update new old values
            old_width = self.w
            old_txt = self.txt
        end

        local wt = wrapped_txt

        --get number of lines
        local num_lines=1
        for i=1,#wt do
            if sub(wt,i,i)=="\n" then num_lines+=1 end 
        end

        --calculate box height and pos
        self.h = num_lines * 5 + num_lines - 2 + 2 * self.bdr

        if btnp(4) then 
            cor = cocreate(update_printed_txt) 
            printed_txt = ""
	    end

        if cor and costatus(cor) != "dead" then
            coresume(cor)
        else
            cor = nil
        end
    end

    function o:draw()
        draw_box(self)
        draw_txt(self)
    end

    return o
end

----------------------
--------static--------
----------------------

function text_box:wrap_str(txt,cpl)
	--remember spaces
	space={}

	for i=1,#txt do
	    if sub(txt,i,i)==" " then
	        add(space,i)
	    end
	end
	
    --cpl: character per line
	tmp_k=cpl
	lbs={}
	
    --check which space to replace by line break
	for i=1,#space do
        if space[i]>tmp_k then
            if i==1 then 
                goto continue 
            end
            add(lbs,space[i-1])
            tmp_k=space[i-1]+cpl
        end
	    ::continue::
	end
	if #txt+1>tmp_k then
	    add(lbs,space[#space])
	end
	
	--process a string to return
	if #lbs > 0 then
		new_str=sub(txt,1,lbs[1]-1).."\n"
	
		for i=2,#lbs do
	 	    new_str=new_str..sub(txt,lbs[i-1]+1,lbs[i]-1).."\n"
		end
		
		new_str=new_str..sub(txt,lbs[#lbs]+1)
	else
		new_str=txt
	end
	
	return new_str
end