clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%
% Strategy: maximize the number of clusters at the first and second steps
% Randomly choose the final number of clusters to output model
%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0. set experiment parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%0.1 Set parameters and input starting model
%Marmousi
nz=256;
nx=256*3;
%
nz=192;
nx=192*3;
% water depth of the model
water_depth = 6; 

%0.2 k-means parameters
max_iteration = 300;
kmean_num = 2; %binary segmentation
% num_label = 100; %(abandon) this number should be large enough for segmentation 
max_num_group = 2; %Given the num_label, keep the first k biggest groups (HERE IT SHOULD BE 2s)
tree_depth = 7; %maximum depth of tree
threshold = floor(0.05*nz*nx); % the children will be found when sum(sign(map)) > threshold
dir = 'right_BPmodel'; %'right_marmousi';
filename = 'mig_BPbenchmark'; %'mig_10Marmousi256x768'; %'true_Marmousi256x768';
vp_mig=dlmread([dir '/' filename '.dat']);

matfilename = [dir '_' filename '_binary_tree' '_threshold' num2str(threshold) '.dat'];
velocity_dir = 'velocity';
system(['mkdir ' velocity_dir])

filename2 = 'true_BPbenchmark'; %'mig_10Marmousi256x768'; %'true_Marmousi256x768';
vp_true=dlmread([dir '/' filename2 '.dat']);

%0.3 smoothing parameters
smooth_num = 200; %smooth number for smoothing clustered velocity
smooth_filter_size = 3;

%0.4 create new model
std_factor = 2; %v = v_mean _ v_std*factor
num_new_model = 100; %number of new velocity
%min and max velocity in each new generated model
min_val = 1.4;
max_val = 5.0;
%min and max r2 of new model with respect to starting model (vp_mig)
min_r2 = 0.5;
max_r2 = 1.0;

disp(['tree_depth = ' num2str(tree_depth)])
disp(['threshold = ' num2str(threshold)])
disp(['num_new_model = ' num2str(num_new_model)])
disp(['std_factor = ' num2str(std_factor)])
disp(['min_val = ' num2str(min_val)])
disp(['max_val = ' num2str(max_val)])
disp(['min_r2 = ' num2str(min_r2)])
disp(['max_r2 = ' num2str(max_r2)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. binary-classification of model using k-means
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(matfilename, 'file') == 0 %if file exists do not repeatedly create
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % vp_mig = dlmread('new_FWI_model199.dat');
    % nz=128;
    % nx=256;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %1.1 Input starting model used for LSRTM
    vp_mig = reshape(vp_mig,nz,nx);
    vp_mig(1:water_depth,:) = 1.5;

    disp('Input a 2-D model output a 2-D model only')
    [nz nx] = size(vp_mig);
    vp_mig = reshape(vp_mig,nz*nx,1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1.2 Define tree structure
    tree = struct('lchild',0,'rchild',0,'value',0);

    root = tree;
    root.value = vp_mig;
    lchild = tree;
    rchild = tree;
    %1.3 Get binary segmentation for root, as no blank area, so the null_num = 0
    [lchild.value, rchild.value]= get_seperated_two_models_for_tree_structure_only(root.value,kmean_num, 0, nz, nx, max_num_group);
    root.lchild = lchild;
    root.rchild = rchild;
    %1.4 Get binary segmentation for children, as blank area exists, so the null_num = 1
    root.lchild = recurr_kmean_decomposition_for_tree_structure_only(root.lchild, kmean_num, 1, nz, nx, max_num_group, tree_depth, threshold);
    root.rchild = recurr_kmean_decomposition_for_tree_structure_only(root.rchild, kmean_num, 1, nz, nx, max_num_group, tree_depth, threshold);
    
    %1.5 save the leaves as array to disk
    segmented_layer = get_model_from_tree_at_leaves(root, nz, nx, tree_depth);
    %1.6 Get feature maps with unique feature (Not 0's)
    num_feature_layers = 0;
    for i = 1:length(segmented_layer(1,:))
        if sum(segmented_layer(:,i)) ~= 0
            num_feature_layers = num_feature_layers + 1;
%         else
%             disp(i)
%             break;
        end
    end
    %1.7 Crop feature layers by deleting 0's feature map
    segmented_layer = segmented_layer(:,1:num_feature_layers);
    
    fid=fopen([matfilename(1:length(matfilename)-4) '.dat'],'wt');
    fprintf(fid,'%15.12f',segmented_layer);
    fclose(fid);
    
%     try
%         disp('Try to save mat file.....');
%         save([matfilename(1:length(matfilename)-4) '.mat']);
%     catch ME
%         disp('mat file is too large to be saved to disk! Save segmented_layer instead!');
%         fid=fopen(matfilename,'wt');
%         fprintf(fid,'%15.12f',segmented_layer);
%         fclose(fid);
%     end
    fid=fopen(matfilename,'wt');
    fprintf(fid,'%15.12f',segmented_layer);
    fclose(fid);
end
%1.6 load the saved array to memory

% try
%     disp('Try to load mat file.....');
%     load([matfilename(1:length(matfilename)-4) '.mat']);
% catch ME
%     disp('mat file does not exist! Load segmented_layer instead!');
%     segmented_layer = dlmread([matfilename(1:length(matfilename)-4) '.dat']);
%     segmented_layer = reshape(segmented_layer,nz*nx,floor(length(segmented_layer)/(nz*nx)));
% end 
segmented_layer = dlmread([matfilename(1:length(matfilename)-4) '.dat']);
segmented_layer = reshape(segmented_layer,nz*nx,floor(length(segmented_layer)/(nz*nx)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. load segmented models and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. check whether  segmentation is complete (reconstruction is correct)
cmap = combine_kmeans_layers_boundary( segmented_layer);

cmap = vp_mig; %only if the difference can be visually ignored!!!

layers_depth1 = root.value;
layers_depth2 = zeros(nz*nx,2);
layers_depth3 = zeros(nz*nx,4);
layers_depth4 = zeros(nz*nx,8);
layers_depth5 = zeros(nz*nx,16);
layers_depth6 = zeros(nz*nx,32);
layers_depth7 = zeros(nz*nx,64);
layers_depth2 = get_model_from_tree_at_depth(root,2,layers_depth2,0);
layers_depth3 = get_model_from_tree_at_depth(root,3,layers_depth3,0);
layers_depth4 = get_model_from_tree_at_depth(root,4,layers_depth4,0);
layers_depth5 = get_model_from_tree_at_depth(root,5,layers_depth5,0);
layers_depth6 = get_model_from_tree_at_depth(root,6,layers_depth6,0);
layers_depth7 = get_model_from_tree_at_depth(root,7,layers_depth7,0);
min_c = 0;
max_c = 4.5;
show_each_figure( layers_depth1, nz, nx, min_c, max_c,1)
show_each_figure( layers_depth2, nz, nx, min_c, max_c,2)
show_each_figure( layers_depth3, nz, nx, min_c, max_c,3)
show_each_figure( layers_depth4, nz, nx, min_c, max_c,4)
show_each_figure( layers_depth5, nz, nx, min_c, max_c,5)
show_each_figure( layers_depth6, nz, nx, min_c, max_c,6)
show_each_figure( layers_depth7, nz, nx, min_c, max_c,7)