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
first_level = kmean_num*10; %for main group index
second_level = 1; % for sub group index
vel_sigma = 20; %after getting the mean and variance of the clustered models, randomly choose value from distribution
smooth_num = 200; %smooth number for smoothing clustered velocity
smooth_filter_size = 3;
water_depth = 6;
vp_mig=dlmread(['mig_20Marmousi256x768.dat']);
vp_mig = reshape(vp_mig,nz,nx);
vp_mig(1:water_depth,:) = 1.5;
figure(1)
show2d(vp_mig);caxis([0 4.5]);


disp('Input a 2-D model output a 2-D model only')
[nz nx] = size(vp_mig);
vp_mig = reshape(vp_mig,nz*nx,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st-level segmentation
% 0 denotes that there is no blank area

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1. assign labels to different group
[map1 map2] = get_seperated_two_models(vp_mig,kmean_num, 0, nz, nx );
figure(2)
subplot(2,1,1)
show2d(map1);caxis([0 4.5]);
subplot(2,1,2)
show2d(map2);caxis([0 4.5]);


[map11 map12] = get_seperated_two_models(map1,kmean_num, 1, nz, nx );
[map21 map22] = get_seperated_two_models(map2,kmean_num, 1, nz, nx );
figure(3)
subplot(2,2,1)
show2d(map11);caxis([0 4.5]);
subplot(2,2,2)
show2d(map12);caxis([0 4.5]);
subplot(2,2,3)
show2d(map21);caxis([0 4.5]);
subplot(2,2,4)
show2d(map22);caxis([0 4.5]);


[map111 map112] = get_seperated_two_models(map11,kmean_num, 1, nz, nx );
[map121 map122] = get_seperated_two_models(map12,kmean_num, 1, nz, nx );
[map211 map212] = get_seperated_two_models(map21,kmean_num, 1, nz, nx );
[map221 map222] = get_seperated_two_models(map22,kmean_num, 1, nz, nx );

figure(4)
subplot(2,4,1)
show2d(map111);caxis([0 4.5]);
subplot(2,4,2)
show2d(map112);caxis([0 4.5]);
subplot(2,4,3)
show2d(map121);caxis([0 4.5]);
subplot(2,4,4)
show2d(map122);caxis([0 4.5]);
subplot(2,4,5)
show2d(map211);caxis([0 4.5]);
subplot(2,4,6)
show2d(map212);caxis([0 4.5]);
subplot(2,4,7)
show2d(map221);caxis([0 4.5]);
subplot(2,4,8)
show2d(map222);caxis([0 4.5]);


[map1111 map1112] = get_seperated_two_models(map111,kmean_num, 1, nz, nx );
[map1121 map1122] = get_seperated_two_models(map112,kmean_num, 1, nz, nx );
[map1211 map1212] = get_seperated_two_models(map121,kmean_num, 1, nz, nx );
[map1221 map1222] = get_seperated_two_models(map122,kmean_num, 1, nz, nx );
[map2111 map2112] = get_seperated_two_models(map211,kmean_num, 1, nz, nx );
[map2121 map2122] = get_seperated_two_models(map212,kmean_num, 1, nz, nx );
[map2211 map2212] = get_seperated_two_models(map221,kmean_num, 1, nz, nx );
[map2221 map2222] = get_seperated_two_models(map222,kmean_num, 1, nz, nx );



figure(5)
subplot(4,4,1)
show2d(map1111);caxis([0 4.5]);
subplot(4,4,2)
show2d(map1112);caxis([0 4.5]);
subplot(4,4,3)
show2d(map1121);caxis([0 4.5]);
subplot(4,4,4)
show2d(map1122);caxis([0 4.5]);
subplot(4,4,5)
show2d(map1211);caxis([0 4.5]);
subplot(4,4,6)
show2d(map1212);caxis([0 4.5]);
subplot(4,4,7)
show2d(map1221);caxis([0 4.5]);
subplot(4,4,8)
show2d(map1222);caxis([0 4.5]);
subplot(4,4,9)
show2d(map2111);caxis([0 4.5]);
subplot(4,4,10)
show2d(map2112);caxis([0 4.5]);
subplot(4,4,11)
show2d(map2121);caxis([0 4.5]);
subplot(4,4,12)
show2d(map2122);caxis([0 4.5]);
subplot(4,4,13)
show2d(map2211);caxis([0 4.5]);
subplot(4,4,14)
show2d(map2212);caxis([0 4.5]);
subplot(4,4,15)
show2d(map2221);caxis([0 4.5]);
subplot(4,4,16)
show2d(map2222);caxis([0 4.5]);



% 
% 
% 
% figure(2)
% subplot(2,2,1)
% show2d(kmean_num_11_set(:,1));caxis([0 4.5]);
% subplot(2,2,2)
% show2d(kmean_num_11_set(:,2));caxis([0 4.5]);
% subplot(2,2,3)
% show2d(kmean_num_12_set(:,1));caxis([0 4.5]);
% subplot(2,2,4)
% show2d(kmean_num_12_set(:,2));caxis([0 4.5]);
% 
% figure(3)
% subplot(2,4,1)
% show2d(kmean_num_111_set(:,1));caxis([0 4.5]);
% subplot(2,4,2)
% show2d(kmean_num_111_set(:,2));caxis([0 4.5]);
% subplot(2,4,3)
% show2d(kmean_num_112_set(:,1));caxis([0 4.5]);
% subplot(2,4,4)
% show2d(kmean_num_112_set(:,2));caxis([0 4.5]);
% subplot(2,4,5)
% show2d(kmean_num_121_set(:,1));caxis([0 4.5]);
% subplot(2,4,6)
% show2d(kmean_num_121_set(:,2));caxis([0 4.5]);
% subplot(2,4,7)
% show2d(kmean_num_122_set(:,1));caxis([0 4.5]);
% subplot(2,4,8)
% show2d(kmean_num_122_set(:,2));caxis([0 4.5]);
%     
%     
%     
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