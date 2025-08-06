clear all
close all
clc
format short
%------------------ colorbar setting----------------------------
Ncolor=64;
lenwhite=0;
indexcolor=zeros(Ncolor*3/2-lenwhite/2,1);
for i=1:Ncolor*1.5-lenwhite/2
    indexcolor(i)=i/(Ncolor*1.5-lenwhite/2);
end
mycolor=zeros(Ncolor*3,3);
mycolor(1:Ncolor*2,1)=1;
mycolor(1+Ncolor:Ncolor*3,3)=1;
mycolor(Ncolor*1.5-lenwhite/2:Ncolor*1.5+lenwhite/2,2)=1;
mycolor(1:Ncolor*1.5-lenwhite/2,2)=indexcolor;
mycolor(1:Ncolor*1.5-lenwhite/2,3)=indexcolor;
mycolor(1+Ncolor*1.5+lenwhite/2:Ncolor*3,1)=flipud(indexcolor);
mycolor(1+Ncolor*1.5+lenwhite/2:Ncolor*3,2)=flipud(indexcolor);
mycolor=flipud(mycolor);
cvalue = 10000;
%---------------------------------------------------------------

nz = 256;
nx = 256;
max_reflectivity = 0.2;
max_image = 0.5;
max_vel = 5;
mean_vel = 3;
dh = 0.0125;

offset = [160 260]; % for profile
title_name = '6500' %'6500_80_20'
%input data contains:
%rtm image, reflectivity, smooth model, true model, and CNN output

num_shot = num2str(24);num_model = num2str(100);num_iter = num2str(1000);
% num_shot = num2str(192);num_model = num2str(94);num_iter = num2str(1000);
export_num = num2str(13);
%%%%%%%%%%%%%%%%%%%%%
% plot true and initial model as default
%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(1);
sh = 0.03;
sv = 0.02;
padding = 0.0;
margin = 0.20;

%---------------------------------------------------------------

% input real test data:
%     input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0.dat']);
orig_data = dlmread(['24shots_result_generate_1th_FWI_model' '/' 'real_outputs' title_name '/real0_vp.dat']);
orig_rtm_image    = orig_data(1+nz*nx*0:nz*nx*1);orig_rtm_image = reshape(orig_rtm_image,nz,nx);

train_model1 = dlmread(['24shots_result_generate_' num2str(1) 'th_FWI_model' '/' 'train_outputs' title_name '/export' export_num '_vp.dat']);
CNN_train1   = train_model1(1+nz*nx*0:nz*nx*1);CNN_train1 = reshape(CNN_train1,nz,nx);

train_model2 = dlmread(['24shots_result_generate_' num2str(2) 'th_FWI_model' '/' 'train_outputs' title_name '/export' export_num '_vp.dat']);
CNN_train2   = train_model2(1+nz*nx*0:nz*nx*1);CNN_train2 = reshape(CNN_train2,nz,nx);

train_model3 = dlmread(['24shots_result_generate_' num2str(3) 'th_FWI_model' '/' 'train_outputs' title_name '/export' export_num '_vp.dat']);
CNN_train3   = train_model3(1+nz*nx*0:nz*nx*1);CNN_train3 = reshape(CNN_train3,nz,nx);

train_model4 = dlmread(['24shots_result_generate_' num2str(15) 'th_FWI_model' '/' 'train_outputs' title_name '/export' export_num '_vp.dat']);
CNN_train4   = train_model4(1+nz*nx*0:nz*nx*1);CNN_train4 = reshape(CNN_train4,nz,nx);
% 
% pred_model1 = dlmread(['24shots_result_generate_' num2str(1) 'th_FWI_model' '/' 'real_outputs' title_name '/real' export_num '_vp.dat']);
% CNN_test1   = pred_model1(1+nz*nx*0:nz*nx*1);CNN_test1 = reshape(CNN_test1,nz,nx);
% 
% pred_model2 = dlmread(['24shots_result_generate_' num2str(5) 'th_FWI_model' '/' 'real_outputs' title_name '/real' export_num '_vp.dat']);
% CNN_test2   = pred_model2(1+nz*nx*0:nz*nx*1);CNN_test2 = reshape(CNN_test2,nz,nx);
% 
% pred_model3 = dlmread(['24shots_result_generate_' num2str(6) 'th_FWI_model' '/' 'real_outputs' title_name '/real' export_num '_vp.dat']);
% CNN_test3   = pred_model3(1+nz*nx*0:nz*nx*1);CNN_test3 = reshape(CNN_test3,nz,nx);

    % Plot the True and Initial velocity models
subaxis(4, 2, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train1)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.0','1.2','2.4'}) 
axis equal; colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
ylabel('Depth (km)');
rms_error=R2(orig_rtm_image,CNN_train1); 
text(83.2955390334572, 256.815985130112,['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(108.946096654275, 218.340148698885,['1th training RTM image'])
disp(['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(-102.671003717472, -68.0910780669145,'a)') %get from the code of figure
% line([offset(1) offset(1)], [1 nz],'Color','r','LineWidth',2);hold on;
% line([offset(2) offset(2)], [1 nz],'Color','r','LineWidth',2);hold on;

% Plot the True and Initial velocity models
subaxis(4, 2, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train2)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
set(gca, 'YTick', [])          
set(gca,'YTickLabel',{}) 
axis equal; colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
%     ylabel('Depth (km)');
rms_error=R2(orig_rtm_image,CNN_train2); 
text(83.2955390334572, 256.815985130112,['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(108.946096654275, 218.340148698885,['5th training RTM image'])
disp(['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(-25.7193308550187, -68.0910780669145,'b)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(4, 2, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train3)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.0','1.2','2.4'}) 
axis equal; colormap('gray');
%     xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
ylabel('Depth (km)');
rms_error=R2(orig_rtm_image,CNN_train3); 
text(83.2955390334572, 256.815985130112,['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(160.247211895911, 218.340148698885,['6th training RTM image'])
disp(['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(-102.671003717472, -19.9962825278811,'c)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 2, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train4)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{}) 
set(gca, 'YTick', [])            
set(gca,'YTickLabel',{}) 
axis equal; colormap('gray');
%     xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
%     ylabel('Depth (km)');
rms_error=R2(orig_rtm_image,CNN_train4); 
text(83.2955390334572, 256.815985130112,['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(138.871747211896, 218.340148698885,['15th training RTM image'])
disp(['Correlation coefficient =  ' num2str(rms_error, '%4.2f')])
text(-25.7193308550187, -19.9962825278811,'d)') %get from the code of figure

    