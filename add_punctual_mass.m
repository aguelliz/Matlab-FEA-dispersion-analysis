function M = add_punctual_mass(Mbig,Mp,vec_mp)
%adds punctual mass matrix to Mbig
%Mp is matrix (3,3,#puntual masses)
%vec_mp is a vector with the keypoints where every mass is located

for i=1:size(vec_mp)
         
    T1 = zeros(size(Mbig,1),3); 
   
    for j=1:1:3
        T1((vec_mp(i)-1)*3+j,j) = 1;
    end
    
    M = Mbig + T1*Mp(:,:,i)*T1';
    Mbig = M;
    
end

end