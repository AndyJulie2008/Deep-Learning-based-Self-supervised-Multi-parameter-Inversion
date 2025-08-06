% clear all
% close all
% clc
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
cvalue = 0.005;
%------------------ colorbar setting----------------------------

%---------------------------------------------------------
%  0 parameter setup
%---------------------------------------------------------
%input data info
nx = 1000;
nz = 300;
a=1;b=a+256-1;
c=601;%1,301,601
d=c+256-1

%One purpose: replace rtm image (calculated by pysit) by preprocessed
%             image
fid1=fopen('smvpmodel','r');
vp = fread(fid1,[nx nz],'float32').';
fclose(fid1);

fid1=fopen('smvsmodel','r');
vs = fread(fid1,[nx nz],'float32').';
fclose(fid1);

fid1=fopen('smrhomodel','r');
rho = fread(fid1,[nx nz],'float32').';
fclose(fid1);

fid1=fopen('epsimodel','r');
epsi = fread(fid1,[nx nz],'float32').';
fclose(fid1);

fid1=fopen('deltamodel','r');
delta = fread(fid1,[nx nz],'float32').';
fclose(fid1);

v_hor=vp.*sqrt(1+2*epsi);
v_nmo=vp.*sqrt(1+2*delta);

figure(1)
subplot(2,3,1);imagesc(vp(a:b,c:d));title('vp')
subplot(2,3,2);imagesc(vs(a:b,c:d));title('vs')
subplot(2,3,3);imagesc(rho(a:b,c:d));title('rho')
subplot(2,3,4);imagesc(v_hor(a:b,c:d));title('epsi')
subplot(2,3,5);imagesc(v_nmo(a:b,c:d));title('delta')
% 
% % decimal output
% disp(name)
% disp(size(v)) 
% fid=fopen([output_directory '/' name],'wt');
% fprintf(fid,'%20.8f',v);
% fclose(fid);
% 
% % binary output
% %     fid = fopen(name,'w');
% %     fwrite(fid,train_data,'float32');
% %     fclose(fid);

