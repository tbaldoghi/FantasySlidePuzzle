Tile = {
  tilePosition,
  tileSize,
  isEmpty = false,
  tileGroup = {},
}

function Tile:new(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)

  return o
end

function Tile:addSprite(sceneGroup, imageSheet, counter, x, y)
  local options = {
    name = counter,
    start = counter,
    count = 1,
    time = 0,
    loopCount = 0
  }

  local sprite = display.newSprite(sceneGroup, imageSheet, options)
  
  sprite.alpha = 0
  sprite.x = x
  sprite.y = y

  transition.fadeIn(sprite, { time = 2000, delay = 150 })
end

function Tile:addTile(sceneGroup, imageSheet, counter, x, y, tileSize, difficulty, handleEvent)
  self.tileGroup = display.newGroup()
  self.tileSize = tileSize

  local options = {
    name = counter,
    start = counter,
    count = 1,
    time = 0,
    loopCount = 0
  }

  local offsetMuliplier = 2.75

  if difficulty == 'normal' then
    offsetMuliplier = 3
  elseif difficulty == 'hard' then
    offsetMuliplier = 3.5
  end

  local tileNumberOffset = self.tileSize / offsetMuliplier * -1
  local sprite = display.newSprite(imageSheet, options)

  self.tileNumber = display.newText(counter, tileNumberOffset, tileNumberOffset, "assets/fonts/oswald.ttf", 32)
  self.tileNumber.alpha = 1

  self.tileGroup.x = x
  self.tileGroup.y = y
  self.tileGroup.tileInstance = self

  self.tileNumber:setFillColor(1, 1, 1)
  self.tileGroup:addEventListener("touch", handleEvent)
  self.tileGroup:insert(sprite)
  self.tileGroup:insert(self.tileNumber)

  sceneGroup:insert(self.tileGroup)
end

function Tile:move(moveTo, hasTransition)
  local x = self.tileGroup.x
  local y = self.tileGroup.y

  if (moveTo == 'up') then
    y = y - self.tileSize
  elseif (moveTo == 'down') then
    y = y + self.tileSize
  elseif (moveTo == 'right') then
    x = x + self.tileSize
  elseif (moveTo == 'left') then
    x = x - self.tileSize
  end

  if (hasTransition) then
    local options = {
      x = x,
      y = y,
      time = 100,
      delay = 0,
      transition = easing.linear
    }
  
    transition.moveTo(self.tileGroup, options)
  else
    self.tileGroup.x = x
    self.tileGroup.y = y
  end
end

function Tile:hideNumber()
  transition.fadeOut(self.tileNumber, { time = 2000 })
end

function Tile:getPosition()
  return self.tilePosition
end

function Tile:setPosition(position)
  self.tilePosition = position
end

function Tile:getIsEmpty()
  return self.isEmpty
end

function Tile:setIsEmpty(isEmpty)
  self.isEmpty = isEmpty
end

return Tile
