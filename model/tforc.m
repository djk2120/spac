function tmax = tforc(tmax_max,hh)
%%tforc: provides tmax forcing data on a sub-daily time scale 
%tmax = tforc(tmax_max,hh)
% Inputs
%   tmax_max = midday maximum transpiration (mm/s)
%   hh       = time of day (hour, 0-24)
% Output
%   tmax     = maximum transpiration (mm/s)

pi_factor = pi/(18-5.5); %sets an appropriate period for the sine wave

tmax = max(0,tmax_max*sin((hh-5.5)*pi_factor));


end