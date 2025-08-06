% % %this code should be used only after 
% % %Binary_kmeans_model_morphology_leaves_only.m
[totaln num_feature_layer] = size(segmented_layer);

flag = 0;
count = 0;
while flag == 0
    try
        kmeans_map = kmeans(vp_mig,num_feature_layer,'EmptyAction','singleton');
    catch ME
        flag = 0;
        count = count + 1;
        if count > 100  && mod(count,10) == 0
            disp(['repeat at ' num2str(count) ' times']);
        end
        continue;
    end
    flag = 1;
end
    
kmeans_segmented_layer = zeros(nz*nx,num_feature_layer);
for i = 1 : nz*nx
    kmeans_segmented_layer(i,kmeans_map(i)) = vp_mig(i);
end

% %show puzzled feature map:
puzzle_layer1 = get_puzzle_layer(kmeans_segmented_layer(:,131-64-64+1:131-64),6,6,nz,nx, 0, 5.0,1123);
puzzle_layer2 = get_puzzle_layer(kmeans_segmented_layer(:,131-64+1:131),6,6,nz,nx, 0, 5.0,1321);
% 
%3.2 (abandon)plot original model with boundaries 
% for combination, do not use the functions
% (extract_individual_kmeans_layers_boundary.m)
% and (combine_kmeans_layers.m) 
% Instead, use function (extract_whole_model_boundary.m)
% kmeans_segmented_layer_boundary = extract_individual_kmeans_layers_boundary(sign(kmeans_segmented_layer), nz, nx, threshold/2);
% kmeans_segmented_layer_combine_boundary = combine_kmeans_layers(kmeans_segmented_layer_boundary)*1000;

%3.3 (adopted) plot original model with boundaries 
[kmeans_boundary_map,kmeans_color_map] = extract_whole_model_boundary(kmeans_segmented_layer, nz, nx);
min_c = 0;
max_c = 5;
kmeans_boundary_map = reshape(kmeans_boundary_map,nz*nx,1);


%%%%%%%%%%%%%%%%%%%%%
% plot FWI result first
%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------
%------------------ Plot the velocity models--------------------
hfig1 = figure(1101);
sh = 0.02;
sv = 0.045;
padding = 0.0;
margin = 0.1;

%---------------------------------------------------------------
% Plot the True and Initial velocity models
subaxis(3, 1, 1, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reshape(cmap,nz,nx))
caxis([1.5 4.5]);
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.00','2.88','5.76','8.64'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; 
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
ylabel('Depth (km)');
text(-89.5208333333333, -55.5041666666666,'a)') %get from the code of figure
c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Velocity (km/s)';
set(c,'YTick',[1.5,2.5,3.5,4.5])
set(c,'YTickLabels',{'1.5','2.5','3.5','4.5'})
set(colorTitleHandle ,'String',titleString);
set(c,'Position',[0.78861607142857 0.662698412698413 0.0167410714285708 0.239988326971447]) %get from the code of figure

subaxis(3, 1, 2, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reshape(kmeans_color_map,nz,nx))
% caxis([1.5 4.5]);
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{''}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; caxis([1 num_feature_layer+20]) 
xlim([1 nx]);ylim([1 nz]);
ylabel('Depth (km)');
text(-89.5208333333333, 0.204166666666765,'b)') %get from the code of figure
c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Cluster index';
set(colorTitleHandle ,'String',titleString);
set(c,'Position',[0.788616071428568 0.378968253968254 0.0167410714285708 0.239988326971448]) %get from the code of figure

boundary_map = reshape(boundary_map,nz*nx,1);
subaxis(3, 1, 3, 'sh', sh, 'sv', sv, 'padding', padding, 'margin', margin);
imagesc(reshape(color_map+boundary_map*100,nz,nx))
% caxis([1.5 4.5]);
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [])            
set(gca,'XTickLabel',{''}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; caxis([1 num_feature_layer+20]) 
xlim([1 nx]);ylim([1 nz]);
ylabel('Depth (km)');
text(-87.9291666666666, 0.204166666666652,'c)') %get from the code of figure

c = colorbar();
colorTitleHandle = get(c,'YLabel');
titleString = 'Cluster index';
set(colorTitleHandle ,'String',titleString);
set(c,'Position',[0.78861607142857 0.0992063492063492 0.0167410714285708 0.2360200730032]) %get from the code of figure






figure(1102)
subplot(2,1,1)
imagesc(reshape(kmeans_color_map,nz,nx))
caxis([-5  length(kmeans_segmented_layer(1,:))+10])
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1 nx/3 nx/3*2 nx])            
set(gca,'XTickLabel',{'0.00','2.88','5.76','8.64'}) 
set(gca, 'YTick', [1 nx/6 nx/3])          
set(gca,'YTickLabel',{'0.00','1.44','2.88'})  
axis equal; 
xlabel('Distance (km)'); 
xlim([1 nx]);ylim([1 nz]);
ylabel('Depth (km)');
c = colorbar();
colorTitleHandle = get(c,'XLabel');
titleString = 'Index value';
set(colorTitleHandle ,'String',titleString);
set(c,'Position',[0.23363095238095 0.550958994708988 0.566964285714288 0.0300595238095237]) %get from the code of figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4. Get each group's mean and std
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%4.3 get mean and std for each feature map 
% Notice that matlab-built-in mean and variance is not proper since
% feature map has blank area which should be excluded in calculation
kmeans_hash_map_value = get_mean_std( kmeans_segmented_layer);
figure(1000);plot(kmeans_hash_map_value(:,1),kmeans_hash_map_value(:,2),'*');
hold on;plot(hash_map_value(:,1),hash_map_value(:,2),'ro');
xlabel('Mean velocity (km/s)');ylabel('std velocity (km/s)');
legend('divisive hierarchical k-means','k-means',2)
set(gca,'XAxisLocation','top');
set(gca, 'XTick', [1.5 2.5 3.5 4.5])            
set(gca,'XTickLabel',{'1.5','2.5','3.5','4.5'}) 
set(gca, 'YTick', [0 0.05 0.1 0.15 0.2])          
set(gca,'YTickLabel',{'0.00','0.05','0.10','0.15','0.20'})  
% fid=fopen(['new_model_mean_std_.dat'],'wt');
% fprintf(fid,'%9.6f',kmeans_hash_map_value);
% fclose(fid);
%for read and plot a = ['new_model_mean_std_.dat']; a = reshape(a,34,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%5. Create random Marmousi model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get random value for each group which satisfies normal distribution
kmeans_r2_value = zeros(num_new_model,2);
figure(10000)

vp_new_set = zeros(nz*nx,num_new_model);
k = 1;
while k <= num_new_model
    kmeans_hash_map_value_randn = normal_dist(kmeans_hash_map_value(:,1),kmeans_hash_map_value(:,2)*std_factor,min_val,max_val);
    vp_new = zeros(nz*nx,1);
    for i = 1:length(kmeans_segmented_layer(1,:))
            vp_new = vp_new + sign(kmeans_segmented_layer(:,i))*kmeans_hash_map_value_randn(i);
    end
    kmeans_r2_value(k,1) = R2(vp_mig,vp_new);
    kmeans_r2_value(k,2) = R2(vp_true,vp_new);
    if kmeans_r2_value(k,1) <min_r2 || kmeans_r2_value(k,1) > max_r2
        continue; %skip this generated model
    else
%         fid=fopen([velocity_dir '/' 'kmeans_model' num2str(k) 'r2_sm' num2str(floor(kmeans_r2_value(k,1)*100)) 'r2_tr' num2str(floor(kmeans_r2_value(k,2)*100)) '.dat'],'wt');
%         fprintf(fid,'%9.6f',vp_new);
%         fclose(fid);

        vp_new_set(:,k) = vp_new;
        show2d(vp_new,nz,nx);caxis([1.5 4.5]);title([num2str(k) 'th model with R2 = ' num2str(kmeans_r2_value(k,1))]);
        drawnow;
        pause(0.1);
        k = k + 1;

    end
end

%show puzzled feature map:
puzzle_layer1 = get_puzzle_layer(vp_new_set,7,5,nz,nx, 1.5, 5,12345);

%plot and save r2 value
figure(10001)
plot(r2_value(:,1),'b');
hold on;
plot(r2_value(:,2),'b-.');
hold on;
plot(kmeans_r2_value(:,1),'r');
hold on;
plot(kmeans_r2_value(:,2),'r-.');
legend('divisive hierarchical k-means','k-means',4)
xlabel('Number of training model');ylabel('Correlation coefficient')
ylim([0.85 1])
set(gca, 'YTick', [0.85 0.90 0.95 1])          
set(gca,'YTickLabel',{'0.85' '0.90' '0.95' '1.00'})
% fid=fopen(['new_model_r2_.dat'],'wt');
% fprintf(fid,'%9.6f',kmeans_r2_value);
% fclose(fid);