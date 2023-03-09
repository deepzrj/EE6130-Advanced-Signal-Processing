clc;
clear all;
close all;

load('Black_Fence');
lightField=LF;
%uv is the lense plane ,totally u*v different views
%x :height of each img
%y :width of each mg
[u,v,x,y,channel]=size(lightField);
% (u,v,x,y,rgb) , thus 5 dimensions

%red channel of u,v aperture view
k=0;
for i=1:u
     for j=1:v
        k=k+j;
        ar{k}=lightField(i,j,:,:,1); %creating cell
     end 
end
ar=ar(~cellfun('isempty',ar));
for k=1:(u*v)
      for i =1:x
           for j=1:y
              ar1{k}(i,j)=ar{k}(:,:,i,j);
           end
      end
end


%green channel of u ,v aperture view
k=0;
for i=1:u
     for j=1:v
        k=k+j;
        ag{k}=lightField(i,j,:,:,2);
     end 
end
ag=ag(~cellfun('isempty',ag));
for k=1:(u*v)
      for i =1:x
           for j=1:y
              ag1{k}(i,j)=ag{k}(:,:,i,j);
           end
      end
end


%blue channel of u ,v aperture view
k=0;
for i=1:u
     for j=1:v
        k=k+j;
        ab{k}=lightField(i,j,:,:,3);
     end 
end
ab=ab(~cellfun('isempty',ab));
for k=1:(u*v)
      for i =1:x
           for j=1:y
              ab1{k}(i,j)=ab{k}(:,:,i,j);
           end
      end
end



 %rgb img
 for k=1:(u*v)
     blackfence_extracted{k}=cat(3,(ar1{k}),(ag1{k}),(ab1{k}));
 end
 save blackfence_extracted;

 
 
 
 
 %save individual images in the folder
 for k=1:(u*v)
     imwrite((blackfence_extracted{k}),sprintf('blackfencenew%d.png',k)); 
end