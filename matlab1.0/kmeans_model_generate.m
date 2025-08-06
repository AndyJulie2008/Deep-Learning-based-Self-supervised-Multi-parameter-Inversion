clear all
pack
close all
clc

nx=512;
nz=256;
smooth_num = 21
kmean_num = 11;
vp_true=dlmread('true_Marmousi256x512.dat');
vp_mig=dlmread(['mig_' num2str(smooth_num) 'Marmousi256x512.dat']);
true_reflectivity=dlmread('reflectivityMarmousi256x512.dat');
vp_true = reshape(vp_true,nz,nx);
true_reflectivity = reshape(true_reflectivity,nz,nx);
vp_mig = reshape(vp_mig,nz,nx);

figure(10000)
imagesc(vp_mig);
caxis([1.5 4.5]);

figure(smooth_num)
subplot(2,4,1)
imagesc(vp_true);caxis([1.5 4.5]);
title('True model');

subplot(2,4,2)
imagesc(true_reflectivity)
title('true reflectivity');


vp_cluster = kmeans_model( vp_mig,kmean_num,1);
mig_reflectivity = reflectivity_model(vp_cluster);
subplot(2,4,3)
imagesc(vp_cluster);caxis([1.5 4.5]);
title('fake true model');
subplot(2,4,4)
imagesc(mig_reflectivity)
title('fake true  reflectivity');




vp_cluster = kmeans_model( vp_mig,kmean_num,2);
mig_reflectivity = reflectivity_model(vp_cluster);

subplot(2,4,5)
imagesc(vp_cluster);caxis([1.5 4.5]);
title('fake true model');

subplot(2,4,6)
imagesc(mig_reflectivity)
title('fake true  reflectivity');




vp_cluster = kmeans_model( vp_mig,kmean_num,3);
mig_reflectivity = reflectivity_model(vp_cluster);

subplot(2,4,7)
imagesc(vp_cluster);caxis([1.5 4.5]);
title('fake true model');

subplot(2,4,8)
imagesc(mig_reflectivity)
title('fake true  reflectivity');