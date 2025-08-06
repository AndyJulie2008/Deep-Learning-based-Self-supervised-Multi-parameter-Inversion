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

vp_true = dlmread('Sigsbee2A/0th_true_Sigsbee.dat');
% vp_true = reshape(vp_true,nz,nx);

vp_init = dlmread('Sigsbee2A/0th_mig_Sigsbee.dat');
% vp_init = reshape(vp_init,nz,nx);

num_folder = 7; %8 iterations 
num_Files = 32;

samples = 32;  %32 training models at each iteration
stat_to_vp_true_RMS = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_true_R2 = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_RMS = zeros(samples,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_R2 = zeros(samples,num_folder); %1 for RMS, 2 for R2

stat_to_vp_true_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_true_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_RMS_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2
stat_to_vp_init_R2_CNN = zeros(1,num_folder); %1 for RMS, 2 for R2

for i = 1 : num_folder
    disp(i)
    folder_name = ['velocity_for_' num2str(i) 'th_FWI_model_preparation'];
    Files=dir([folder_name '/*.dat']); %file name
    for k=1:length(Files)
        v = dlmread([folder_name '/' Files(k).name]);
        stat_to_vp_true_RMS(k,i) = RMS(vp_true,v);
        stat_to_vp_true_R2(k,i) = R2(vp_true,v);
        stat_to_vp_init_RMS(k,i) = RMS(vp_init,v);
        stat_to_vp_init_R2(k,i) = R2(vp_init,v);
    end
    
    folder_name = ['Sigsbee2A/' num2str(i) 'th_iteration_FWI_model.dat'];
    v = dlmread(folder_name);
    stat_to_vp_true_RMS_CNN(1,i) = RMS(vp_true,v);
    stat_to_vp_true_R2_CNN(1,i) = R2(vp_true,v);
    stat_to_vp_init_RMS_CNN(1,i) = RMS(vp_init,v);
    stat_to_vp_init_R2_CNN(1,i) = R2(vp_init,v);
end

figure(1)
subplot(2,1,1)
for i = 1:num_folder
    for k = 1:num_Files
        plot(i,stat_to_vp_true_RMS(k,i)*100,'.');hold on;
        plot(i,stat_to_vp_true_RMS_CNN(1,i)*100,'ro');hold on;
    end
end
plot(i,stat_to_vp_true_RMS_CNN(1,i)*100,'ro');hold on;
set(gca, 'YTick', [1 1.5 2 2.5 3])          
set(gca,'YTickLabel',{'1.0' '1.5' '2.0' '2.5' '3.0'}) 
% title(['RMS error w.r.t. true model'])
% xlabel('Iteration number'); 
% set(gca,'XAxisLocation','top');

set(gca, 'XTick', [])          
set(gca,'XTickLabel',{})  
text(0.464491362763916, 3.02616279069768,'a)');
ylabel('RMS error (%)');%ylim([5 10]);

subplot(2,1,2)
for i = 1:num_folder
    for k = 1:num_Files
        plot(i,stat_to_vp_init_RMS(k,i)*100,'.');hold on;
        plot(i,stat_to_vp_init_RMS_CNN(1,i)*100,'ro');hold on;
    end
end
plot(i,stat_to_vp_init_RMS_CNN(1,i)*100,'ro');hold on;
legend('training model','predicted model',4)
% title(['RMS error w.r.t. starting model'])
xlabel('Iteration number'); 
set(gca, 'YTick', [0 0.5 1 1.5 2 2.5])          
set(gca,'YTickLabel',{'0.0' '0.5' '1.0' '1.5' '2.0' '2.5'}) 
text(0.464491362763916, 2.49273255813954,'b)');
ylabel('RMS error (%)');%ylim([0 10]);










% 
% 
% 
% 
% figure(1)
% 
% subplot(4,2,1)
% cvalue = max(max(vp_true));
% imagesc(vp_true);caxis([1.5 4.5]);
% title(['True model RMS = ' num2str(RMS(vp_true,vp_true))])
% xlabel('Distance (km)'); 
% set(gca,'XAxisLocation','top');
% set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
% set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
% set(gca, 'YTick', [1 nx/6 nx/3])          
% set(gca,'YTickLabel',{'0.0','1.2','2.4'})  
% ylabel('Depth (km)');
% 
% subplot(4,2,2)
% imagesc(vp_init);caxis([1.5 4.5]);
% title(['Initial model RMS = ' num2str(RMS(vp_true,vp_init))])
% xlabel('Distance (km)'); 
% set(gca,'XAxisLocation','top');
% set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
% set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
% set(gca, 'YTick', [1 nx/6 nx/3])          
% set(gca,'YTickLabel',{'0.0','1.2','2.4'})  
%     
% iter = 8
% for i = 3:8
%     subplot(4,2,i)
%     v = dlmread([num2str(i-2) 'th_true_Marmousi.dat']);
%     v = reshape(v,nz,nx);
%     imagesc(v);caxis([1.5 4.5]);
%     title([num2str(i-2) 'th model RMS = ' num2str(RMS(vp_true,v))])
%     set(gca,'XAxisLocation','top');
%     set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
%     set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
%     set(gca, 'YTick', [1 nx/6 nx/3])          
%     set(gca,'YTickLabel',{'0.0','1.2','2.4'})  
%     caxis([1. 5.]);
%     if mod(i,2) == 1
%         ylabel('Depth (km)');
%     end
% end
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % figure(3)
% % depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines
% % 
% % subplot(1,3,1)
% % x_position = offset(1); %nx/4*1; % The horizontal position (unitless)
% % plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
% % plot(vp_init(:,x_position),depth,'k--','LineWidth',1.5);hold on;
% % plot(v5(:,x_position),depth,'b','LineWidth',1.5);hold on;
% % plot(v6(:,x_position),depth,'r','LineWidth',1.5);hold off;set(gca,'YDir','reverse')
% % xlabel('Amplitude')
% % ylabel('Depth (km)')
% % set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
% % set(gca,'xtick',1.5:1:4.5) 
% % set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
% % set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
% % axis([1.5 4.5 1*dh (nz)*dh])
% % set(gca,'XAxisLocation','top');
% % text(0.431654676258992, -0.202669753086421,'a)')
% % %legend('True model','Output model')
% % 
% % subplot(1,3,2)
% % x_position = offset(2); nx/4*2; % The horizontal position (unitless)
% % plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
% % plot(vp_init(:,x_position),depth,'k--','LineWidth',1.5);hold on;
% % plot(v5(:,x_position),depth,'b','LineWidth',1.5);hold on;
% % plot(v6(:,x_position),depth,'r','LineWidth',1.5);hold off;set(gca,'YDir','reverse')
% % xlabel('Amplitude')
% % set(gca,'ytick',[]) 
% % set(gca,'xtick',1.5:1:4.5) 
% % set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
% % axis([1.5 4.5 1*dh (nz)*dh])
% % set(gca,'XAxisLocation','top');
% % %legend('True model','Output model')
% % text(1.23021582733813, -0.196774691358026,'b)')
% % 
% % subplot(1,3,3)
% % x_position = offset(3); %nx/4*3; % The horizontal position (unitless)
% % plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
% % plot(vp_init(:,x_position),depth,'k--','LineWidth',1.5);hold on;
% % plot(v5(:,x_position),depth,'b','LineWidth',1.5);hold on;
% % plot(v6(:,x_position),depth,'r','LineWidth',1.5);hold off;
% % set(gca,'YDir','reverse')
% % xlabel('Amplitude')
% % set(gca,'ytick',[]) 
% % set(gca,'xtick',1.5:1:4.5) 
% % set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
% % axis([1.5 4.5 1*dh (nz)*dh])
% % set(gca,'XAxisLocation','top');
% % %legend('True model','Output model')
% % text(1.33812949640287, -0.19087962962963,'c)')
% % % print('-depsc2','-r600',three_model_profile_name)
% % %---------------------------------------------------------------
% % 
