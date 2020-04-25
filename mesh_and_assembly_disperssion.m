function [Kbig,Mbig,Ncon] = mesh_and_assembly_disperssion(ke,me,con_kp,nel_vec)
%generates the connectivity matrix for the nodes
%ke is a 6 by 6 by #lines matrix ke(:,:,nl) is the stiffness matrix for the element belonging to line nl
%me is a 6 by 6 by #lines matrix ke(:,:,nl) is the mass matrix for the element belonging to line nl
%con_kp is the keypoint connectivity matrix
%nel_vec is a vector of length nl with the number of elements per line

Nel = sum(nel_vec);
[nl a] = size(con_kp);


elem_vec = zeros(1,length(nel_vec));
for j = 1:length(nel_vec) %create a vector with the cumulative number of elements
    elem_vec(j) = sum(nel_vec(1:j)); 
end

Ncon = zeros(Nel,2); %creating nodal conectivity matrix

Ncon(1,1) = con_kp(1,1); 
for i = 1:1:nl-1
    Ncon(elem_vec(i),2) = con_kp(i,2); %assigning keypoints to nodal conectivity
    Ncon(elem_vec(i)+1,1) = con_kp(i+1,1);
end
Ncon(Nel,2) = con_kp(nl,2);


nmax = max(max(con_kp));
Ke = zeros(6*Nel,6);
Me = zeros(6*Nel,6);
%create a matrix Ke and Me with stiffness of each elemen as [ke1;ke2..]
%and the matrix of each element as [me1;me2...]

for i = 1:1:Nel 
   if Ncon(i,1) == 0
       Ncon(i,1) = nmax;
       if Ncon(i,2) == 0
           Ncon(i,2) = nmax+1;
           nmax = nmax+1;
       else
       end
   else
       if Ncon(i,2) == 0
           Ncon(i,2) = nmax+1;
           nmax = nmax+1;
       else
       end
   end
elem_line = find(i<=elem_vec);
Ke(6*(i-1)+1:6*i,:) = ke(:,:,elem_line(1));
Me(6*(i-1)+1:6*i,:) = me(:,:,elem_line(1));

end


nn = max(max(Ncon));
Kbig = assembly(Nel,nn,3,Ke,Ncon);
Mbig = assembly(Nel,nn,3,Me,Ncon);

end

function K = assembly(ne,nn,nd,ke,con)
%ne number of elements
%nn number of nodes
%nd number of degrees of freedom
%ke stiffness of each elemen as [ke1;ke2..]
%con connectivity matrix

Kbig = zeros(nd*nn,nd*nn);

for i=1:1:ne
    
    T1 = zeros(nd*nn,nd); 
    T2 = zeros(nd*nn,nd);
    
    for j=1:1:nd
        T1((con(i,1)-1)*nd+j,j) = 1;
        T2((con(i,2)-1)*nd+j,j) = 1;
    end
    
    K = Kbig + T1*ke((i-1)*2*nd+1:(i-1)*2*nd+nd,1:nd)*T1' + T2*ke((i-1)*2*nd+1+nd:(i-1)*2*nd+2*nd,nd+1:2*nd)*T2' + T2*ke((i-1)*2*nd+1+nd:(i-1)*2*nd+2*nd,1:nd)*T1' +  T1*ke((i-1)*2*nd+1:(i-1)*2*nd+nd,nd+1:2*nd)*T2';
    Kbig = K;
    
end

end
