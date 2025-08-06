stop %carefully use this tool!
%find the specific feature
for i = 1 : num_feature_layers
    a = reshape(segmented_layer(:,i),nz,nx);
    if a(38,1) ~= 0
        disp(i)
    end
end

error = segmented_layer(:,9);
error = reshape(error,nz,nx);
error(:,15:nx)=0;error = reshape(error,nz*nx,1);


segmented_layer(:,9)= segmented_layer(:,9)-error;
segmented_layer(:,10)= segmented_layer(:,10)-error;
segmented_layer(:,13)= segmented_layer(:,13)+error;

figure(1)
show2d(segmented_layer(:,9),nz,nx);

figure(2)
show2d(segmented_layer(:,10),nz,nx);

figure(3)
show2d(segmented_layer(:,13),nz,nx);


figure(4)
show2d(error,nz,nx)
