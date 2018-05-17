-- -----------------------------------------------------------------------------------
--
-- Game data for Tic-Tac-Toy game, where you can choose one player or two.
--
-- -----------------------------------------------------------------------------------

local GameData = {
  isSingle = false,
  firstPlayer = "x",
  secondPlayer = "o",
  turnOnSound = true,
  turn = "x" or "o", -- could be "x" or "o"
  run = true
}

return GameData
