function ks = stiffness_spring_matrix(k,theta)
%calculates the stiffness matrix of a spring element
%k is the linear stiffness of the spring
%theta is the angle of the spring elements

K = zeros(6,6);
K(1,1)=k; K(1,4)=-k; K(4,1)=-k; K(4,4)=k;


ls = cosd(theta); ms = sind(theta);

T = [ls ms 0  0  0  0; 
    -ms ls 0  0  0  0; 
     0  0  1  0  0  0; 
     0  0  0  ls ms 0; 
     0  0  0 -ms ls 0; 
     0  0  0  0  0  1];
 
 ks = T'*(K)*T;

end
