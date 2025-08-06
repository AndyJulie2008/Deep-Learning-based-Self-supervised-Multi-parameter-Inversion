% run this code only after running FWI plot code
close all;
for k = 1:-0.01:0.2
sign_rtm = zeros(nz,nx);
for i = 1:nz
    for j = 1:nx
        if rtm_image_vz(i,j) > k
            sign_rtm(i,j) = 1;
        end
    end
end


imagesc(reflectivity+10*sign_rtm);title(num2str(k))
caxis([-.1 .1]);drawnow;pause(0.05);
end