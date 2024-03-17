local sqlite3 = require('sqlite3')
local difficulties = { 'easy', 'normal', 'hard' }

Database = {
  database
}

function Database:new(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)

  return o
end

function Database:handleOnSystemEvent(event)
  if (event and event.type == "applicationExit") then
      self.database:close()
  end
end

function Database:selectDifficultyId(difficulty)
  local difficulty_id
  local sql = [[SELECT difficulty_id FROM difficulties WHERE difficulty=']]..difficulty..[[';]]

  for row in self.database:nrows(sql) do
    difficulty_id = row.difficulty_id
  end

  return difficulty_id
end

function Database:populateLevelsTable()
  for key, difficulty in pairs(difficulties) do
    local difficulty_id = self:selectDifficultyId(difficulty)

    for i = 1, 30, 1 do
      local sql = [[INSERT INTO levels VALUES (NULL, ]]..i..[[, 0, 0, 0,]]..difficulty_id..[[);]]

      self.database:exec(sql)
    end

    local sql = [[UPDATE levels SET is_playable = 1 WHERE level = 1;]]

    self.database:exec(sql)
  end
end

function Database:initialize()
  local path = system.pathForFile('fsp_data.db', system.DocumentsDirectory)
  self.database = sqlite3.open(path)

  local sql = [[
    CREATE TABLE IF NOT EXISTS difficulties (
      difficulty_id INTEGER PRIMARY KEY,
      difficulty TEXT NOT NULL UNIQUE
    );
  ]]

  self.database:exec(sql)

  for key, difficulty in pairs(difficulties) do
    sql = [[INSERT INTO difficulties VALUES (NULL, ']]..difficulty..[[');]]

    self.database:exec(sql)
  end

  sql = [[
    CREATE TABLE IF NOT EXISTS levels (
      level_id INTEGER PRIMARY KEY,
      level INTEGER NOT NULL,
      moves INTEGER NOT NULL,
      time INTEGER NOT NULL,
      is_playable INTEGER NOT NULL,
      difficulty_id INTEGER NOT NULL,
      FOREIGN KEY(difficulty_id) REFERENCES difficulties(difficulty_id)
    );
  ]]

  self.database:exec(sql)

  sql = [[SELECT COUNT(*) FROM levels;]]

  for row in self.database:nrows(sql) do
    if row['COUNT(*)'] == 0 then
      self:populateLevelsTable()
    end
  end

  Runtime:addEventListener('system', self.handleOnSystemEvent)
end

function Database:levelsInsert(level, moves, time, is_playable)
  local sql = [[INSERT INTO levels VALUES (NULL, ']]..level..[[',']]..moves..[[',']]..time..[[',']]..is_playable..[[');]]

  self.database:exec(sql)
end

function Database:levelsDataUpdate(level, difficulty, moves, time)
  local difficulty_id = self:selectDifficultyId(difficulty)
  local sql = [[UPDATE levels SET moves=]]..moves..[[, time=]]..time..[[ WHERE difficulty_id =]]..difficulty_id..[[ AND level=]]..level..[[;]]

  self.database:exec(sql)
end

function Database:levelsIsPlayableUpdate(level, difficulty, is_playable)
  local difficulty_id = self:selectDifficultyId(difficulty)
  local sql = [[UPDATE levels SET is_playable=]]..is_playable..[[ WHERE difficulty_id =]]..difficulty_id..[[ AND level=]]..level..[[;]]

  self.database:exec(sql)
end

function Database:levelsSelect(level, difficulty)
  local difficulty_id = self:selectDifficultyId(difficulty)

  local sql = [[SELECT * FROM levels WHERE level=]]..level..[[ AND difficulty_id=]]..difficulty_id..[[;]]
  local data = {}

  for row in self.database:nrows(sql) do
    data["level"] = row.level
    data["moves"] = row.moves
    data["time"] = row.time
    data["is_playable"] = row.is_playable
  end

  return data
end

return Database
