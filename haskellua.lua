function piecewise(tbl)
	piecewise=tbl 
  end 
  
  setmetatable(_ENV, {__newindex=function(t,k,v)
	  do
		  local piecewise = piecewise 
		  rawset(t,k,type(piecewise)=="table" and type(v)=="function" and function(...)return piecewise[...]or v(...)end or v)
	  end 
	  piecewise=function(tbl)piecewise=tbl end
  end})
  
  
  debug.setmetatable("", {__index=function(s,k)return string[k]or s:sub(k,k)end}) --allow strings to be indexed like tables
  
  
  showtable = {__tostring = function(t)
	  if type(t[1])~="string" then
		  if #t==0 then return"{}"end
		  local a = "{"
		  for i=1,#t do
			  a=a..tostring(t[i])..","
		  end
		  return a:sub(1,-2).."}"
	  else
		  return table.concat(t)
	  end
  end, __newindex = function(t,k,v)
	  if type(v)=="table" then setmetatable(v, showtable)end
	  rawset(t,k,v)
  end, __concat = function(a,b)
	  return tostring(a)..tostring(b)
  end}
  
  --[[
  alt curry
  function curry(fn, args, arg, n)
	  args = args or {}
	  args[#args+1] = arg
	  return (arg~=nil or not n) and function(arg)return curry(fn, args, arg, 1)end or fn(table.unpack(args))
  end
  print(curry(add)(2)(3)()) --> 5
  ]]
  
  function curry(fn, n, args, arg)
	  args = args or {}
	  args[#args+1] = arg
	  return n~=0 and function(arg)return curry(fn, n-1, args, arg)end or fn(table.unpack(args))
  end
  
  for i,v in ipairs{"max","min","abs","pi","exp","log","sqrt","sin","cos","tan","asin","acos","atan","sinh","cosh","tanh","floor","atan2","max"}do
	  _ENV[v] = math[v]
  end ceiling = math.ceil 
  
  -- a{sin,cos,tan}h TODO 
  
  maybe = function(default, fn, Maybe) -- can i just say this is such a gross order
	  return Maybe==nil and default or fn(Maybe)
  end
  
  fst   = function(a,b)
	  return a
  end
  
  snd   = function(a,b)
	  return b
  end
  
  -- insert un/curry function
  
  -- min/max from math (see 51)
  
  compare = function(a,b)
	  return (a<b and "LT") or (a==b and "EQ") or (a>b and "GT")
  end
  
  succ    = function(a)
	  local type = type(a)
	  return (type=="number" and a+1) or (type=="string" and string.char(string.byte(a)+1))
  end
  
  negate  = function(a)
	  return -a
  end
  
  -- abs from math (see 51)
  
  signum  = function(a)
	  return (a<0 and -1) or (a==0 and 0) or (a>0 and 1)
  end
  
  -- fromInteger is not necessary as lua does automatic conversion
  
  quot    = function(a,b)
	  return truncate(a/b)
  end
  
  rem     = function(a,b)
	  return math.fmod(a,b)
  end
  
  div     = function(a,b)
	  return a//b
  end
  
  mod     = function(a,b)
	  return a%b
  end
  
  quotRem = function(a,b)
	  return quot(a,b), rem(a,b)
  end
  
  divMod  = function(a,b)
	  return div(a,b), mod(a,b)
  end
  
  toInteger = function(a)
	  return math.tointeger(truncate(a))
  end
  
  -- / is already in lua
  
  recip   = function(a)
	  return 1/a
  end
  
  -- fromRational is not necessary (see fromInteger)
  
  -- pi, exp, log, sqrt, sin, cos, tan, asin, acos, atan, sinh, cosh, and tanh are covered by math (51)
  
  logBase = function(a,b)
	  return log(a,b)
  end
  
  truncate= function(a)
	  return (math.modf(a))
  end
  
  -- ceiling and floor covered by math (51)
  
  round   = function(a)
	  return toInteger(a + (2^52 + 2^51) - (2^52 + 2^51)) --...i have no idea how this works. https://stackoverflow.com/a/58411511
  end
  
  --[[
  floatRadix = function()end -- i don't think you'll ever need these
  floatDigits= function()end
  floatRange = function()end
  decodeFloat= function()end
  encodeFloat= function()end
  exponent   = function()end
  significand= function()end
  scaleFloat = function()end
  isNaN      = function()end 
  isInfinite = function()end
  isDenormalized = function()end
  isNegativeZero = function()end
  isIEEE         = function()end
  ]]
  
  --atan2 covered by math (51)
  
  subtract= function(a,b)
	  return b-a 
  end
  
  even    = function(a)
	  return a%2==0
  end
  
  odd     = function(a)
	  return a%2==1
  end
  
  gcd     = function(a,b)
	  repeat a,b=b,a%b until b==0
	  return a
  end
  
  lcm     = function(a,b)
	  return toInteger(abs(a*b)/gcd(a,b)) 
  end
  
  -- mempty
  -- mappend
  -- mconcat
  
  -- fmap
  -- <$
  -- <$>
  
  -- pure
  -- <*>
  -- *>
  -- <*
  -- >>=
  -- >>
  -- return
  -- fail
  -- mapM_
  -- sequence_
  -- =<<
  -- foldMap
  foldr   = function(fn, value, list)
	  value = fn(list[#list], value)
	  for i=#list-1,1,-1 do
		  value = fn(list[i], value)
	  end
	  return value
  end
  
  foldl   = function(fn, value, list)
	  value = fn(value, list[1])
	  for i=2,#list do
		  value = fn(value, list[i])
	  end
	  return value
  end
  
  foldr1  = function(fn, list)
	  local value = list[#list]
	  for i=#list-1,1,-1 do
		  value = fn(list[i], value)
	  end
	  return value
  end
  
  foldl1  = function(fn, list)
	  local value = list[1]
	  for i=2,#list do
		  value = fn(value, list[i])
	  end
	  return value
  end
  
  elem    = function(element, list)
	  for i=1,#list do
		  if list[i]==element then return true end
	  end
  end
  
  maximum = function(list)
	  return max(table.unpack(list))
  end
  
  minimum = function(list)
	  return min(table.unpack(list))
  end
  
  sum     = function(list)
	  return #list==0 and 0 or foldr(function(a,b)return a+b end, 0, list)
  end
  
  product = function(list)
	  return #list==0 and 1 or foldr(function(a,b)return a*b end, 1, list)
  end
  
  -- traverse
  -- sequenceA
  -- mapM
  -- sequence
  
  id      = function(a)
	  return a
  end
  
  const   = function(a,b)
	  return a
  end
  
  debug.setmetatable(function()end,{__concat=function(a,b)return function(...)return a(b(...))end end}) -- .. is compose, and i don't define $ because it saves like, two parentheses
  
  flip    = function(fn)
	  return function(a,b,...)
		  return fn(b,a,...)
	  end
  end
  
  -- until
  
  asTypeOf= function(a,b) --I don't really know how to do this one, so this will suffice for now
	  assert(type(a)==type(b), "asTypeOf: recieved arguments not of the same type")
	  return a
  end
  
  --error is covered by lua
  
  --errorWithoutStackTrace isn't actually possible in lua. sorry
  
  --i have no idea how to treat undefined
  
  -- seq
  -- $!
  map     = function(fn, list)
	  local t=setmetatable({},showtable)
	  for i=1,#list do
		  t[i]=fn(list[i])
	  end
	  return t
  end
  
  -- concat lists. hmm
  
  
  function comp(fn, list, pred--[[icate]])
	  local t=setmetatable({},showtable)
	  pred = pred or function()return true end
	  for i=1,#list do
		  local value = fn(list[i])
		  if pred(value) then t[#t+1]=value end
	  end
	  return t
  end
  
  
  filter  = function(pred, list)
	  return comp(id,list,pred)
  end
  
  head    = function(list)
	  return list[1]
  end
  
  last    = function(list)
	  return list[#list]
  end
  
  tail    = function(list)
	  local t=setmetatable({},showtable)
	  for i=2,#list do
		  t[i-1]=list[i]
	  end
	  return t
  end
  
  init    = function(list)
	  local t=setmetatable({},showtable)
	  for i=1,#list-1 do
		  t[i]=list[i]
	  end
	  return t
  end
  
  null    = function(list)
	  return list[1]==nil
  end
  
  length  = function(list)
	  return #list
  end
  
  reverse = function(list)
	  local t,len=setmetatable({},showtable),#list
	  for i=len,1,-1 do
		  t[len-i+1]=list[i]
	  end
	  return t
  end
  
  _and    = function(list)
	  return #list==0 or foldr(function(a,b)return a and b end, true, list)
  end
  
  _or     = function(list)
	  return #list~=0 and foldr(function(a,b)return a or b end, true, list)
  end
  
  any     = function(pred, list)
	  for i=1,#list do
		  if not pred(list[i]) then return false end
	  end
	  return true
  end
  
  concat  = function(list)
	  local t=setmetatable({},showtable)
	  if #list==0 then return t end
	  for i=1,#list do
			  for j=1,#(list[i])do
				  t[#t+1]=list[i][j]
			  end
	  end
	  return t
  end
  
  concatMap = function(fn, list)
	  return concat(map(fn, list))
  end
  
  -- scanl
  -- scanr
  -- scanl1
  -- scanr1
  -- iterate
  
  __repeat  = function(value)
	   return setmetatable({}, {__index=function()return value end, __tostring=function()return "{repeat "..value.."}" end})
  end
  
  replicate= function(n, value)
	  local t=setmetatable({},showtable)
	  for i=1,n do
		  t[i]=value
	  end
	  return t
  end
  
  --cycle
  take    = function(n, list)
	  local t=setmetatable({},showtable)
	  for i=1,min(n,#list) do
		  t[i]=list[i]
	  end
	  return t
  end
  
  drop    = function(n, list)
	  local t=setmetatable({},showtable)
	  for i=min(n+1,#list), #list do
		  t[#t+1]=list[i]
	  end
	  return t
  end
  
  takeWhile=function(pred,list)
	  local t=setmetatable({},showtable)
	  for i=1,#list do
		  if not pred(list[i])then return t end
		  t[i]=list[i]
	  end
	  return t
  end
  
  dropWhile=function(pred,list)
	  local t=setmetatable({},showtable)
	  for i=#takeWhile(pred,list), #list do -- maybe don't rely on takeWhile
		  t[#t+1]=list[i]
	  end
	  return t
  end
  
  span    = function(pred,list)
	  local t1,t2=setmetatable({},showtable),setmetatable({},showtable)
	  for i=1,#list do
		  if not pred(list[i]) then
			  for j=i,#list do
				  t2[#t2+1]=list[j]
			  end
			  return setmetatable({t1,t2},showtable)
		  end
		  t1[#t1+1]=list[i]
	  end
	  return setmetatable({t1,t2},showtable)
  end
  
  _break  = function(pred,list)
	  local t1,t2=setmetatable({},showtable),setmetatable({},showtable)
	  for i=1,#list do
		  if pred(list[i]) then
			  for j=i,#list do
				  t2[#t2+1]=list[j]
			  end
			  return setmetatable({t1,t2},showtable)
		  end
		  t1[#t1+1]=list[i]
	  end
	  return setmetatable({t1,t2},showtable)
  end
  
  splitAt = function(n, list)
	  local t1,t2=setmetatable({},showtable),setmetatable({},showtable)
	  n=max(0,min(n,#list))
	  for i=1,n do
		  t1[i]=list[i]
	  end
	  for i=n+1,#list do
		  t2[i-n]=list[i]
	  end
	  return setmetatable({t1,t2},showtable)
  end
  
  notElem = function(element, list)
	  return not elem(element,list)
  end
  
  lookup  = function(key,list)
	  for i=1,#list do
		  if list[i][1]==key then return list[i][2]end
	  end
  end
  
  zip     = function(list1, list2)
	  local t=setmetatable({},showtable)
	  for i=1,min(#list1,#list2) do
		  t[i]={list1[i], list2[i]},showtable
	  end
	  return t
  end
  
  zip3    = function(list1, list2, list3)
	  local t=setmetatable({}, showtable)
	  for i=1,min(#list1,#list2,#list3) do
		  t[i]={list1[i], list2[i], list3[i]}
	  end
	  return t
  end
  
  zipWith = function(fn, list1, list2)
	  local t=setmetatable({},showtable)
	  for i=1,min(#list1,#list2) do
		  t[i]=fn(list1[i],list2[i])
	  end
	  return t
  end
  
  zipWith3= function(fn, list1, list2,list3)
	  local t=setmetatable({},showtable)
	  for i=1,min(#list1,#list2,#list3) do
		  t[i]=fn(list1[i],list2[i],list[i])
	  end
	  return t
  end
  
  unzip   = function(list)
	  local t1,t2=setmetatable({},showtable),setmetatable({},showtable)
	  if #list==0 then return setmetatable({t1,t2},showtable) end
	  for i=1,#list do
		  t1[i]=list[i][1]
		  t2[i]=list[i][2]
	  end
	  return setmetatable({t1,t2},showtable)
  end
  
  unzip3  = function(list)
	  local t1,t2,t3=setmetatable({},showtable),setmetatable({},showtable),setmetatable({},showtable)
	  if #list==0 then return setmetatable({t1,t2,t3},showtable)end
	  for i=1,#list do
		  t1[i]=list[i][1]
		  t2[i]=list[i][2]
		  t3[i]=list[i][3]
	  end
	  return setmetatable({t1,t2,t3},showtable)
  end
  
  lines   = function(str)
	  local t=setmetatable({},showtable)
	  if str=="" then return t end
	  for i in str:gmatch("([^\n\r]*)[\n\r]?") do
		  t[#t+1]=(i~="\n" and i or "")
	  end
	  return t
  end
  
  words   = function(str)
	  local t=setmetatable({},showtable)
	  for i in str:gmatch("([^%s]*)%s?")do
		  t[#t+1] = i
	  end
	  return t
  end
  
  unlines = function(list)
	  return table.concat(list,"\n")
  end
  
  unwords = function(list)
	  return table.concat(list, " "):sub(1,-2)
  end
  
  -- show stuff shouldn't be necessary?
  
  putChar  = string.char
  
  putStr   = io.write
  
  putStrln = print
  
  --print is just print
  
  getChar  = curry(os.execute,2)('bash -c "read -n 1"')
  
  --getContents is not something i think i can do in lua. rip
  
  --not sure about interact either
  
  toUpper = function(a)
	  return string.upper(a[1])
  end
  
  toLower = function(a)
	  return string.lower(a[1])
  end
  
  -- TODO: IO