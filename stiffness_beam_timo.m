function ke = stiffness_beam_timo(L,A,inertia,theta,modulus)
% Generates equations for a timoshenko beam element
% modulus = modulus of elasticity
% inertia = moment of inertia
% A = area of cross-section
% theta = angle
% L = length

a = 1/(10*(1+0.3)/(12+11*0.3)); %for a rectangular section a = 6/5, if circular a  = 10/9
phi = 24*a*(1+0.3)*(inertia/(A*L^2));

EI=modulus*inertia; EA = modulus*A; GA = modulus*A/(2*(1+0.3));


lambda = EI/(a*GA);
const = (1 + lambda * 12 / L^2);

K = [EA/L 0                  0                             -EA/L 0                    0;
     0    12*EI/(const*L^3)  6*EI/(const*L^2)               0   -12*EI/(const*L^3)    6*EI/(const*L^2);
     0    6*EI/(const*L^2)  (4+12*lambda/L^2)*EI/(L*const)  0   -6*EI/(const*L^2)    (2-12*lambda/L^2)*EI/(L*const);
    -EA/L 0                  0                              EA/L 0                    0;
     0   -12*EI/(const*L^3) -6*EI/(const*L^2)               0    12*EI/(const*L^3)   -6*EI/(const*L^2);
     0    6*EI/(const*L^2)  (2-12*lambda/L^2)*EI/(L*const)  0   -6*EI/(const*L^2)    (4+12*lambda/L^2)*EI/(L*const)];

ls = cosd(theta); ms = sind(theta);

T = [ls ms 0  0  0  0; 
    -ms ls 0  0  0  0; 
     0  0  1  0  0  0; 
     0  0  0  ls ms 0; 
     0  0  0 -ms ls 0; 
     0  0  0  0  0  1];
 
 ke = T'*(K)*T;
end
