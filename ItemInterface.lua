
ItemInterface = {}
ItemInterface.mt = {}

setmetatable(ItemInterface, ItemInterface.mt)

function CalculatePoints(elements)
  local firstPoint = { x = 0 , y = 0 }
  local secondPoint = { x = 0, y = 0 }
  local rangeByX = elements[#elements].element.x - elements[1].element.x
  local rangeByY = elements[#elements].element.y - elements[1].element.y
  if rangeByX ~= 0 and rangeByY == 0 then
    -- count horizontal.
    firstPoint.x = elements[1].element.x - elements[1].element.width / 2
    firstPoint.y = elements[1].element.y
    secondPoint.x = elements[#elements].element.x + elements[1].element.width / 2
    secondPoint.y = elements[#elements].element.y
  elseif rangeByY ~= 0 and rangeByX == 0 then
    -- count vertical.
    firstPoint.x = elements[1].element.x
    firstPoint.y = elements[1].element.y - elements[1].element.height / 2
    secondPoint.x = elements[#elements].element.x
    secondPoint.y = elements[#elements].element.y + elements[1].element.height / 2
  else
    -- count other.
    if elements[1].element.x < elements[#elements].element.x then
      -- leftTop -> bottomRight.
      firstPoint.x = elements[1].element.x - elements[#elements].element.width / 2
      firstPoint.y = elements[1].element.y - elements[#elements].element.height / 2
      secondPoint.x = elements[#elements].element.x + elements[#elements].element.width / 2
      secondPoint.y = elements[#elements].element.y + elements[#elements].element.height / 2
    else
      -- rightTop -> bottomLeft.
      firstPoint.x = elements[1].element.x + elements[1].element.width / 2
      firstPoint.y = elements[1].element.y - elements[1].element.height / 2
      secondPoint.x = elements[#elements].element.x - elements[#elements].element.width / 2
      secondPoint.y = elements[#elements].element.y + elements[#elements].element.height / 2
    end
  end
  return firstPoint, secondPoint
end

function ItemInterface:DrawEx(group, xPos, yPos)
  --xLines = {{},{}}
  local range = 20
  local firstLine = display.newLine(group, xPos - range, yPos - range, xPos + range, yPos + range)
  firstLine.strokeWidth = 2
  firstLine:setStrokeColor(255, 239, 0, 1)
  local secondLine = display.newLine(group, xPos + range, yPos - range, xPos - range, yPos + range)
  secondLine.strokeWidth = 2
  secondLine:setStrokeColor(255, 239, 0, 1)
  table.insert(self, firstLine)
  table.insert(self, secondLine)
end

function ItemInterface:DrawCircle(group, xPos, yPos)
  local circle = display.newCircle(group, xPos, yPos, 20 )
  circle:setFillColor( 0.2 )
  circle.strokeWidth = 2
  circle:setStrokeColor(255, 239, 0, 1)
  table.insert(self, circle)
end

function ItemInterface:DrawTheLine(group, elements)
  if elements ~= nil and #elements ~= o then
    local startPoint , endPoint = CalculatePoints(elements)
    local lineForWin = display.newLine(group, startPoint.x, startPoint.y,
                                      endPoint.x, endPoint.y)
    lineForWin.strokeWidth = 2
    table.insert(self, lineForWin)
  else
    error("Error, the are no elements at all!")
  end
end

function ItemInterface:RemoveAllItems()
  for i = #self, 1, -1 do
    object = self[i]
    display.remove(object)
    table.remove( self, i )
  end
end

return ItemInterface
