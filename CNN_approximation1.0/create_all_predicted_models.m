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
max_reflectivity = 10000;
max_image = 0.5;
max_vp = 5;
min_vp = 1.5;
max_vs = 2.8;
min_vs = 0.0;
max_rho = 1.2;
min_rho = 2.6;

dh = 0.0152;

offset = [64 128 192]; % for profile

%input data contains:
%rtm image, reflectivity, smooth model, true model, and CNN output

num_shot = num2str(24);num_model = num2str(100);num_iter = num2str(1000);
% num_shot = num2str(192);num_model = num2str(94);num_iter = num2str(1000);
export_num = num2str(0);
mode = 'real' %'train'

for i = 1:15
    iter = num2str(i);

    if strcmp(mode,'real')
        % input real test data:
    %     vp_data = dlmread([num_shot 'shots' num_model 'samples' num_iter 'iterations_FWIuse_1st_iteration_FWI_model/real_outputs_using_vp_mig/real0.dat']);
        vp_data = dlmread(['24shots_result_generate_' iter 'th_FWI_model' '/' 'real_outputs6500_80_20/real0_vp.dat']);
        rho_data = dlmread(['24shots_result_generate_' iter 'th_FWI_model' '/' 'real_outputs6500_80_20/real0_vp.dat']);
    elseif strcmp(mode,'train')
        %input train data:
        vp_data = dlmread(['24shots_result_generate_' iter 'th_FWI_model' '/' 'train_outputs/export' export_num '_vp.dat']);
        rho_data = dlmread(['24shots_result_generate_' iter 'th_FWI_model' '/' 'train_outputs/export' export_num '_rho.dat']);
    end
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    true_initial_model_name = 'true_initial_model' 
    three_migration_name = ['FWI_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_migration'] 
    three_migration_profile_name = ['FWI_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_migration_profile'] 
    three_model_name = ['FWI_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_velocity'] 
    three_model_profile_name = ['FWI_' num_shot 'shots' num_model 'samples' num_iter 'iterations' '_velocity_profile'] 
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

    CNN_output_vp= vp_data(1+nz*nx*3:nz*nx*4)/1000;
    CNN_output_vp = reshape(CNN_output_vp,nz,nx);

    z1 = 1;
    CNN_output_vp = CNN_output_vp(z1:nz,:);

    nz = nz-z1+1;
    cvalue = cvalue*max_reflectivity;

    vp = reshape(CNN_output_vp,1,nz*nx);
    name = [iter 'th_iteration_FWI_vp_model6500_80_20'];
    fid=fopen([name '.dat'],'wt');
    fprintf(fid,'%17.8f',vp);
    fclose(fid);
end