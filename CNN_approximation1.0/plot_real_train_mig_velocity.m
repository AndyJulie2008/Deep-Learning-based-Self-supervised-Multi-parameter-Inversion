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

% input real test data:
input_data = dlmread('192shots94samples1000iterations_LSRTMuse/real_outputs/real0.dat');
vp_smooth1    = input_data(1+nz*nx*2:nz*nx*3);
vp_true1      = input_data(1+nz*nx*3:nz*nx*4);
vp_smooth1 = reshape(vp_smooth1,nz,nx);
vp_true1 = reshape(vp_true1,nz,nx);

%input train data: (either one is ok if both are based on the same model)
input_data = dlmread('24shots85samples1000iterations_LSRTMuse/train_outputs/export3.dat');
input_data = dlmread('192shots94samples1000iterations_LSRTMuse/train_outputs/export3.dat');
vp_smooth2    = input_data(1+nz*nx*2:nz*nx*3);
vp_true2      = input_data(1+nz*nx*3:nz*nx*4);
vp_smooth2 = reshape(vp_smooth2,nz,nx);
vp_true2 = reshape(vp_true2,nz,nx);



cvalue = cvalue*max_reflectivity;
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
imagesc(vp_true1 - vp_true2);colormap(mycolor);
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.00','2.88','5.76','8.64'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; 
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
caxis([-0.2 0.2]);  
ylabel('Depth (km)');
rms_error=RMS(vp_true1,vp_true2); 
%text(40,140,['RMS velocity error = ' num2str(rms_error*100, '%4.1f') '%'])
disp(['True RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-79.414603960396, -47.9616336633663,'a)') %get from the code of figure

subaxis(2, 1, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(vp_smooth1 - vp_smooth2);colormap(mycolor);
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [0 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})    
axis equal; 
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([-0.2 0.2]);  
rms_error=RMS(vp_smooth1,vp_smooth2); 
%text(40,140,['RMS velocity error = ' num2str(rms_error*100, '%4.1f') '%'])
disp(['Initial RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-80.8378712871287, 3.27599009900996,'b)') %get from the code of figure
%colorbar('peer',axes1,...
%    [0.828373015873015 0.321428571428571 0.0272817460317466 0.362103174603174]);
c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Velocity (km/s)';
set(colorTitleHandle ,'String',titleString);
set(c,'YTick',[-.2 -.1 0 .1 .2])
set(c,'YTickLabels',{'-0.2','-0.1','0.0','0.1','0.2'})
set(c,'Position',[0.841765873015872, 0.277777777777778, ...
    0.0272817460317471, 0.469246031746029]) %get from the code of figure
%print('-depsc2','-r600','true_init_velocity')


