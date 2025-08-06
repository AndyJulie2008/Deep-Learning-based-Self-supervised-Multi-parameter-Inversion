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
export_num = num2str(0);

    % input real test data:
%     input_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0.dat']);
    orig_data = dlmread(['24shots_result_generate_1th_FWI_model' '/' 'real_outputs/real0.dat']);
    
    orig_rtm_image    = orig_data(1+nz*nx*0:nz*nx*1)*(-40);
    orig_reflectivity = orig_data(1+nz*nx*1:nz*nx*2);
    orig_vp_smooth    = orig_data(1+nz*nx*2:nz*nx*3);
    orig_vp_true      = orig_data(1+nz*nx*3:nz*nx*4);
    orig_CNN_output   = orig_data(1+nz*nx*4:nz*nx*5);

    orig_rtm_image = reshape(orig_rtm_image,nz,nx);
    orig_vp_smooth = reshape(orig_vp_smooth,nz,nx);
    orig_reflectivity = reshape(orig_reflectivity,nz,nx);
    orig_vp_true = reshape(orig_vp_true,nz,nx);

    %%%%%%%%%%%%%%%%%%%%%
    % plot true and initial model as default
    %%%%%%%%%%%%%%%%%%%%%
    %---------------------------------------------------------------
    %------------------ Plot the velocity models--------------------
    hfig1 = figure(1);
    sh = 0.03;
    sv = 0.00;
    padding = 0.0;
    margin = 0.20;

    %---------------------------------------------------------------
    % Plot the True and Initial velocity models
    subaxis(4, 2, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
    imagesc(orig_vp_smooth)
    set(gca,'XAxisLocation','top');
    set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
    set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
    set(gca, 'YTick', [1 nx/6 nx/3])          
    set(gca,'YTickLabel',{'0.0','1.2','2.4'}) 
    axis equal; %colormap('gray');
    xlabel('Distance (km)'); 
    xlim([1 nx]);ylim([1 nz]);
    caxis([1.5 4.5]);  
    ylabel('Depth (km)');
    rms_error=RMS(orig_vp_true,orig_vp_smooth); 
    text(166.659851301115, 256.815985130112,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
    text(205.135687732342, 218.340148698885,'Starting model')
    disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
    text(-100.533457249071, -70.2286245353159,'a)') %get from the code of figure

    %input train data:
    for i = 1:7
        subaxis(4, 2, i+1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
        input_data = dlmread(['24shots_result_generate_' num2str(i) 'th_FWI_model' '/' 'real_outputs/real' export_num '.dat']);

        rtm_image    = input_data(1+nz*nx*0:nz*nx*1)*(-40);
        reflectivity = input_data(1+nz*nx*1:nz*nx*2);
        vp_smooth    = input_data(1+nz*nx*2:nz*nx*3);
        vp_true      = input_data(1+nz*nx*3:nz*nx*4);
        CNN_output   = input_data(1+nz*nx*4:nz*nx*5);
        
        rtm_image = reshape(rtm_image,nz,nx);
        vp_smooth = reshape(vp_smooth,nz,nx);
        reflectivity = reshape(reflectivity,nz,nx);
        vp_true = reshape(vp_true,nz,nx);
        CNN_output = reshape(CNN_output,nz,nx);
        
        imagesc(CNN_output)
        
        
        if i == 1
            xlabel('Distance (km)'); 
            set(gca,'XAxisLocation','top');
            set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
            set(gca,'XTickLabel',{'0.0','2.4','4.8','7.2'}) 
        else
            set(gca, 'XTick', [])            
            set(gca,'XTickLabel',{''}) 
        end
        
        if mod(i,2)==0
            ylabel('Depth (km)');
            set(gca, 'YTick', [1 nx/6 nx/3])          
            set(gca,'YTickLabel',{'0.0','1.2','2.4'}) 
        else
            set(gca, 'YTick', [])          
            set(gca,'YTickLabel',{''}) 
        end
        
        if i == 1
        text(-23.5817843866172, -70.2286245353159,'b)') %get from the code of figure
        elseif i == 2
        text(-100.533457249071, -34.9591078066915,'c)') %get from the code of figure
        elseif i == 3
        text(-23.5817843866172, -34.9591078066915,'d)') %get from the code of figure
        elseif i == 4
        text(-100.533457249071, -34.9591078066915,'e)') %get from the code of figure
        elseif i == 5
        text(-23.5817843866172, -34.9591078066915,'f)') %get from the code of figure
        elseif i == 6
        text(-100.533457249071, -34.9591078066915,'g)') %get from the code of figure
        elseif i == 7
        text(-23.5817843866172, -34.9591078066915,'h)') %get from the code of figure
        end
        
        
        axis equal; %colormap('gray');
        xlim([1 nx]);ylim([1 nz]);
        caxis([1.5 4.5]);  
        
        rms_error=RMS(orig_vp_true,CNN_output); 
        text(166.659851301115, 256.815985130112,['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
        if i == 1
            text(141.009293680297, 218.340148698885,[num2str(i) 'st predicted model'])
        elseif i == 2
            text(141.009293680297, 218.340148698885,[num2str(i) 'nd predicted model'])
        elseif i == 2
            text(141.009293680297, 218.340148698885,[num2str(i) 'rd predicted model'])
        else
            text(141.009293680297, 218.340148698885,[num2str(i) 'th predicted model'])
        end
        disp(['RMS error = ' num2str(rms_error*100, '%4.1f') '%'])
        
    end