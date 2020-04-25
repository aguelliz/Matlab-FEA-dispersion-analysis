function T = build_T(T_kp,mux,muy,Ncon)
%builds transformation matrix
%T_kp is the keypoint coupling matrix
%builds a matrix to transform the global coordinates to reduced coordinates
%T_kp is the keypoint transformation matrix expressed as [#kpM #kpS #coup], 
%so, kpS = exp(i*mx)*kpM if coup=1, kpS = exp(i*my)*kpM if coup = 2, and 
%kpS = exp(i*(my+mx))*kpM if coup = 3
nn=max(max(Ncon));
nd=3;

[a,b] = sort(T_kp(:,2));
T_kp = T_kp(b,:); %sorting matrix coup

ncoup = size(T_kp,1);
T = zeros(nn*nd,nn*nd-nd*ncoup);
T1 = zeros(nn*nd,nn*nd);

vec = T_kp(:,2);
q = 1; %counts coupled nodes

%create T1
for r = 1:nn
   if q>ncoup
      T1(3*(r-1)+1,3*(r-1)+1) = 1;
      T1(3*(r-1)+2,3*(r-1)+2) = 1;
      T1(3*(r-1)+3,3*(r-1)+3) = 1;
   else        
        if r~=vec(q)
           T1(3*(r-1)+1,3*(r-1)+1) = 1;
           T1(3*(r-1)+2,3*(r-1)+2) = 1;
           T1(3*(r-1)+3,3*(r-1)+3) = 1;
        elseif r == vec(q)
            if T_kp(q,3)==1
            val = exp(1i*mux);
            elseif T_kp(q,3)==2
            val = exp(1i*muy);
            elseif T_kp(q,3)==3
            val = exp(1i*(muy+mux));
            else
            val=1;
            end
           T1(3*(r-1)+1,3*(T_kp(q,1)-1)+1) = val;
           T1(3*(r-1)+2,3*(T_kp(q,1)-1)+2) = val;
           T1(3*(r-1)+3,3*(T_kp(q,1)-1)+3) = val;
           q = q+1;
        end
  end
end

%remove columns from T1
q=1; %counts removed columns
for r = 1:nn
    if q>ncoup
      T(:,3*(r-q)+1) = T1(:,3*(r-1)+1);
      T(:,3*(r-q)+2) = T1(:,3*(r-1)+2);
      T(:,3*(r-q)+3) = T1(:,3*(r-1)+3);
    else        
        if r~=vec(q)
          T(:,3*(r-q)+1) = T1(:,3*(r-1)+1);
          T(:,3*(r-q)+2) = T1(:,3*(r-1)+2);
          T(:,3*(r-q)+3) = T1(:,3*(r-1)+3);
        elseif r == vec(q)
           q = q+1;
        end
    end
end

end