local BoardElement = {}

-- mark could be "0", "X" , ""
-- element - rect(display.newRect), has the ui group, position, size.

function BoardElement.new(ui_group ,xpos, ypos, size, event, name)
  set = {}
  setmetatable(set, { element, mark})
  set.mark = ""
  set.element = display.newRect(ui_group, xpos, ypos, size, size);
  set.element:setFillColor(0.2)
  set.element:addEventListener("tap", event)
  set.element.name = name
  return set
end

return BoardElement
