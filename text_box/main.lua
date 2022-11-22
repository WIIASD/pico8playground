all_text = {
    "hey this is a line of text used to test the text box and it should be pretty lengthy in order to do the job",
    "this is a short txt"
}

all_palette = {
    {col=5, t_col=9, s_col=4},
    {col=1, t_col=8, s_col=2},
    {col=1, t_col=7, s_col=5}
}

txt_i = 1
p_i = 1

function _init()
	--setup_text()
    text_boxes = {}
    b = text_box:new(all_text[txt_i],0,0,127,5,{x=1,y=0},all_palette[p_i])
    add(text_boxes, b)
end

function _update()

    if btn(0) then
        b.w-=1
    end

    if btn(1) then
        b.w+=1
    end

    if btnp(2) then
        txt_i = txt_i + 1 > #all_text and 1 or txt_i + 1
        b.txt = all_text[txt_i]
    end

    if btnp(3) then
        txt_i = txt_i - 1 < 1 and #all_text or txt_i - 1
        b.txt = all_text[txt_i]
    end

    if btnp(5) then
        p_i = p_i + 1 > #all_palette and 1 or p_i + 1
        b.palette = all_palette[p_i]
    end

    for i=1,#text_boxes do
        text_boxes[i]:update()
    end
    
end

function _draw()
	cls()
    for i=1,#text_boxes do
        text_boxes[i]:draw()
    end
end
