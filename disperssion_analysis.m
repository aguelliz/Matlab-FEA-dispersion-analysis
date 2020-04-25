%disperssion analysis
omega1 = 1; %frequency to normalize

%input of data

%input data using the input menu (long)
%[nkp,kp,nl,con_kp,prop_line,npm,Mp,vec_mp,nsprings,Msprings,T_kp,nwl] = input_for_FEA();

%or write data in the data file
data

%nkp number of keypoints
%kp coordinates of each keypoint x y
%con_kp connectivity matrix of keypoints
%prop_line [area, moment of inertia, modulus, density, number of elements]
%npm number of puntual mass
%Mp (3,3,npm) [mass 0 0; 0 mass 0; 0 0 inertia] of each punctual mass
%vec_mp vector with kp number where each puctual mass is located 
%nsprings number of springs
%Mspring (nsprings,3) [kp1 kp2 k]
%T_kp coupling matrix [master kp, slave kp, num] num=1 if rx, num=2 if ry, num=3 if ry+rx
%nwl number of iterations or discretization per branch of the brillouin zone

%build stiffness and mass matrix of each element

for i =1:nl
    L = sqrt((kp(con_kp(i,1),1)-kp(con_kp(i,2),1))^2+(kp(con_kp(i,1),2)-kp(con_kp(i,2),2))^2);
    theta = asind((kp(con_kp(i,2),2)-kp(con_kp(i,1),2))/L);
    if theta>=0&&theta~=90
        if (kp(con_kp(i,2),1)-kp(con_kp(i,1),1))>0
        else
            theta=theta+180;
        end
    elseif theta<0&&theta~=-90
        if (kp(con_kp(i,2),1)-kp(con_kp(i,1),1))>0
        else
            theta=theta+180;
        end
    else
    end
    ke(:,:,i)=stiffness_beam_timo(L/prop_line(i,5),prop_line(i,1),prop_line(i,2),theta,prop_line(i,3));
    me(:,:,i)=mass_matrix_beam_timo(L/prop_line(i,5),prop_line(i,1),prop_line(i,2),theta,prop_line(i,3),prop_line(i,4));
    nel_vec(i)=prop_line(i,5);
end

[Kbig,Mbig,Ncon] = mesh_and_assembly_disperssion(ke,me,con_kp,nel_vec);

%stiffness matrix of springs
for i =1:nsprings
    L = sqrt((kp(Msprings(i,1),1)-kp(Msprings(i,2),1))^2+(kp(Msprings(i,1),2)-kp(Msprings(i,2),2))^2);
    theta = asind((kp(Msprings(i,2),2)-kp(Msprings(i,1),2))/L);
    if theta>=0&&theta~=90
        if (kp(Msprings(i,2),1)-kp(Msprings(i,1),1))>0
        else
            theta=theta+180;
        end
    elseif theta<0&&theta~=-90
        if (kp(Msprings(i,2),1)-kp(Msprings(i,1),1))>0
        else
            theta=theta+180;
        end
    else
    end
    ks(:,:,i)=stiffness_spring_matrix(Msprings(i,3),theta);
end

%adding punctual mass to Mass matrix
if npm>0
    M = add_punctual_mass(Mbig,Mp,vec_mp);
else
    M = Mbig;
end

%adding springs to stiffness matrix

if nsprings>0
    K = add_spring(Kbig,ks,Msprings);
else
    K = Kbig;
end

%Brillouin zone for cubic symetry
muy(1,1:nwl) = linspace(0,0,nwl);
muy(1,nwl:2*nwl-1) = linspace(0,pi,nwl);
muy(1,2*nwl-1:3*nwl-2) = linspace(pi,0,nwl);
mux(1,1:nwl) = linspace(0,pi,nwl);
mux(1,nwl:2*nwl-1) = linspace(pi,pi,nwl);
mux(1,2*nwl-1:3*nwl-2) = linspace(pi,0,nwl);

%obtain modes for each wave vector
for r = 1:1:length(muy)
    
T = build_T(T_kp,mux(r),muy(r),Ncon);

Kr = T'*K*T;
Mr = T'*M*T;
[modes(:,:,r),omg_sq] = eig(Kr,Mr,'qz');
freq(:,:,r) = sqrt(omg_sq)/(2*pi);

   
    for n_iter = 1:length(freq)
     vec_freq(n_iter,r) = freq(n_iter,n_iter,r);
    end

end

%sort modes
for i = 1:1:length(muy)
[freq_so(:,i) order]=sort(vec_freq(:,i));
modes_so(:,:,i)=modes(:,order,i);
end
vec = 1:1:length(muy);

%plot dispersion curves
plot(vec,freq_so(1,:)/omega1)
hold on
plot(vec,freq_so(2,:)/omega1)
plot(vec,freq_so(3,:)/omega1)
plot(vec,freq_so(4,:)/omega1)
plot(vec,freq_so(5,:)/omega1)
plot(vec,freq_so(6,:)/omega1)
plot(vec,freq_so(7,:)/omega1)
plot(vec,freq_so(8,:)/omega1)

figure() %plot first 4 modes when kx*r=0 ky*r=0
plot_mode(modes_so(:,:,1),freq_so(:,1),kp,nel_vec,mux(1),muy(1),Ncon,con_kp,T_kp,1)
figure() %plot first 4 modes when kx*r=pi ky*r=pi
plot_mode(modes_so(:,:,2*nwl),freq_so(:,2*nwl),kp,nel_vec,mux(2*nwl),muy(2*nwl),Ncon,con_kp,T_kp,1)


