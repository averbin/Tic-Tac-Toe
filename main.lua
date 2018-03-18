-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local Board = {{},{},{}}
local BoardElement = {}
mt = { element, mark}
local turn = "x" -- could be "x" or "o"
local exitButton = display.newRect(display.contentWidth - 50, 20, 30, 30)
exitButton:setFillColor(1.0, 0.0, 0.0)
function ExitTapEvent( event )
  os.exit()
end
exitButton:addEventListener("tap", ExitTapEvent)

function FindElement(name)
  print("Searching element: " .. name)
  for i, v in pairs( Board ) do
    for j , value in pairs(v) do
      if value.element.name == name then
        return value
      end
    end
  end
end

function DrawCircle(xPos, yPos)
  local circle = display.newCircle( xPos, yPos, 20 )
  circle:setFillColor( 0.2 )
  circle.strokeWidth = 2
  circle:setStrokeColor( 1, 1, 1 )
  return circle
end

function DrawLines(xPos, yPos)
  --xLines = {{},{}}
  local range = 20
  firstLine = display.newLine(xPos - range, yPos - range, xPos + range, yPos + range)
  firstLine.strokeWidth = 2
  secondLine = display.newLine(xPos + range, yPos - range, xPos - range, yPos + range)
  secondLine.strokeWidth = 2
end

function tapEvent( event )
  print("tap: " .. event.target.name)
  print("pos: " .. event.target.x .. "\ty: " .. event.target.y)
  boardElement = FindElement(event.target.name)
  if boardElement.mark == "" then

    print("Turn: " .. turn)
    if turn == "x" then
      boardElement.mark = "x"
      DrawLines(event.target.x, event.target.y)
      turn = "o"
    else
      boardElement.mark = "o"
      DrawCircle(event.target.x, event.target.y)
      turn = "x"
    end
  else
    print("Exists: ".. event.target.name .. "\t" .. boardElement.mark)
  end
  --newRect = display.newRect(event.target, event.target.x, event.target.y, 10,10)
  return true
end

function BoardElement.new(xpos, ypos, size, name)
  set = {}
  setmetatable(set, mt)
  set.mark = ""
  set.element = display.newRect(xpos, ypos, size, size);
  set.element:setFillColor(0.2)
  set.element:addEventListener("tap", tapEvent)
  set.element.name = name
  return set
end

local range = 70

local addH = 0
local counter = 1
for j = 1 , 3  do
  local addW = 0
  for i = 1, 3 do
    Board[j][i] = BoardElement.new(range * i + addW, range * j + addH + 100, range, tostring(counter))
    counter = counter + 1
    addW = addW + 20
  end
  addH = addH + 20
end
