drf_draw = {}

function drf_draw.draw_simple_text2d(text, col, x, y)
    draw.SimpleText(text, "fdr_hud_text", x, y, col)
end

function drf_draw.draw_future_text2d(text, col, x, y)
    draw.SimpleText(text, "fdr_futuristic", x, y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end
