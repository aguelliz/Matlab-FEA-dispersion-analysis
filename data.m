%keypoints
nkp = 5; %number of keypoints
kp = [0 0
      0 5
      5 0
      0 -5
     -5 0]; %coordinates of each keypoint x y
 
 %lines
 nl = 4; %number of lines
 con_kp =[1 2
          1 3 
          1 4
          1 5]; %connectivity matrix of keypoints
 d=1; %thickness of beam
 E = 0.61; %youngs modulus
 ro = 1e-9; %density
 ne =10; %number of elements
 prop_line =[d d^3/12 E ro ne
             d d^3/12 E ro ne
             d d^3/12 E ro ne
             d d^3/12 E ro ne]; %property of each line [area, moment of inertia, modulus, density, number of elements]
         
 %puntual mass
 npm = 1; %number of puntual mass
 m = 1e-8;
 vec_mp = [1];% node where each punctual mass is located
 I=0;
 Mp(:,:,1)=[m 0 0
            0 m 0
            0 0 0];%Mp (3,3,npm) [mass 0 0; 0 mass 0; 0 0 inertia] of each punctual mass
  
  %springs
  nsprings = 1; %number of linear springs
  k = 0.1; %stiffness of each spring
  Msprings = [2 3 k]; %(nsprings,3) [kp1 kp2 k]
  
  %Boundary condition
  T_kp = [4 2 2
          5 3 1]; %coupling matrix [master kp, slave kp, num] num=1 if rx, num=2 if ry, num=3 if ry+rx
    
  %discretization
  nwl = 20; %number of iterations or discretization per branch of the brillouin zone
