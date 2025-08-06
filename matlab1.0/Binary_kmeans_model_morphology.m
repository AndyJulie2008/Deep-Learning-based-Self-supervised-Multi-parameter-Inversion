clear all
pack
%close all
clc
%%%%%%%%%%%%%%%%%%%%%
% Strategy: maximize the number of clusters at the first and second steps
% Randomly choose the final number of clusters to output model
%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%0. Set parameters and input starting model
nz=256;
nx=256*3;
max_iteration = 300;
kmean_num = 2; %binary segmentation
num_label = 100; %used to label the clustered model (contains many isolated islands)
max_num_group = 2; %Given the num_label, keep the first k biggest groups (HERE IT SHOULD BE 2s)
vel_sigma = 20; %after getting the mean and variance of the clustered models, randomly choose value from distribution
smooth_num = 200; %smooth number for smoothing clustered velocity
smooth_filter_size = 3;
water_depth = 6;
tree_depth = 7;
dir = 'right_marmousi';
filename = 'true_Marmousi256x768';
vp_mig=dlmread([dir '/' filename '.dat']);
matfilename = [dir '_' filename '_binary_tree.mat'];
if exist(matfilename, 'file') == 0 %if file exists do not repeatedly create
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % vp_mig = dlmread('new_FWI_model199.dat');
    % nz=128;
    % nx=256;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vp_mig = reshape(vp_mig,nz,nx);
    vp_mig(1:water_depth,:) = 1.5;



    disp('Input a 2-D model output a 2-D model only')
    [nz nx] = size(vp_mig);
    vp_mig = reshape(vp_mig,nz*nx,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1st-level segmentation
    % 0 denotes that there is no blank area
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1. Define tree structure
    tree = struct('lchild',0,'rchild',0,'value',0);

    root = tree;
    root.value = vp_mig;
    lchild = tree;
    rchild = tree;
    [lchild.value, rchild.value]= get_seperated_two_models_for_tree_structure_only(root.value,kmean_num, 0, nz, nx, num_label, max_num_group);
    root.lchild = lchild;
    root.rchild = rchild;
    root.lchild = recurr_kmean_decomposition_for_tree_structure_only(root.lchild, kmean_num, 1, nz, nx, num_label, max_num_group, tree_depth);
    root.rchild = recurr_kmean_decomposition_for_tree_structure_only(root.rchild, kmean_num, 1, nz, nx, num_label, max_num_group, tree_depth);


    save(matfilename);
end
load(matfilename);


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
show2d(layers_depth1, nz, nx);caxis([min_c max_c]);
show2dlayer( layers_depth2, 2, 1, 2, nz, nx, min_c, max_c);
show2dlayer( layers_depth3, 3, 2, 2, nz, nx, min_c, max_c);
show2dlayer( layers_depth4, 4, 2, 4, nz, nx, min_c, max_c);
show2dlayer( layers_depth5, 5, 4, 4, nz, nx, min_c, max_c);
show2dlayer( layers_depth6, 6, 4, 8, nz, nx, min_c, max_c);
show2dlayer( layers_depth7, 7, 8, 8, nz, nx, min_c, max_c);
% % % % % 
% % % % % 
% % % % % 
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % %1. Assign labels to different group
% % % % % map1 = gen_kmeans_layers( vp_mig, kmean_num, nz, nx, 0, num_label, max_num_group);
% % % % % map2 = gen_kmeans_layers( map1, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map3 = gen_kmeans_layers( map2, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map4 = gen_kmeans_layers( map3, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map5 = gen_kmeans_layers( map4, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map6 = gen_kmeans_layers( map5, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map7 = gen_kmeans_layers( map6, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map8 = gen_kmeans_layers( map7, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map9 = gen_kmeans_layers( map7, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % map10 = gen_kmeans_layers( map7, kmean_num, nz, nx, 1, num_label, max_num_group);
% % % % % 
% % % % % %2. Get binary map (because all velocity > 0)
% % % % % sign_map1 = sign(map1);
% % % % % sign_map2 = sign(map2);
% % % % % sign_map3 = sign(map3);
% % % % % sign_map4 = sign(map4);
% % % % % sign_map5 = sign(map5);
% % % % % sign_map6 = sign(map6);
% % % % % sign_map7 = sign(map7);
% % % % % %3. Boundary extraction (morphological algorithms)
% % % % % bmap1 = extract_kmeans_layers_boundary(sign_map1, nz, nx);
% % % % % bmap2 = extract_kmeans_layers_boundary(sign_map2, nz, nx);
% % % % % bmap3 = extract_kmeans_layers_boundary(sign_map3, nz, nx);
% % % % % bmap4 = extract_kmeans_layers_boundary(sign_map4, nz, nx);
% % % % % bmap5 = extract_kmeans_layers_boundary(sign_map5, nz, nx);
% % % % % bmap6 = extract_kmeans_layers_boundary(sign_map6, nz, nx);
% % % % % bmap7 = extract_kmeans_layers_boundary(sign_map7, nz, nx);
% % % % % 
% % % % % % 4. Add this boundary to the starting model (notice boudary width is 2)
% % % % % % because each seperated group has its own boundary
% % % % % cmap1 = combine_kmeans_layers_boundary( bmap1)*1000;
% % % % % cmap2 = combine_kmeans_layers_boundary( bmap2)*1000;
% % % % % cmap3 = combine_kmeans_layers_boundary( bmap3)*1000;
% % % % % cmap4 = combine_kmeans_layers_boundary( bmap4)*1000;
% % % % % cmap5 = combine_kmeans_layers_boundary( bmap5)*1000;
% % % % % cmap6 = combine_kmeans_layers_boundary( bmap6)*1000;
% % % % % cmap7 = combine_kmeans_layers_boundary( bmap7)*1000;
% % % % % 
% % % % % 
% % % % % 
% % % % % 
% % % % % 
% % % % % 
% % % % % 
% % % % % 
% % % % % 
% % % % % close all;
% % % % % figure(1)
% % % % % min_c = 0;
% % % % % max_c = 4.5;
% % % % % show2d(vp_mig, nz, nx);caxis([min_c max_c]);
% % % % % show2dlayer( map1, 2, 1, 2, nz, nx, min_c, max_c);
% % % % % show2dlayer( map2, 3, 2, 2, nz, nx, min_c, max_c);
% % % % % show2dlayer( map3, 4, 2, 4, nz, nx, min_c, max_c);
% % % % % show2dlayer( map4, 5, 4, 4, nz, nx, min_c, max_c);
% % % % % show2dlayer( map5, 6, 4, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( map6, 7, 8, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( map7, 8, 16, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( map8, 9, 16, 16, nz, nx, min_c, max_c);
% % % % % show2dlayer( map9, 10, 32, 16, nz, nx, min_c, max_c);
% % % % % show2dlayer( map10, 11, 32, 32, nz, nx, min_c, max_c);
% % % % % min_c = 0;
% % % % % max_c = 1;
% % % % % show2dlayer( sign_map1, 12, 1, 2, nz, nx, min_c, max_c);
% % % % % show2dlayer( sign_map2, 13, 2, 2, nz, nx, min_c, max_c);
% % % % % show2dlayer( sign_map3, 14, 2, 4, nz, nx, min_c, max_c);
% % % % % show2dlayer( sign_map4, 15, 4, 4, nz, nx, min_c, max_c);
% % % % % show2dlayer( sign_map5, 16, 4, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( sign_map6, 17, 8, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( sign_map7, 18, 16, 8, nz, nx, min_c, max_c);
% % % % % 
% % % % % min_c = 0;
% % % % % max_c = 1;
% % % % % show2dlayer( bmap1, 22, 1, 2, nz, nx, min_c, max_c);
% % % % % show2dlayer( bmap2, 23, 2, 2, nz, nx, min_c, max_c);
% % % % % show2dlayer( bmap3, 24, 2, 4, nz, nx, min_c, max_c);
% % % % % show2dlayer( bmap4, 25, 4, 4, nz, nx, min_c, max_c);
% % % % % show2dlayer( bmap5, 26, 4, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( bmap6, 27, 8, 8, nz, nx, min_c, max_c);
% % % % % show2dlayer( bmap7, 28, 16, 8, nz, nx, min_c, max_c);
% % % % % 
% % % % % min_c = 1.5;
% % % % % max_c = 10;
% % % % % show2dlayer( cmap1 + vp_mig, 32, 1, 1, nz, nx, min_c, max_c);
% % % % % show2dlayer( cmap2 + vp_mig, 33, 1, 1, nz, nx, min_c, max_c);
% % % % % show2dlayer( cmap3 + vp_mig, 34, 1, 1, nz, nx, min_c, max_c);
% % % % % show2dlayer( cmap4 + vp_mig, 35, 1, 1, nz, nx, min_c, max_c);
% % % % % show2dlayer( cmap5 + vp_mig, 36, 1, 1, nz, nx, min_c, max_c);
% % % % % show2dlayer( cmap6 + vp_mig, 37, 1, 1, nz, nx, min_c, max_c);
% % % % % show2dlayer( cmap7 + vp_mig, 38, 1, 1, nz, nx, min_c, max_c);
% % % % % 
% % % % % 
% % % % % 
% % % % % matfilename = [dir '_' filename '.mat'];
% % % % % save(matfilename)
% % % % % load(matfilename);
% % % % % 



% %     
% %     
% %     
% %     
% %     
% %     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %3. Get each group's mean and variance
%     %   Notice: This hash map may have empty value, hash-map value is the number of points
%     hash_map_count = zeros(kmean_num*first_level+kmean_num*second_level,1);
%     hash_map_value = zeros(kmean_num*first_level+kmean_num*second_level,2);%mean,variance
% 
%     vp_mig = reshape(vp_mig,nz*nx,1);
%     % compute mean values for each group
%     for i = 1:nz*nx
%         hash_map_count(vp_index_map_1(i)) = hash_map_count(vp_index_map_1(i)) + 1;
%         hash_map_value(vp_index_map_1(i),1) = hash_map_value(vp_index_map_1(i),1) +vp_mig(i);
%     end
%     hash_map_value(:,1) = hash_map_value(:,1) ./ hash_map_count;
% 
%     % compute variance for each group
%     % vars(x) = 1/n*sum(x - x_bar)^2
%     for i = 1:nz*nx
%         hash_map_value(vp_index_map_1(i),2) = hash_map_value(vp_index_map_1(i),2) + (vp_mig(i) - hash_map_value(vp_index_map_1(i),1))^2;
%     end
%     hash_map_value(:,2) = hash_map_value(:,2) ./ hash_map_count;
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %4. Randomly pick a value for each clusted group as  velocity value
%     %get random value for each group which satisfies normal distribution
%     hash_map_value_randn = normal_dist(hash_map_value(:,1),hash_map_value(:,2)*vel_sigma);
%     vp_cluster = zeros(nz,nx);
%     vp_index_map_1 = reshape(vp_index_map_1,nz,nx);
%     for ix = 1:nx
%         for iz = 1:nz
%             vp_cluster(iz,ix) = hash_map_value_randn(vp_index_map_1(iz,ix),1);
%         end
%     end
% 
% 






















% vp_cluster_reflectivity = reflectivity_model(vp_cluster);


% 
% 
% figure(1)
% subplot(2,4,1)
% imagesc(vp_true);caxis([1.5 4.5])
% title('First-cluster index map')
% subplot(2,4,5)
% imagesc(true_reflectivity);
% title('Second-cluster index map')
% 
% subplot(2,4,2)
% imagesc(vp_mig);caxis([1.5 4.5])
% title('First-cluster index map')
% text(210.998338870432, 284.636222910217,['R2= ' num2str(R2(vp_true,vp_mig))])
% 
% subplot(2,4,6)
% imagesc(vp_mig_reflectivity);
% title('Second-cluster index map')
% 
% subplot(2,4,3)
% imagesc(vp_cluster));caxis([0 4.5]);
% title('Second-cluster index map')
% text(210.998338870432, 284.636222910217,['R2 to true= ' num2str(R2(vp_true,vp_cluster))])
% text(210.998338870432, 304.636222910217,['R2 to invt = ' num2str(R2(vp_mig,vp_cluster))])
% 
% subplot(2,4,7)
% imagesc(sign(vp_cluster_reflectivity));
% title('Second-cluster')
% 
% subplot(2,4,4)
% imagesc(vp_cluster2));caxis([0 4.5]);
% title('Second-cluster index map')
% text(210.998338870432, 284.636222910217,['R2 to true= ' num2str(R2(vp_true,vp_cluster2))])
% text(210.998338870432, 304.636222910217,['R2 to invt = ' num2str(R2(vp_mig,vp_cluster2))])
% 
% subplot(2,4,8)
% imagesc(sign(vp_cluster2_reflectivity));
% title('Second-cluster')
% figure(2)
% subplot(1,2,1)
% plot(hash_map_value(:,1),'o');
% title('Mean')
% subplot(1,2,2)
% plot(hash_map_value(:,2),'o');
% title('Variance')
% 
% 
% 
% 
% figure(3)
% subplot(1,3,1)
% imagesc(vp_mig)
% subplot(1,3,2)
% imagesc(vp_cluster)
% subplot(1,3,3)
% imagesc(vp_cluster - vp_mig)