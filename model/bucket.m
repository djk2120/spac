function [swp1,sm1] = bucket( swp0,q,zr )
%bucket Simplified bucket model
%   inputs
%     swp0  , original soil water potential [MPa]
%     q     , sap flux                      [mm/s]
%     zr    , rooting depth                 [m]
%
%   this is currently set up for half hour timesteps

q  = q/1e3;    % convert from mm/s to m/s 
dt = 1800;     % seconds


b = 5;
psat  = -.003;
smsat = 0.5;

sm0   = smsat*(swp0/psat)^(-1/b);
sm1   = sm0-q*dt/zr;

swp1  = psat*(sm1/smsat)^-b;

end