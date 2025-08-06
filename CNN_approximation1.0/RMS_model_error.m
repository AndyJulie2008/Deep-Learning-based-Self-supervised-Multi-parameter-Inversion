clear all
close all
pack
clc
format longeng

nt=2048; % The number of time steps for forward modeling 

dt=0.003; % The temporal smapling of the time steps(s)

fnull=1/(nt*dt); % The frequency sampling

iteration =10; % The number of iteration at each frequency

Total_iters = 290; % The total number of iteration in FWI

start_freq=19; % The start frequency
incre_freq=2;  % The frequency increment

FWI = 'SFWI';   % The type of FWI
figure(4)
subplot(2,1,2)
modelerror=dlmread([FWI 'model_RMS.dat']); % Input the data

[length c] = size(modelerror);
verticalline=6*ones(length,1);

for i=1:iteration:Total_iters-iteration + 1
    verticalline(i,1)=10;
end
plot(modelerror*100,'r','LineWidth',2);hold on;
stem(verticalline,'k','LineWidth',1);hold off;
ylabel('RMS model error (%)')
xlabel('Cumulative iteration number')
legend(FWI)
set(gca, 'YTick', [7.0 7.2 7.4 7.6 7.8 8.0 8.2 8.4])          
set(gca,'YTickLabel',{'7.0' '7.2' '7.4' '7.6' '7.8' '8.0' '8.2' '8.4'}) 
xlim([1 length]);ylim([6.9 8.5])
text(120, 9.0,'Frequency (Hz)')


for i=1:70:Total_iters - iteration + 1
    frequency=(start_freq+(i-1)*incre_freq/iteration)*fnull;
    h=text(i+2.5,8.52,num2str(frequency,'%4.3f'));
    set(h,'Rotation',90);
end
print('-depsc2','-r600',[FWI 'model_RMS'])

