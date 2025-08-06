%run plot_CNN_train_data.m and plot_CNN_real_test_data.m at the beginning

%---------------------------------------------------------------
%------------------ Plot the image------------------------------
hfig1 = figure(12);
sh = 0.02;
sv = 0.045;
padding = 0.0;
margin = 0.1;

figure(102)
%---------------------------------------------------------------
% Plot the True and Initial velocity models
subaxis(3, 1, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reflectivity_real)
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
rms_error=RMS(vp_true,vp_true); 
%text(40,140,['RMS velocity error = ' num2str(rms_error*100, '%4.1f') '%'])
disp(['True RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-89.5208333333333, -55.5041666666666,'a)') %get from the code of figure

subaxis(3, 1, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reflectivity)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})     
axis equal; colormap('gray');
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
rms_error=RMS(vp_true,vp_smooth); 
%text(40,140,['RMS velocity error = ' num2str(rms_error*100, '%4.1f') '%'])
disp(['Initial RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-89.5208333333333, 0.204166666666765,'b)') %get from the code of figure

subaxis(3, 1, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reflectivity - reflectivity_real)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [ ])          
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})   
axis equal; colormap('gray');
ylabel('Depth (km)');
xlim([1 nx]);ylim([1 nz]);
caxis([-cvalue cvalue]);  
rms_error=RMS(vp_true,vp_smooth); 
%text(40,140,['RMS velocity error = ' num2str(rms_error*100, '%4.1f') '%'])
disp(['Initial RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
text(-87.9291666666666, 0.204166666666652,'c)') %get from the code of figure

figure(103)
depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines

subplot(1,3,1)
x_position = nx/4*1; % The horizontal position (unitless)
plot(reflectivity_real(:,x_position),depth,'k','LineWidth',1.5);hold on;
% plot(CNN_output_real(:,x_position),depth,'b','LineWidth',1.5);hold on;
% plot(CNN_output(:,x_position),depth,'g','LineWidth',1.5);hold on;
plot(reflectivity(:,x_position),depth,'r','LineWidth',1.5);hold off;
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
x_position = nx/4*2; % The horizontal position (unitless)
plot(reflectivity_real(:,x_position),depth,'k','LineWidth',1.5);hold on;
% plot(CNN_output_real(:,x_position),depth,'b','LineWidth',1.5);hold on;
% plot(CNN_output(:,x_position),depth,'g','LineWidth',1.5);hold on;
plot(reflectivity(:,x_position),depth,'r','LineWidth',1.5);hold off;
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
x_position = nx/4*3; % The horizontal position (unitless)
plot(reflectivity_real(:,x_position),depth,'k','LineWidth',1.5);hold on;
% plot(CNN_output_real(:,x_position),depth,'b','LineWidth',1.5);hold on;
% plot(CNN_output(:,x_position),depth,'g','LineWidth',1.5);hold on;
plot(reflectivity(:,x_position),depth,'r','LineWidth',1.5);hold off;
set(gca,'YDir','reverse')
xlabel('Amplitude')
set(gca,'ytick',[]) 
set(gca,'xtick',-0.1:0.1:0.1) 
set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
axis([-0.15 0.15 0 (nz-1)*dh])
set(gca,'XAxisLocation','top');
%legend('True model','Output model')
text(-0.190909090909091, -0.209274691358025,'c)')
%print('-depsc2','-r600','velocity_profile')