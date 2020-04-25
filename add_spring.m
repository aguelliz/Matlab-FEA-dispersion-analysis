function K = add_spring(Kbig,ks,Msprings)
%adds spring elements to matrix to Kbig
%ks is matrix (6,6,#spring element)
%Msprings is a (#springs,3) matrix, every column has #kp1 #kp2 #stiffness k

for i=1:size(Msprings,1)
         
    T1 = zeros(size(Kbig,1),3); 
    T2 = zeros(size(Kbig,1),3);
    
    for j=1:1:3
        T1((Msprings(i,1)-1)*3+j,j) = 1;
        T2((Msprings(i,2)-1)*3+j,j) = 1;
    end
    
    K = Kbig + T1*ks(1:3,1:3,i)*T1' + T2*ks(4:6,4:6,i)*T2' + T2*ks(4:6,1:3,i)*T1' +  T1*ks(1:3,4:6,i)*T2';
    Kbig = K;
    
end

end