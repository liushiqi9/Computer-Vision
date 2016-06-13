%load the video
load('blackcup.mat')
video=blackcup;
[videox,videoy,videoz,videot]=size(video);
Image=video(:,:,:,1);
figure, imshow(Image), hold on
[x,y]=ginput(2);
plot([x(1),x(2)],[y(1),y(1)],'green');
plot([x(1),x(2)],[y(2),y(2)],'green');
plot([x(1),x(1)],[y(1),y(2)],'green');
plot([x(2),x(2)],[y(1),y(2)],'green');

Model=Image(y(1):y(2),x(1):x(2),:);
[Modelx,Modely,Modelz]=size(Model);
mask=ones(Modelx,Modely);
Mhist=zeros(8,8,8);

for i=1:Modelx
    for j=1:Modely
          r=min(floor(Model(i,j,1)/32+1),8);
          g=min(floor(Model(i,j,2)/32+1),8);
          b=min(floor(Model(i,j,3)/32+1),8);
          Mhist(r,g,b)=Mhist(r,g,b)+1;
    end
end
for t=1:videot
    Image=video(:,:,:,t);
    [Imagex,Imagey,Imagez]=size(Image);
    Ihist=zeros(8,8,8);
    for i=1:Imagex
      for j=1:Imagey
          r=min(floor(Image(i,j,1)/32+1),8);
          g=min(floor(Image(i,j,2)/32+1),8);
          b=min(floor(Image(i,j,3)/32+1),8);
          Ihist(r,g,b)=Ihist(r,g,b)+1;
      end
    end

    ratio=zeros(8,8,8);
    for r=1:8
      for g=1:8
        for b=1:8
          if Ihist(r,g,b)>0
            ratio(r,g,b)=min(Mhist(r,g,b)/Ihist(r,g,b),1);
          end
        end
      end
    end

    Imageratio=zeros(Imagex,Imagey);
    for i=1:Imagex
      for j=1:Imagey
          r=min(floor(Image(i,j,1)/32+1),8);
          g=min(floor(Image(i,j,2)/32+1),8);
          b=min(floor(Image(i,j,3)/32+1),8);
          Imageratio(i,j)=ratio(r,g,b);
      end
    end

    ImagePosible=filter2(mask,Imageratio,'valid');
    [Max,Index]=max(ImagePosible(:));
    [I_row, I_col] = ind2sub(size(ImagePosible),Index);
    
    for x=I_row:I_row+Modelx
        video(x,I_col,1,t)=0;
        video(x,I_col,2,t)=256;
        video(x,I_col,3,t)=0;
        video(x,I_col+Modely,1,t)=0;
        video(x,I_col+Modely,2,t)=256;
        video(x,I_col+Modely,3,t)=0;        
    end
    for y=I_col:I_col+Modely
        video(I_row,y,1,t)=0;
        video(I_row,y,2,t)=256;
        video(I_row,y,3,t)=0;
        video(I_row+Modelx,y,1,t)=0;
        video(I_row+Modelx,y,2,t)=256;
        video(I_row+Modelx,y,3,t)=0;        
    end
end
implay(video);