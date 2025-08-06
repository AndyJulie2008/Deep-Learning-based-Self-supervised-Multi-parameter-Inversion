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
cvalue = 0.001;
nz = 256;
nx = 256;
dh = 12.5;
filename = 'all_statistics';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vp_true = dlmread('Marmousi/0th_true_vp.dat');
% vp_true = reshape(vp_true,nz,nx);

vp_init = dlmread('Marmousi/0th_mig_vp6500.dat');
% vp_init = reshape(vp_init,nz,nx);

num_folder = 15; %8 iterations 
num_Files = 24;

samples = num_Files;  %32 training models at each iteration
stat_to_vp_true_RMS = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_true_R2 = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_RMS = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_R2 = zeros(samples,num_folder); %1 for RMS, 2 for R2

stat_to_vp_true_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_true_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2

if exist([filename '.mat'], 'file') == 0 %if file exists do not repeatedly create
    for i = 1 : num_folder
        disp(i)
        folder_name = ['velocity_' num2str(i-1) 'th_iteration_FWI_vp_model6500'];
        Files=dir([folder_name '/new_vpmodel*.dat']); %file name
        for k=1:num_Files
            v = dlmread([folder_name '/' Files(k).name]);
            stat_to_vp_true_RMS(k,i) = RMS(vp_true,v);
            stat_to_vp_true_R2(k,i) = R2(vp_true,v);
            stat_to_vp_init_RMS(k,i) = RMS(vp_init,v);
            stat_to_vp_init_R2(k,i) = R2(vp_init,v);
        end

        folder_name = ['Marmousi/' num2str(i) 'th_iteration_FWI_vp_model6500.dat'];
        v = dlmread(folder_name);
        stat_to_vp_true_RMS_CNN(1,i) = RMS(vp_true,v);
        stat_to_vp_true_R2_CNN(1,i) = R2(vp_true,v);
        stat_to_vp_init_RMS_CNN(1,i) = RMS(vp_init,v);
        stat_to_vp_init_R2_CNN(1,i) = R2(vp_init,v);
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Density
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vp_second_true = dlmread('Marmousi/0th_true_vp.dat');
% vp_second_true = reshape(vp_second_true,nz,nx);

vp_second_init = dlmread('Marmousi/0th_mig_vp6500_80_20.dat');
% vp_second_init = reshape(vp_second_init,nz,nx);

stat_to_vp_second_true_RMS = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_second_true_R2 = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_second_init_RMS = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_second_init_R2 = zeros(samples,num_folder); %1 for RMS, 2 for R2

stat_to_vp_second_true_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_second_true_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_second_init_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_second_init_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2

if exist([filename '.mat'], 'file') == 0 %if file exists do not repeatedly create
    for i = 1 : num_folder
        disp(i)
        folder_name = ['velocity_' num2str(i-1) 'th_iteration_FWI_vp_model6500_80_20'];
        Files=dir([folder_name '/*.dat']); %file name
        for k=1:num_Files
            v = dlmread([folder_name '/' Files(k).name]);
            stat_to_vp_second_true_RMS(k,i) = RMS(vp_second_true,v);
            stat_to_vp_second_true_R2(k,i) = R2(vp_second_true,v);
            stat_to_vp_second_init_RMS(k,i) = RMS(vp_second_init,v);
            stat_to_vp_second_init_R2(k,i) = R2(vp_second_init,v);
        end

        folder_name = ['Marmousi/' num2str(i) 'th_iteration_FWI_vp_model6500_80_20.dat'];
        v = dlmread(folder_name);
        stat_to_vp_second_true_RMS_CNN(1,i) = RMS(vp_second_true,v);
        stat_to_vp_second_true_R2_CNN(1,i) = R2(vp_second_true,v);
        stat_to_vp_second_init_RMS_CNN(1,i) = RMS(vp_second_init,v);
        stat_to_vp_second_init_R2_CNN(1,i) = R2(vp_second_init,v);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist([filename '.mat'], 'file') == 0 %if file exists do not repeatedly create
    disp('Try to save mat file.....');
    save([filename '.mat']);
else
    disp('Try to load mat file.....');
    load([filename '.mat']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(2,2,1)
for i = 1:num_folder
    for k = 1:num_Files
        plot(i,stat_to_vp_true_RMS(k,i)*100,'.');hold on;
        plot(i,stat_to_vp_true_RMS_CNN(1,i)*100,'ro');hold on;
    end
end
plot(i,stat_to_vp_true_RMS_CNN(1,i)*100,'ro');hold on;
% set(gca, 'YTick', [1 1.5 2 2.5 3])          
% set(gca,'YTickLabel',{'1.0' '1.5' '2.0' '2.5' '3.0'}) 
xlim([0 num_folder+1]);%ylim([1 3]);
% title(['RMSE w.r.t. true model'])
% xlabel('Iteration number'); 
% set(gca,'XAxisLocation','top');

set(gca, 'XTick', [])          
set(gca,'XTickLabel',{})  
text(-2.15189873417722, 9.96031746031746,'a)');
ylabel('RMSE (%)');%ylim([5 10]);

subplot(2,2,3)
for i = 1:num_folder
    for k = 1:num_Files
        plot(i,stat_to_vp_init_RMS(k,i)*100,'.');hold on;
        plot(i,stat_to_vp_init_RMS_CNN(1,i)*100,'ro');hold on;
    end
end
plot(i,stat_to_vp_init_RMS_CNN(1,i)*100,'ro');hold on;
% title(['RMSE w.r.t. starting model'])
xlabel('Iteration number'); xlim([0 num_folder+1])
% set(gca, 'YTick', [0 1 2 3.0])          
% set(gca,'YTickLabel',{'0.0' '1.0' '2.0' '3.0'}) 
text(-2.15189873417722, 9.97860962566845,'b)');
ylabel('RMSE (%)');%ylim([0 2.5]);
xlim([0 num_folder+1]);%ylim([0 3]);

subplot(2,2,2)
for i = 1:num_folder
    for k = 1:num_Files
        plot(i,stat_to_vp_second_true_RMS(k,i)*100,'.');hold on;
        plot(i,stat_to_vp_second_true_RMS_CNN(1,i)*100,'ro');hold on;
    end
end
plot(i,stat_to_vp_second_true_RMS_CNN(1,i)*100,'ro');hold on;
% set(gca, 'YTick', [0.3 0.4 0.5 0.6 0.7])          
% set(gca,'YTickLabel',{'0.3' '0.4' '0.5' '0.6' '0.7'}) 
xlim([0 num_folder+1]);%ylim([0.4 0.7]);
% title(['RMSE w.r.t. true model'])
% xlabel('Iteration number'); 
% set(gca,'XAxisLocation','top');

set(gca, 'XTick', [])          
set(gca,'XTickLabel',{})  
text(-2.15189873417722, 15.8941798941799,'c)');
ylabel('RMSE (%)');%ylim([5 10]);

subplot(2,2,4)
for i = 1:num_folder
    for k = 1:num_Files
        plot(i,stat_to_vp_second_init_RMS(k,i)*100,'.');hold on;
        plot(i,stat_to_vp_second_init_RMS_CNN(1,i)*100,'ro');hold on;
    end
end
plot(i,stat_to_vp_second_init_RMS_CNN(1,i)*100,'ro');hold on;
% title(['RMSE w.r.t. starting model'])
xlabel('Iteration number'); xlim([0 num_folder+1])
% set(gca, 'YTick', [0.0 0.1 0.2 0.3 0.4 0.5])          
% set(gca,'YTickLabel',{'0.0' '0.1' '0.2' '0.3' '0.4' '0.5'}) 
text(-2.15189873417722, 14.8803191489362,'d)');
xlim([0 num_folder+1]);%ylim([0.0 0.5]);
legend('training model','predicted model',2)
ylabel('RMSE (%)');%ylim([0 10]);
