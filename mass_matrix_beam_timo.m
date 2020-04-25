function Me = mass_matrix_beam_timo(L,A,inertia,theta,modulus,density)
%calculates the mass for a timoshenko beam, i.e. takes into account the
%shear deformation. Rectangular section

a = 1/(10*(1+0.3)/(12+11*0.3)); %for a rectangular section a = 6/5, if circular a  = 10/9
phi = 24*a*(1+0.3)*(inertia/(A*L^2));

ls = cosd(theta); ms = sind(theta);
const = (1+phi)^2;

EI=modulus*inertia; GA = modulus*A/(2*(1+0.3));
lambda = EI/(a*GA);

m1 = (13/35)+(7/10)*phi + phi^2/3; m2 = L*((11/210)+(11/120)*phi + phi^2/24); 
m3 = (9/70)+(3/10)*phi + phi^2/6; m4 = -L*((13/420)+(3/40)*phi + phi^2/24);
m5 = L^2*((1/105)+ phi/60 + phi^2/120); m6 = -L^2*(1/140 + phi/60 + phi^2/120);
m7 = 6/5; m8 = (1/10 - phi/2)*L; m9 = L^2*((2/15) + phi/6 + phi^2/3); m10 = L^2*(-1/30 - phi/6 + phi^2/6);



Mt = (density*A*L/(const)) * [const/3 0   0  const/6 0   0; 
                              0       m1  m2 0       m3  m4; 
                              0       m2  m5 0      -m4  m6; 
                              const/6 0   0  const/3 0   0; 
                              0       m3 -m4 0       m1 -m2; 
                              0       m4  m6 0      -m2  m5];
    
Mr = (density*inertia/(const*L)) * [0  0   0   0  0   0;
                                    0  m7  m8  0 -m7  m8;
                                    0  m8  m9  0 -m8  m10; 
                                    0  0   0   0  0   0;
                                    0 -m7 -m8  0  m7 -m8;                       
                                    0  m8  m10 0 -m8  m9];
                               
                        
T = [ls ms 0  0  0  0; 
    -ms ls 0  0  0  0; 
     0  0  1  0  0  0; 
     0  0  0  ls ms 0; 
     0  0  0 -ms ls 0; 
     0  0  0  0  0  1];
    
M = Mr + Mt;
  
Me = T'*M*T;
end