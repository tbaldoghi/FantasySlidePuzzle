local widget = require("widget")

Button = {
  buttonGroup = {}
}

function Button:new(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)

  return o
end

function Button:addButton(sceneGroup, label, x, y, handleButtonEvent, isSmall)
  local isSmall = isSmall or false
  self.buttonGroup = display.newGroup()

  local options = {
    label = label,
    emboss = true,
    shape = "rect",
    width = 320,
    height = 100,
    fillColor = { default={210 / 255, 201 / 255, 165 /255,1}, over={171/255,155/255,142/255,1} },
    labelColor = { default={ 75 / 255, 61 / 255, 68 / 255, 1 }, over={ 75 / 255, 61 / 255, 68 / 255, 1 } },
    strokeColor = { default={ 75 / 255, 61 / 255, 68 / 255, 1 }, over={ 75 / 255, 61 / 255, 68 / 255, 1 } },
    strokeWidth = 4,
    font = "assets/fonts/oswald.ttf",
    fontSize = 52
  }

  if (isSmall) then
    options['width'] = 200
    options['height'] = 60
    options['fontSize'] = 42
  end

  local button = widget.newButton(options)

  button.x = x
  button.y = y
  button:addEventListener('tap', handleButtonEvent)

  self.buttonGroup:insert(button)

  sceneGroup:insert(self.buttonGroup)
end

function Button:setAlpha(alpha)
  self.buttonGroup.alpha = alpha
end

function Button:getButton()
  return self.buttonGroup
end

return Button
