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
file_title = '6500'; %'6500_80_20';

%%%%%%%%%%%%%%%%%%%%%%%
% True and smooth models
%%%%%%%%%%%%%%%%%%%%%%%
orig_vp_true = dlmread('Marmousi/0th_true_vp.dat');orig_vp_true = reshape(orig_vp_true,nz,nx);
vp_smooth = orig_vp_true;
num_smooth_iteration = 10;
for i = 1:num_smooth_iteration
    vp_smooth = smooth_filter(vp_smooth,fspecial('gaussian'),40);
end
orig_vp_smooth = vp_smooth;
%orig_vp_smooth    = dlmread(['Marmousi/0th_mig_vp' file_title '.dat']);orig_vp_smooth = reshape(orig_vp_smooth,nz,nx);

%%%%%%%%%%%%%%%%%%%%%%%
% Training models
%%%%%%%%%%%%%%%%%%%%%%%
filename1=dir(['velocity_' num2str(0) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel10*.dat']);
CNN_train1 = dlmread(['velocity_' num2str(0) 'th_iteration_FWI_vp_model' file_title '/' filename1.name]);CNN_train1 = reshape(CNN_train1,nz,nx);
CNN_train_sm1 = smooth_model(CNN_train1, 10, 40);

filename2=dir(['velocity_' num2str(7) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel10*.dat']);
CNN_train2 = dlmread(['velocity_' num2str(7) 'th_iteration_FWI_vp_model' file_title '/' filename2.name]);CNN_train2 = reshape(CNN_train2,nz,nx);
CNN_train_sm2 = smooth_model(CNN_train2, 10, 40);

filename3=dir(['velocity_' num2str(14) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel10*.dat']);
CNN_train3 = dlmread(['velocity_' num2str(14) 'th_iteration_FWI_vp_model' file_title '/' filename3.name]);CNN_train3 = reshape(CNN_train3,nz,nx);
CNN_train_sm3 = smooth_model(CNN_train3, 10, 40);

%%%%%%%%%%%%%%%%%%%%%%%
% Predicted models
%%%%%%%%%%%%%%%%%%%%%%%
CNN_pred1 = dlmread(['Marmousi/' num2str(1) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_pred1 = reshape(CNN_pred1,nz,nx);
CNN_pred_sm1 = smooth_model(CNN_pred1, 10, 40);

CNN_pred2 = dlmread(['Marmousi/' num2str(8) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_pred2 = reshape(CNN_pred2,nz,nx);
CNN_pred_sm2 = smooth_model(CNN_pred2, 10, 40);

CNN_pred3 = dlmread(['Marmousi/' num2str(15) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_pred3 = reshape(CNN_pred3,nz,nx);
CNN_pred_sm3 = smooth_model(CNN_pred3, 10, 40);


% Plot the True and Initial velocity models
subaxis(3, 3, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(28.7620967741936, 279.649193548387,['Starting model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-100.79435483871, -72.0040322580646,'a)') %get from the code of figure
line([offset(1) offset(1)], [1 nz],'Color','r','LineWidth',2);hold on;
line([offset(2) offset(2)], [1 nz],'Color','r','LineWidth',2);hold on;

% Plot the True and Initial velocity models
subaxis(3, 3, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(2.03658536585374, 279.649193548387,['1st training model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -72.0040322580646,'b)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(3, 3, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(2.03658536585374, 279.649193548387,['8th training model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -72.0040322580646,'c)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(3, 3, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train_sm1)
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
rms_error=RMS(orig_vp_true,CNN_train_sm1); 
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(28.7620967741936, 279.649193548387,['Starting model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-100.79435483871, -19.9962825278811,'e)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(3, 3, 5, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train_sm2)
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
rms_error=RMS(orig_vp_true,CNN_train_sm2); 
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-11.6526717557251, 279.649193548387,['1st prediction model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'f)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(3, 3, 6, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_train_sm3)
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
rms_error=RMS(orig_vp_true,CNN_train_sm3); 
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-11.6526717557251, 279.649193548387,['8th prediction model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'g)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(3, 3, 7, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_pred1)
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
rms_error=RMS(orig_vp_true,CNN_pred1); 
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(28.7620967741936, 279.649193548387,['Starting model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-100.79435483871, -19.9962825278811,'e)') %get from the code of figure



% Plot the True and Initial velocity models
subaxis(3, 3, 8, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_pred2)
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
rms_error=RMS(orig_vp_true,CNN_pred2); 
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-11.6526717557251, 279.649193548387,['1st prediction model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'f)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(3, 3, 9, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_pred3)
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
rms_error=RMS(orig_vp_true,CNN_pred3); 
text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-11.6526717557251, 279.649193548387,['8th prediction model'])
disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-26.9878048780487, -19.9962825278811,'g)') %get from the code of figure
% % % % % 
% % % % % % Plot the True and Initial velocity models
% % % % % subaxis(3, 3, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
% % % % % imagesc(CNN_pred_sm1)
% % % % % set(gca,'XAxisLocation','top');
% % % % % set(gca, 'XTick', [1 nx/2 nx])            
% % % % % set(gca,'XTickLabel',{'0.0','1.9','3.9'}) 
% % % % % set(gca, 'YTick', [])          
% % % % % set(gca,'YTickLabel',{}) 
% % % % % axis equal; %colormap('gray');
% % % % % xlabel('Distance (km)'); 
% % % % % xlim([1 nx]);ylim([1 nz]);
% % % % % caxis([1.5 4.5]);  
% % % % % rms_error=RMS(orig_vp_true,CNN_pred_sm1); 
% % % % % text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% % % % % text(2.03658536585374, 279.649193548387,['15th training model'])
% % % % % disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% % % % % text(-26.9878048780487, -72.0040322580646,'d)') %get from the code of figure
% % % % % 
% % % % % 
% % % % % % Plot the True and Initial velocity models
% % % % % subaxis(3, 3, 8, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
% % % % % imagesc(CNN_pred_sm2)
% % % % % set(gca,'XAxisLocation','top');
% % % % % set(gca, 'XTick', [])            
% % % % % set(gca,'XTickLabel',{})  
% % % % % set(gca, 'YTick', [])            
% % % % % set(gca,'YTickLabel',{})  
% % % % % axis equal; %colormap('gray');
% % % % % %     xlabel('Distance (km)'); 
% % % % % xlim([1 nx]);ylim([1 nz]);
% % % % % caxis([1.5 4.5]);  
% % % % % %     ylabel('Depth (km)');
% % % % % rms_error=RMS(orig_vp_true,CNN_pred_sm2); 
% % % % % text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% % % % % text(-11.6526717557251, 279.649193548387,['15th prediction model'])
% % % % % disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% % % % % text(-26.9878048780487, -19.9962825278811,'h)') %get from the code of figure
% % % % % 
% % % % % % Plot the True and Initial velocity models
% % % % % subaxis(3, 3, 12, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
% % % % % imagesc(CNN_pred_sm3)
% % % % % set(gca,'XAxisLocation','top');
% % % % % set(gca, 'XTick', [])            
% % % % % set(gca,'XTickLabel',{})  
% % % % % set(gca, 'YTick', [])            
% % % % % set(gca,'YTickLabel',{})  
% % % % % axis equal; %colormap('gray');
% % % % % %     xlabel('Distance (km)'); 
% % % % % xlim([1 nx]);ylim([1 nz]);
% % % % % caxis([1.5 4.5]);  
% % % % % %     ylabel('Depth (km)');
% % % % % rms_error=RMS(orig_vp_true,CNN_pred_sm3); 
% % % % % text(4.08467741935476, 320.778225806451,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% % % % % text(-11.6526717557251, 279.649193548387,['15th prediction model'])
% % % % % disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
% % % % % text(-26.9878048780487, -19.9962825278811,'h)') %get from the code of figure




c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Velocity (km/s)';
set(colorTitleHandle ,'String',titleString);
set(c,'YTick',[1.5,2.0,2.5,3.0])
set(c,'YTickLabels',{'1.5','2.0','2.5','3.0'})
set(c,'Position',[0.818411308260034 0.255409743002513 0.0149220250732999 0.469246031746029]) %get from the code of figure

    
    
    
    
    
    
%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(2);
sh = 0.03;
sv = 0.02;
padding = 0.0;
margin = 0.20;

%---------------------------------------------------------------
depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines

subaxis(2, 3, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*1; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train1(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_train_sm1(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',1.5:0.5:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.5 4.7 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
text(1.15764705882353, -0.48190780669145,'a)')
%legend('True model','Output model')

subaxis(2, 3, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_train_sm2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:0.5:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.5 4.7 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(1.34823529411765, -0.48190780669145,'b)')

subaxis(2, 3, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_train_sm3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:0.5:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.5 4.7 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(1.34823529411765, -0.48190780669145,'c)')
h=text(2.83058823529412, 3.17795836431227,'Velocity profile at 1.2 km')
set(h,'Rotation',90);

subaxis(2, 3, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*1; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train1(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_train_sm1(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.5 4.7 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
text(1.15764705882353, 0.00799553903345673,'d)')
%legend('True model','Output model')
text(1.8, 4.15776505576208, '1st iteration')

subaxis(2, 3, 5, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_train_sm2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.5 4.7 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(1.35529411764706, 0.00799553903345673,'e)')
text(1.8, 4.15776505576208, '4th iteration')

subaxis(2, 3, 6, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_train_sm3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.5 4.7 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(1.35529411764706, 0.00799553903345673,'f)') 
text(1.8, 4.15776505576208, '7th iteration')
h=text(2.83058823529412, 3.17795836431227,'Velocity profile at 2.4 km')
set(h,'Rotation',90);