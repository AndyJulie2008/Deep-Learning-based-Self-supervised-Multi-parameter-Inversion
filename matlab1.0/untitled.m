stat_to_image_true_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_image_true_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2

figure(1)
for i = 1 : num_folder
    disp(i)
    folder_name = ['../CNN_approximation1.0/24shots_result_generate_1th_FWI_model' '/' 'real_outputs6500' '/real0_vp.dat']
    orig_data = dlmread(folder_name);
    orig_rtm_image = orig_data(1+nz*nx*0:nz*nx*1);orig_rtm_image = reshape(orig_rtm_image,nz,nx);
    
    folder_name = ['../CNN_approximation1.0/inversion_dataset6500/CNN_inversion_dataset' num2str(i) '.dat'];
    pred_model = dlmread(folder_name);
    CNN_inversion   = pred_model(1+nz*nx*0:nz*nx*1);CNN_inversion = reshape(CNN_inversion,nz,nx);
    
    subplot(1,2,1);imagesc(orig_rtm_image);colormap('gray');
    subplot(1,2,2);imagesc(CNN_inversion);colormap('gray');
    drawnow;pause(0.2);
    stat_to_image_true_RMS_CNN(1,i) = RMS(orig_rtm_image,CNN_inversion);
%     stat_to_image_true_R2_CNN(1,i) = R2(orig_rtm_image,CNN_inversion)

end
