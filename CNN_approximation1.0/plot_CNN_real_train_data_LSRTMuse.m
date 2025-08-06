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

nz = 192;
nx = 192*3;
max_reflectivity = 0.2;
max_image = 0.5;
max_vel = 5;
mean_vel = 3;
dh = 0.0125;

offset = [40 230 320]; % for profile

%input data contains:
%rtm image, reflectivity, smooth model, true model, and CNN output

num_shot = num2str(24);num_model = num2str(100);num_iter = num2str(1000);
% num_shot = num2str(192);num_model = num2str(94);num_iter = num2str(1000);
export_num = num2str(3);%for export training data only
mode =  'real' % 'train'

if strcmp(mode,'real')
    % input real test data:
    input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_LSRTMuse/real_outputs_input_rtm_only/real0.dat']);
elseif strcmp(mode,'train')
    %input train data:
    input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_LSRTMuse/train_outputs/export' export_num '.dat']);
end

%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

true_initial_model_name = ['true_initial_model' '_mode_' mode]
three_migration_name = ['LSRTM_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_migration' '_mode_' mode] 
three_migration_profile_name = ['LSRTM_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_migration_profile' '_mode_' mode] 
three_model_name = ['LSRTM_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_velocity' '_mode' mode] 
three_model_profile_name = ['LSRTM_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_velocity_profile' '_mode_' mode] 
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

rtm_image    = input_data(1+nz*nx*0:nz*nx*1)*10;
reflectivity = input_data(1+nz*nx*1:nz*nx*2);
vp_smooth    = input_data(1+nz*nx*2:nz*nx*3);
vp_true      = input_data(1+nz*nx*3:nz*nx*4);
CNN_output   = input_data(1+nz*nx*4:nz*nx*5);

rtm_image = reshape(rtm_image,nz,nx);
reflectivity = reshape(reflectivity,nz,nx);
vp_smooth = reshape(vp_smooth,nz,nx);
vp_true = reshape(vp_true,nz,nx);
CNN_output = reshape(CNN_output,nz,nx);


cvalue = cvalue*max_reflectivity;


%%%%%%%%%%%%%%%%%%%%%
% plot true and initial model as default
%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(1);
sh = 0.02;
sv = 0.02;
padding = 0.0;
margin = 0.2;

%---------------------------------------------------------------
% Plot the True and Initial velocity models
subaxis(2, 1, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(vp_true)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.00','2.88','5.76','8.64'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; 
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1. 5.]); 
ylabel('Depth (km)');
RMS_error=RMS(vp_true,vp_true); 
text(142.8625, 205.529166666667,['RMS velocity error = ' num2str(RMS_error*100, '%4.1f') '%'])
disp(['True RMS error = ' num2str(RMS_error*100, '%4.1f') '%'])
text(-79.414603960396, -47.9616336633663,'a)') %get from the code of figure

subaxis(2, 1, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(vp_smooth)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [0 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})    
axis equal; 
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([1. 5.]); 
RMS_error=RMS(vp_true,vp_smooth); 
text(142.8625, 205.529166666667,['RMS velocity error = ' num2str(RMS_error*100, '%4.1f') '%'])
disp(['Initial RMS error = ' num2str(RMS_error*100, '%4.1f') '%'])
text(-80.8378712871287, 3.27599009900996,'b)') %get from the code of figure
%colorbar('peer',axes1,...
%    [0.828373015873015 0.321428571428571 0.0272817460317466 0.362103174603174]);
c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Velocity (km/s)';
set(colorTitleHandle ,'String',titleString);
set(c,'YTick',[1.5,2.5,3.5,4.5])
set(c,'YTickLabels',{'1.5','2.5','3.5','4.5'})
set(c,'Position',[0.841765873015872, 0.277777777777778, ...
    0.0272817460317471, 0.469246031746029]) %get from the code of figure
print('-depsc2','-r600',true_initial_model_name)


%%%%%%%%%%%%%%%%%%%%%
% plot LSRTM result first
%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------
%------------------ Plot the image------------------------------
hfig1 = figure(2);
sh = 0.02;
sv = 0.045;
padding = 0.0;
margin = 0.1;


rtm_image = reshape(rtm_image,nz,nx);
vp_smooth = reshape(vp_smooth,nz,nx);
CNN_output = reshape(CNN_output,nz,nx);

reflectivity = reshape(reflectivity,nz,nx);
vp_true = reshape(vp_true,nz,nx);

%---------------------------------------------------------------
% Plot the True and Initial velocity models
subaxis(3, 1, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reflectivity)
set(gca,'XAxisLocation','top');
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.00','2.88','5.76','8.64'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; colormap('gray');
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
ylabel('Depth (km)');
R2_error=R2(reflectivity,reflectivity); 
text(142.8625, 205.529166666667,['Correlation coefficient = ' num2str(R2_error, '%5.3f')])
disp(['True R2 error = ' num2str(R2_error*100, '%4.1f') '%'])
text(-89.5208333333333, -55.5041666666666,'a)') %get from the code of figure

subaxis(3, 1, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(rtm_image)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})     
axis equal; colormap('gray');
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
R2_error=R2(reflectivity,rtm_image); 
text(142.8625, 205.529166666667,['Correlation coefficient = ' num2str(R2_error, '%5.3f')])
disp(['Initial R2 error = ' num2str(R2_error*100, '%4.1f') '%'])
% line([offset(1) offset(1)], [1 nz],'Color','r','LineWidth',2);hold on;
% line([offset(2) offset(2)], [1 nz],'Color','r','LineWidth',2);hold on;
% line([offset(3) offset(3)], [1 nz],'Color','r','LineWidth',2);hold on;
text(-89.5208333333333, 0.204166666666765,'b)') %get from the code of figure

subaxis(3, 1, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_output)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})   
axis equal; colormap('gray');
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
R2_error=R2(reflectivity,CNN_output); 
text(142.8625, 205.529166666667,['Correlation coefficient = ' num2str(R2_error, '%5.3f')])
disp(['Initial R2 error = ' num2str(R2_error*100, '%4.1f') '%'])
text(-87.9291666666666, 0.204166666666652,'c)') %get from the code of figure
print('-depsc2','-r600',three_migration_name)

figure(3)
depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines

subplot(1,3,1)
x_position = offset(1); %nx/4*1; % The horizontal position (unitless)
plot(reflectivity(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(rtm_image(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_output(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',-0.1:0.1:0.1) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([-0.15 0.15 1*dh (nz)*dh])
set(gca,'XAxisLocation','top');
text(-0.251041666666667, -0.209274691358025,'a)')
%legend('True model','Output model')

subplot(1,3,2)
x_position = offset(2); nx/4*2; % The horizontal position (unitless)
plot(reflectivity(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(rtm_image(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_output(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',-0.1:0.1:0.1) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([-0.15 0.15 0 (nz-1)*dh])
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(-0.190909090909091, -0.209274691358025,'b)')

subplot(1,3,3)
x_position = offset(3); %nx/4*3; % The horizontal position (unitless)
plot(reflectivity(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(rtm_image(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_output(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',-0.1:0.1:0.1) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([-0.15 0.15 0 (nz-1)*dh])
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(-0.190909090909091, -0.209274691358025,'c)')
print('-depsc2','-r600',three_migration_profile_name)
%---------------------------------------------------------------


%print('-depsc2','-r600','velocity_profile')
%---------------------------------------------------------------





%%%%%%%%%%%%%%%%%%%%%
% plot FWI result second
%%%%%%%%%%%%%%%%%%%%%
CNN_output_velocity = CNN_output.*vp_smooth + vp_smooth;

%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(4);
sh = 0.02;
sv = 0.045;
padding = 0.0;
margin = 0.1;

%---------------------------------------------------------------
% Plot the True and Initial velocity models
subaxis(3, 1, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(vp_true)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.00','2.88','5.76','8.64'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; 
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([1. 5.]); 
ylabel('Depth (km)');
R2_error=R2(vp_true,vp_true); 
text(142.8625, 205.529166666667,['R2 velocity error = ' num2str(R2_error*100, '%4.1f') '%'])
disp(['True R2 error = ' num2str(R2_error*100, '%4.1f') '%'])
text(-89.5208333333333, -55.5041666666666,'a)') %get from the code of figure

subaxis(3, 1, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(vp_smooth)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [0 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})    
axis equal; 
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([1. 5.]); 
R2_error=R2(vp_true,vp_smooth); 
text(142.8625, 205.529166666667,['R2 velocity error = ' num2str(R2_error*100, '%4.1f') '%'])
disp(['Initial R2 error = ' num2str(R2_error*100, '%4.1f') '%'])
text(-89.5208333333333, 0.204166666666765,'b)') %get from the code of figure



subaxis(3, 1, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_output_velocity)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [0 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})    
axis equal; 
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([1. 5.]); 
R2_error=R2(vp_true,CNN_output_velocity); 
text(142.8625, 205.529166666667,['R2 velocity error = ' num2str(R2_error*100, '%4.1f') '%'])
disp(['Initial R2 error = ' num2str(R2_error*100, '%4.1f') '%'])
text(-87.9291666666666, 0.204166666666652,'c)') %get from the code of figure

c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Velocity (km/s)';
set(colorTitleHandle ,'String',titleString);
set(c,'YTick',[1.5,2.5,3.5,4.5])
set(c,'YTickLabels',{'1.5','2.5','3.5','4.5'})
set(c,'Position',[0.791170634920633 0.277777777777778 0.0272817460317471 0.469246031746029]) %get from the code of figure
print('-depsc2','-r600',three_model_name)



figure(5)
depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines

subplot(1,3,1)
x_position = offset(1); %nx/4*1; % The horizontal position (unitless)
plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(vp_smooth(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_output_velocity(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',1.5:1:4.5) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.5 4.5 1*dh (nz)*dh])
set(gca,'XAxisLocation','top');
text(0.431654676258992, -0.202669753086421,'a)')
%legend('True model','Output model')

subplot(1,3,2)
x_position = offset(2); nx/4*2; % The horizontal position (unitless)
plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(vp_smooth(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_output_velocity(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1:4.5) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.5 4.5 1*dh (nz)*dh])
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(1.23021582733813, -0.196774691358026,'b)')

subplot(1,3,3)
x_position = offset(3); %nx/4*3; % The horizontal position (unitless)
plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(vp_smooth(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_output_velocity(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1:4.5) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.5 4.5 1*dh (nz)*dh])
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(1.33812949640287, -0.19087962962963,'c)')
print('-depsc2','-r600',three_model_profile_name)
%---------------------------------------------------------------