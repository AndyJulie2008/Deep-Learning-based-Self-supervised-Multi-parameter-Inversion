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
sh = 0.020;
sv = 0.04;
padding = 0.0;
margin = 0.2;

%---------------------------------------------------------------
file_title = '6500'; %'6500_80_20';
% input real test data:
%     input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0_vp.dat']);
orig_vp_true = dlmread('Marmousi/0th_true_vp.dat');orig_vp_true = reshape(orig_vp_true,nz,nx);
orig_vp_smooth    = dlmread(['Marmousi/0th_mig_vp' file_title '.dat']);orig_vp_smooth = reshape(orig_vp_smooth,nz,nx);

filename1=dir(['velocity_' num2str(0) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_train1 = dlmread(['velocity_' num2str(0) 'th_iteration_FWI_vp_model' file_title '/' filename1.name]);CNN_train1 = reshape(CNN_train1,nz,nx);

filename2=dir(['velocity_' num2str(4) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_train2 = dlmread(['velocity_' num2str(4) 'th_iteration_FWI_vp_model' file_title '/' filename2.name]);CNN_train2 = reshape(CNN_train2,nz,nx);

filename3=dir(['velocity_' num2str(5) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_train3 = dlmread(['velocity_' num2str(5) 'th_iteration_FWI_vp_model' file_title '/' filename3.name]);CNN_train3 = reshape(CNN_train3,nz,nx);

filename4=dir(['velocity_' num2str(14) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_train4 = dlmread(['velocity_' num2str(14) 'th_iteration_FWI_vp_model' file_title '/' filename4.name]);CNN_train4 = reshape(CNN_train4,nz,nx);

CNN_test1 = dlmread(['Marmousi/' num2str(1) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_test1 = reshape(CNN_test1,nz,nx);

CNN_test2 = dlmread(['Marmousi/' num2str(5) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_test2 = reshape(CNN_test2,nz,nx);

CNN_test3 = dlmread(['Marmousi/' num2str(6) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_test3 = reshape(CNN_test3,nz,nx);

CNN_test4 = dlmread(['Marmousi/' num2str(15) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_test4 = reshape(CNN_test4,nz,nx);

    % Plot the True and Initial velocity models
subaxis(4, 4, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);

% text(94.5685483870967, 279.649193548387,['True'])

text(-109.27027027027, -80.554054054054,'a)') %get from the code of figure
% line([offset(1) offset(1)], [1 nz],'Color','k','LineWidth',2);hold on;
% line([offset(2) offset(2)], [1 nz],'Color','k','LineWidth',2);hold on;

% Plot the True and Initial velocity models
subaxis(4, 4, 5, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);

text(-109.27027027027, -19.9962825278811,'e)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(4, 4, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
% text(51.7926829268293, 279.649193548387,['5th training'])

text(-26.9878048780487, -80.554054054054,'b)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 6, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['5th predicted'])

text(-26.9878048780487, -19.9962825278811,'f)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['12nd training'])

text(-26.9878048780487, -80.554054054054,'c)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 7, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['12nd predicted'])

text(-26.9878048780487, -19.9962825278811,'g)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['15th training'])

text(-26.9878048780487, -80.554054054054,'d)') %get from the code of figure
h2=text(279.90625, 250.308035714286,['Training model']);set(h2,'Rotation',90); 
h3=text(331.810810810811, 434.040540540541,'Starting model 1');set(h3,'Rotation',90);  %get from the code of figure


% Plot the True and Initial velocity models
subaxis(4, 4, 8, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
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
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['15th predicted'])

text(-26.9878048780487, -19.9962825278811,'h)') %get from the code of figure
h2=text(279.90625, 222.689189189189,['CNN model']);set(h2,'Rotation',90); 









%---------------------------------------------------------------
file_title = '6500_80_20'; %'6500_80_20';
% input real test data:
%     input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0_vp.dat']);
% input real test data:
%     input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0_vp.dat']);
orig_vp_true = dlmread('Marmousi/0th_true_vp.dat');orig_vp_true = reshape(orig_vp_true,nz,nx);
orig_vp_smooth2    = dlmread(['Marmousi/0th_mig_vp' file_title '.dat']);orig_vp_smooth2 = reshape(orig_vp_smooth2,nz,nx);

filename1=dir(['velocity_' num2str(0) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_2train1 = dlmread(['velocity_' num2str(0) 'th_iteration_FWI_vp_model' file_title '/' filename1.name]);CNN_2train1 = reshape(CNN_2train1,nz,nx);

filename2=dir(['velocity_' num2str(4) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_2train2 = dlmread(['velocity_' num2str(4) 'th_iteration_FWI_vp_model' file_title '/' filename2.name]);CNN_2train2 = reshape(CNN_2train2,nz,nx);

filename3=dir(['velocity_' num2str(5) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_2train3 = dlmread(['velocity_' num2str(5) 'th_iteration_FWI_vp_model' file_title '/' filename3.name]);CNN_2train3 = reshape(CNN_2train3,nz,nx);

filename4=dir(['velocity_' num2str(14) 'th_iteration_FWI_vp_model' file_title '/' 'new_vpmodel13*.dat']);
CNN_2train4 = dlmread(['velocity_' num2str(14) 'th_iteration_FWI_vp_model' file_title '/' filename4.name]);CNN_2train4 = reshape(CNN_2train4,nz,nx);

CNN_2test1 = dlmread(['Marmousi/' num2str(1) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_2test1 = reshape(CNN_2test1,nz,nx);

CNN_2test2 = dlmread(['Marmousi/' num2str(5) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_2test2 = reshape(CNN_2test2,nz,nx);

CNN_2test3 = dlmread(['Marmousi/' num2str(6) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_2test3 = reshape(CNN_2test3,nz,nx);

CNN_2test4 = dlmread(['Marmousi/' num2str(15) 'th_iteration_FWI_vp_model' file_title '.dat']);
CNN_2test4 = reshape(CNN_2test4,nz,nx);

% Plot the True and Initial velocity models
subaxis(4, 4, 9, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2train1)
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
rms_error=RMS(orig_vp_true,CNN_2train1); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
% text(74.0040322580646, 279.649193548387,['Starting'])

text(-109.27027027027, -19.9962825278811,'i)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 13, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2test1)
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
rms_error=RMS(orig_vp_true,CNN_2test1); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
text(30.8648648648646, 332.95945945946,['1st iteration'])

text(-109.27027027027, -19.9962825278811,'m)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(4, 4, 10, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2train2)
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
rms_error=RMS(orig_vp_true,CNN_2train2); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['5th predicted'])

text(-26.9878048780487, -19.9962825278811,'j)') %get from the code of figure


% Plot the True and Initial velocity models
subaxis(4, 4, 14, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2test2)
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
rms_error=RMS(orig_vp_true,CNN_2test2); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
text(30.8648648648646, 332.95945945946,['5th iteration'])

text(-26.9878048780487, -19.9962825278811,'n)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 11, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2train3)
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
rms_error=RMS(orig_vp_true,CNN_2train3); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['12nd predicted'])

text(-26.9878048780487, -19.9962825278811,'k)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 15, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2test3)
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
rms_error=RMS(orig_vp_true,CNN_2test3); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
text(30.8648648648646, 332.95945945946,['6th iteration'])

text(-26.9878048780487, -19.9962825278811,'o)') %get from the code of figure

% Plot the True and Initial velocity models
subaxis(4, 4, 12, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2train4)
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
rms_error=RMS(orig_vp_true,CNN_2train4); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
%text(39.3536585365855, 279.649193548387,['15th predicted'])

text(-26.9878048780487, -19.9962825278811,'l)') %get from the code of figure
h2=text(279.90625, 250.308035714286,['Training model']);set(h2,'Rotation',90); 
h3=text(331.810810810811, 434.040540540541,'Starting model 2');set(h3,'Rotation',90);  %get from the code of figure
                      
% Plot the True and Initial velocity models
subaxis(4, 4, 16, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(CNN_2test4)
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
rms_error=RMS(orig_vp_true,CNN_2test4); 
text(21.6756756756757, 287.013513513514,['RMSE=' num2str(rms_error*100, '%4.2f') '%']);
text(30.8648648648646, 332.95945945946,['15th iteration'])

text(-26.9878048780487, -19.9962825278811,'p)') %get from the code of figure
h2=text(279.90625, 222.689189189189,['CNN model']);set(h2,'Rotation',90); 

c = colorbar('Location','southoutside') 
colorTitleHandle = get(c,'XLabel');
titleString = 'Velocity (km/s)';
set(colorTitleHandle ,'String',titleString);
set(c,'XTick',[1.5,2.0,2.5,3.0 3.5 4.0 4.5])
set(c,'XTickLabels',{'1.5','2.0','2.5','3.0','3.5','4.0','4.5'})
set(c,'Position',[0.281316348195329 0.132400430570506 0.453290870488323 0.0107642626480081]) %get from the code of figure



    




%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig2 = figure(2);
sh = 0.03;
sv = 0.02;
padding = 0.0;
margin = 0.06;

%---------------------------------------------------------------
depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines

subaxis(4,4,1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*1; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
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
text(0.209139784946237, -0.6682,'a)')
%legend('True','Output')

subaxis(4,4,2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, -0.6682,'b)')

subaxis(4,4,3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, -0.6682,'c)')
% h=text(5.41352941176471, 3.17795836431227,'Velocity profile at 1.2 km')
%set(h,'Rotation',90);

subaxis(4,4,4, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train4(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test4(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Velocity (km/s)')
set(gca,'ytick',[]) 
set(gca,'xtick',1.5:1.0:4.7) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, -0.6682,'d)')
h=text(5.37795698924731, 3.7178,'Velocity profile at 1.0 km')
set(h,'Rotation',90);
h4=text(5.82741935483871, 5.2886, 'Starting model 1');set(h4,'Rotation',90);


subaxis(4,4,5, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
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
text(0.209139784946237, 0.00799553903345673,'e)')
%legend('True','Output')
% text(2.15, 4.143356133829, '5th iteration')

subaxis(4,4,6, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'f)')
% text(2.15, 4.143356133829, '12th iteration')

subaxis(4,4,7, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'g)') 
% text(2.15, 4.143356133829, '15th iteration')
% h=text(5.41352941176471, 3.17795836431227,'Velocity profile at 2.4 km')
%set(h,'Rotation',90);

subaxis(4,4,8, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_train4(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_test4(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'h)') 
% text(2.15, 4.143356133829, '15th iteration')
h=text(5.37795698924731, 3.7178,'Velocity profile at 2.0 km')
set(h,'Rotation',90);








subaxis(4,4,9, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train1(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test1(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
text(0.209139784946237, 0.00799553903345673,'i)')
%legend('True','Output')
% text(2.15, 4.143356133829, '5th iteration')

subaxis(4,4,10, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'j)')
% text(2.15, 4.143356133829, '12th iteration')

subaxis(4,4,11, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'k)') 
% text(2.15, 4.143356133829, '15th iteration')
% h=text(5.41352941176471, 3.17795836431227,'Velocity profile at 2.4 km')
%set(h,'Rotation',90);

subaxis(4,4,12, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train4(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test4(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'l)') 
% text(2.15, 4.143356133829, '15th iteration')
h=text(5.37795698924731, 3.7178,'Velocity profile at 1.0 km')
set(h,'Rotation',90);
h4=text(5.82741935483871, 5.2886, 'Starting model 2');set(h4,'Rotation',90);






subaxis(4,4,13, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(1); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train1(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test1(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
ylabel('Depth (km)')
set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
text(0.209139784946237, 0.00799553903345673,'m)')
%legend('True','Output')
text(2.15, 4.143356133829, '1st iteration')

subaxis(4,4,14, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*2; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train2(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test2(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'n)')
text(2.15, 4.143356133829, '5th iteration')

subaxis(4,4,15, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train3(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test3(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'o)') 
text(2.15, 4.143356133829, '6th iteration')
% h=text(5.41352941176471, 3.17795836431227,'Velocity profile at 2.4 km')
%set(h,'Rotation',90);

subaxis(4,4,16, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
x_position = offset(2); %nx/4*3; % The horizontal position (unitless)
plot(orig_vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
plot(orig_vp_smooth2(:,x_position),depth,'cyan','LineWidth',1.5);hold on;
plot(CNN_2train4(:,x_position),depth,'b','LineWidth',1.5);hold on;
plot(CNN_2test4(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
% xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',[]) 
% set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([1.2 5.0 1*dh (nz)*dh]) 
set(gca,'XAxisLocation','top');
%legend('True','Output')
text(0.764117647058824, 0.00799553903345673,'p)') 
text(2.15, 4.143356133829, '15th iteration')
h=text(5.37795698924731, 3.7178,'Velocity profile at 2.0 km')
set(h,'Rotation',90);