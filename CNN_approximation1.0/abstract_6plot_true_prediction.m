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
cvalue = 0.6;
%---------------------------------------------------------------

nz = 256;
nx = 256;
max_reflectivity = 0.2;
max_image = 0.5;
max_vel = 5;
mean_vel = 3;
dh = 0.0152;

offset = [80 160]; % for profile

%input data contains:
%rtm image, reflectivity, smooth model, true model, and CNN output

num_shot = num2str(24);num_model = num2str(100);num_iter = num2str(1000);
% num_shot = num2str(192);num_model = num2str(94);num_iter = num2str(1000);
export_num = num2str(0);
%%%%%%%%%%%%%%%%%%%%%
% plot true and initial model as default
%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(1);
sh = 0.025;
sv = 0.00;
padding = 0.0;
margin = 0.2;

%---------------------------------------------------------------
title_name = '6500_80_20'

% input real test data:
%     input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0_vp.dat']);
orig_data = dlmread(['24shots_result_generate_1th_FWI_model' '/' 'real_outputs' title_name '/real0_vp.dat'])/1000;
orig_vp_true = orig_data(1+nz*nx*2:nz*nx*3);orig_vp_true = reshape(orig_vp_true,nz,nx);
orig_vp_smooth    = orig_data(1+nz*nx*1:nz*nx*2);orig_vp_smooth = reshape(orig_vp_smooth,nz,nx);

train_model1 = dlmread(['24shots_result_generate_' num2str(1) 'th_FWI_model' '/' 'train_outputs' title_name '/export13_vp.dat'])/1000;
CNN_train1   = train_model1(1+nz*nx*3:nz*nx*4);CNN_train1 = reshape(CNN_train1,nz,nx);

train_model2 = dlmread(['24shots_result_generate_' num2str(5) 'th_FWI_model' '/' 'train_outputs' title_name '/export13_vp.dat'])/1000;
CNN_train2   = train_model2(1+nz*nx*3:nz*nx*4);CNN_train2 = reshape(CNN_train2,nz,nx);

train_model3 = dlmread(['24shots_result_generate_' num2str(6) 'th_FWI_model' '/' 'train_outputs' title_name '/export13_vp.dat'])/1000;
CNN_train3   = train_model3(1+nz*nx*3:nz*nx*4);CNN_train3 = reshape(CNN_train3,nz,nx);

train_model4 = dlmread(['24shots_result_generate_' num2str(15) 'th_FWI_model' '/' 'train_outputs' title_name '/export13_vp.dat'])/1000;
CNN_train4   = train_model4(1+nz*nx*3:nz*nx*4);CNN_train4 = reshape(CNN_train4,nz,nx);

pred_model1 = dlmread(['24shots_result_generate_' num2str(1) 'th_FWI_model' '/' 'real_outputs' title_name '/real0_vp.dat'])/1000;
CNN_test1   = pred_model1(1+nz*nx*3:nz*nx*4);CNN_test1 = reshape(CNN_test1,nz,nx);

pred_model2 = dlmread(['24shots_result_generate_' num2str(5) 'th_FWI_model' '/' 'real_outputs' title_name '/real0_vp.dat'])/1000;
CNN_test2   = pred_model2(1+nz*nx*3:nz*nx*4);CNN_test2 = reshape(CNN_test2,nz,nx);

pred_model3 = dlmread(['24shots_result_generate_' num2str(6) 'th_FWI_model' '/' 'real_outputs' title_name '/real0_vp.dat'])/1000;
CNN_test3   = pred_model3(1+nz*nx*3:nz*nx*4);CNN_test3 = reshape(CNN_test3,nz,nx);

pred_model4 = dlmread(['24shots_result_generate_' num2str(15) 'th_FWI_model' '/' 'real_outputs' title_name '/real0_vp.dat'])/1000;
CNN_test4   = pred_model4(1+nz*nx*3:nz*nx*4);CNN_test4 = reshape(CNN_test4,nz,nx);

    % Plot the True and Initial velocity models
subaxis(2, 4, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train1)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/2 nx])            
set(gca,'XTickLabel',{'0.0','1.9','3.9'}) 
set(gca, 'YTick', [1 nx/2 nx])            
set(gca,'YTickLabel',{'0.0','1.9','3.9'}) 
axis equal; %colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
ylabel('Depth (km)');
rms_error=RMS(orig_vp_true,CNN_train1); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-100.79435483871, -72.0040322580646,'a)') %get from the code of figure
% line([offset(1) offset(1)], [1 nz],'Color','r','LineWidth',2);hold on;
% line([offset(2) offset(2)], [1 nz],'Color','r','LineWidth',2);hold on;

% Plot the True and Initial velocity models
subaxis(2, 4, 5, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_test1)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{}) 
set(gca, 'YTick', [1 nx/2 nx])            
set(gca,'YTickLabel',{'0.0','1.9','3.9'}) 
axis equal; %colormap('gray');
% xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
ylabel('Depth (km)');
rms_error=RMS(orig_vp_true,CNN_test1); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(47.2701612903226, 324.891129032259,['1st iteration'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-100.79435483871, -19.9962825278811,'e)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(2, 4, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train2)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/2 nx])            
set(gca,'XTickLabel',{'0.0','1.9','3.9'}) 
set(gca, 'YTick', [])          
set(gca,'YTickLabel',{}) 
axis equal; %colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
rms_error=RMS(orig_vp_true,CNN_train2); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% text(2.03658536585374, 279.649193548387,['5th training model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -72.0040322580646,'b)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(2, 4, 6, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_test2)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{}) 
set(gca, 'YTick', [])            
set(gca,'YTickLabel',{}) 
axis equal; %colormap('gray');
%     xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
%     ylabel('Depth (km)');
rms_error=RMS(orig_vp_true,CNN_test2); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(47.2701612903226, 324.891129032259,['5th iteration'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'f)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(2, 4, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train3)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/2 nx])            
set(gca,'XTickLabel',{'0.0','1.9','3.9'}) 
set(gca, 'YTick', [])          
set(gca,'YTickLabel',{}) 
axis equal; %colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
rms_error=RMS(orig_vp_true,CNN_train3); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% text(2.03658536585374, 279.649193548387,['6th training model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -72.0040322580646,'c)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(2, 4, 7, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_test3)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{}) 
set(gca, 'YTick', [])            
set(gca,'YTickLabel',{}) 
axis equal; %colormap('gray');
%     xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
%     ylabel('Depth (km)');
rms_error=RMS(orig_vp_true,CNN_test3); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(47.2701612903226, 324.891129032259,['6th iteration'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'g)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(2, 4, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train4)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/2 nx])            
set(gca,'XTickLabel',{'0.0','1.9','3.9'}) 
set(gca, 'YTick', [])          
set(gca,'YTickLabel',{}) 
axis equal; %colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
rms_error=RMS(orig_vp_true,CNN_train4); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% text(2.03658536585374, 279.841463414634,['15th training model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -72.0040322580646,'d)') %get from the code of figure
h=text(294.987603305785, 250.731404958677,'Training model')
set(h,'Rotation',90);


% Plot the True and Initial velocity models
subaxis(2, 4, 8, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_test4)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{})  
set(gca, 'YTick', [])            
set(gca,'YTickLabel',{})  
axis equal; %colormap('gray');
%     xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1.5 4.5]);  
%     ylabel('Depth (km)');
rms_error=RMS(orig_vp_true,CNN_test4); 
text(2.03658536585374, 279.841463414634,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(34.9314516129034, 324.891129032259,['15th iteration'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'h)') %get from the code of figure
h=text(294.987603305785, 250.731404958677,'Predicted model')
set(h,'Rotation',90);

c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Velocity (km/s)';
set(colorTitleHandle ,'String',titleString);
set(c,'YTick',[1.5,2.5,3.5,4.5])
set(c,'YTickLabels',{'1.5','2.5','3.5','4.5'})
set(c,'Position',[0.839642730765342 0.252129471890971 0.0149220250732999 0.477001703577513]) %get from the code of figure

    
    
    
    
    
    
%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(2);
sh = 0.03;
sv = 0.02;
padding = 0.0;
margin = 0.20;

%---------------------------------------------------------------
depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines

subaxis(2, 4, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*1; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train1(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test1(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
text(-0.291735537190083, -0.48190780669145,'a)')
%legend('True model','Output model')

subaxis(2, 4, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(0.875882352941176, -0.48190780669145,'b)')

subaxis(2, 4, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(0.875882352941176, -0.48190780669145,'c)')

subaxis(2, 4, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train4(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test4(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(0.875882352941176, -0.48190780669145,'d)')
h=text(5.41352941176471, 3.1491405204461,'Velocity profile at 1.0 km')
set(h,'Rotation',90);

subaxis(2, 4, 5, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*1; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train1(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test1(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
text(-0.291735537190083, 0.00799553903345673,'e)')
%legend('True model','Output model')
text(1.8, 4.15776505576208, '1st iteration')

subaxis(2, 4, 6, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(0.875882352941176, 0.00799553903345673,'f)')
text(1.8, 4.15776505576208, '5th iteration')

subaxis(2, 4, 7, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(0.875882352941176, 0.00799553903345673,'g)') 
text(1.8, 4.15776505576208, '6th iteration')

subaxis(2, 4, 8, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'k--','LineWidth',1.5);hold on;
plot(CNN_train4(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test4(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh])  
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(0.875882352941176, 0.00799553903345673,'h)') 
text(1.8, 4.15776505576208, '15th iteration')
h=text(5.41352941176471, 3.1491405204461,'Velocity profile at 2.0 km')
set(h,'Rotation',90);