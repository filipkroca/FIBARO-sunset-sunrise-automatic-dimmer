--[[
%% autostart
%% properties
%% weather
%% events
%% globals
--]]

if (fibaro:countScenes() > 1) then
  fibaro:abort();
end

--your dimmer ID
local dimmerDeviceId = 109;

while true do
  
sunrise = fibaro:getValue(1, "sunriseHour");
sunset = fibaro:getValue(1, "sunsetHour");
  
  
for token in string.gmatch(sunrise, "([^:]*)") do
  if(tonumber(token)) then
      
   if(sunriseHours and (not sunriseMin)) then 
        sunriseMin=tonumber(token); 
   end
      
   if(not sunriseHours) then 
        sunriseHours=tonumber(token); 
   end
      
  end
end

for token in string.gmatch(sunset, "([^:]*)") do
  if(tonumber(token)) then
      
   if(sunsetHours and (not sunsetMin)) then 
        sunsetMin=tonumber(token); 
   end
      
   if(not sunsetHours) then 
        sunsetHours=tonumber(token); 
   end
      
  end
end

--fibaro:debug('Sunrise: ' .. sunriseHours .. ':' .. sunriseMin);
--fibaro:debug('Sunset: ' .. sunsetHours .. ':' .. sunsetMin);

hours = tonumber(os.date("%H"));
mins = tonumber(os.date("%M"));

if((hours>sunriseHours and hours<sunsetHours) or (hours==sunriseHours and sunriseMin<mins) or (hours==sunsetHours and sunsetMin>mins)) then
  
  state = fibaro:getValue(dimmerDeviceId, 'value');
  if(state == "99") then
  fibaro:call(dimmerDeviceId, "turnOff");
  --fibaro:debug('day, turning off');
  else
  --fibaro:debug('day, turned off');      
  end
    
 else 
  
  state = fibaro:getValue(dimmerDeviceId, 'value');
  if(state == "0") then
  fibaro:call(dimmerDeviceId, "turnOn");
  --fibaro:debug('night, turning on');
  else
  --fibaro:debug('night, turned off');      
  end
  
end
  --run every minute
  fibaro:sleep(60000);
end

