function [nkp,kp,nl,con_kp,prop_line,npm,Mp,vec_mp,nsprings,Msprings,T_kp,nwl]=input_for_FEA()

nkp = input('number of keypoints ');

for i = 1:nkp
    str = sprintf('coordinate of keypoint number %i x = ',i);
    kp(i,1) = input(str);
    str = sprintf('coordinate of keypoint number %i y = ',i);
    kp(i,2) = input(str);
end

nl = input('number of lines ');

for i = 1:nl
    str = sprintf('line %i from keypoint number = ',i);
    con_kp(i,1) = input(str);
    str = sprintf('line %i to keypoint number = ',i);
    con_kp(i,2) = input(str);
    str = sprintf('Area of line %i = ',i);
    prop_line(i,1) = input(str);
    str = sprintf('Moment of inertia of line %i = ',i);
    prop_line(i,2) = input(str);
    str = sprintf('Youngs modulus %i = ',i);
    prop_line(i,3) = input(str);
    str = sprintf('density %i = ',i);
    prop_line(i,4) = input(str);
    str = sprintf('number of elements of line %i = ',i);
    prop_line(i,5) = input(str);
end

npm = input('number of punctual mass ');
if npm>0
    Mp=(zeros(3,3,npm));
else
    Mp=0;
end

for i = 1:npm
    str = sprintf('keypoint where mass %i is located = ',i);
    vec_mp(i) = input(str);
    str = sprintf('mass %i = ',i);
    Mp(1,1,i) = input(str);
    Mp(2,2,i) = Mp(1,1,i);
    str = sprintf('inertial moment of mass %i (units ML^2) = ',i);
    Mp(3,3,i) = input(str);
end

nsprings = input('number of linear springs ');
if npm>0
Msprings=(zeros(3,nsprings));
else
Msprings=0;
end

for i = 1:nsprings
    str = sprintf('constant k of srping %i = ',i);
    Msprings(i,3) = input(str);
    str = sprintf('keypoint 1 of spring %i = ',i);
    Msprings(i,1) =input(str);
    str = sprintf('keypoint 2 of spring %i = ',i);
    Msprings(i,2) =input(str);
end

nslaves = input('number of keypoints in the boundary to couple ');

for i = 1:nslaves
    str = sprintf('Slave keypoint number %i = ',i);
    T_kp(i,2) = input(str);
    str = sprintf('Master Keypoint number %i = ',i);
    T_kp(i,1) = input(str);
    str = sprintf('Located at? 1 for rx, 2 for ry, 3 for rx+ry %i = ',i);
    T_kp(i,3) = input(str);
end

nwl = input('number of points to discretize ');


end
