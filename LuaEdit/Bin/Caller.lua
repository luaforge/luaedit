dofile(".\Function.lua")
local addition = 0

function test(param1)
   param1 = param1 + 5
   param1 = test2(addition)
   return param1
end      

function test2(param1)
   param1 = param1 + 5
   return param1
end

--while 1 == 1 do
--   addition = addition + 1
--end

local bibi = 3
local bobo = 7
print(bibi)
addition = test(addition)
foo("hello")
addition = bibi + bobo
print(addition)
