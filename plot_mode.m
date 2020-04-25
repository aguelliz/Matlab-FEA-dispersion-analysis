function []=plot_mode(mode,freq,coord,nel_vec,mux,muy,Ncon,con_kp,T_kp,factor)
%plots deformed shape modes of the magnets square structure
%coordinates of keypoints
%nel_vec vector with the number elements per beam
%muy mux wavelenth
%Ncon connectivity matrix
%con_kp keypoint connectivity matrix
%keypoint transfer matrix
%factor magnifiying factor

nl = size(con_kp,1);
nkp = max(max(con_kp));
q=0; %counts elements
%calculate coordinates of all nodes
for r = 1:nl
    for n = 1:nel_vec(r)-1
    coord(nkp+n+q,:) = [(coord(con_kp(r,2),1)-coord(con_kp(r,1),1))*n/nel_vec(r)+coord(con_kp(r,1),1) (coord(con_kp(r,2),2)-coord(con_kp(r,1),2))*n/nel_vec(r)+coord(con_kp(r,1),2)];
    end
    q=q+n;
end

%plot undeformed structure
for npl = 1:1:4
subplot(2,2,npl)
calc = freq(npl);
srt = sprintf('freq = %g Hz',calc);
title(srt);
hold on
    for lines = 1:size(Ncon,1)
        subplot(2,2,npl), plot([coord(Ncon(lines,1),1) coord(Ncon(lines,2),1)], [coord(Ncon(lines,1),2) coord(Ncon(lines,2),2)],'k')
    end

end

T = build_T(T_kp,mux,muy,Ncon);
%first 4 mode shapes
for npl = 1:1:4
modes_full = T*mode(:,npl);
modes_real = factor*real(modes_full);


    for k = 1:size(coord,1)
        coord_real(k,1) = coord(k,1) + modes_real((k-1)*3+1,1);
        coord_real(k,2) = coord(k,2) + modes_real((k-1)*3+2,1);
    end

subplot(2,2,npl)
hold on
    for lines = 1:1:size(Ncon,1)
        subplot(2,2,npl), plot([coord_real(Ncon(lines,1),1) coord_real(Ncon(lines,2),1)], [coord_real(Ncon(lines,1),2) coord_real(Ncon(lines,2),2)],'b')
    end

end