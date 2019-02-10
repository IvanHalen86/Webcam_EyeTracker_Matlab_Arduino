
% create an arduino object. instead of "/dev/cu.usbmodem1411','BaudRate"
% use your serail port name. You can check it in arduino -> tools -> port.
% Write the name of your port before the command 'BaudRate' in the
% following string.

ar = serial('/dev/cu.usbmodem1411','BaudRate',9600);
% create a camera object. Check for the camera name with the command
% webcamlist() in matlab.
cameras= webcamlist();
% open the matrix camera and see which camera correspond to your modified webcam. select that camera just by entering an index
% within the curly brackets. It could be 1, 2, 3... depends on hwo many webcams you have acctached on your computer
mycamera = cameras{2}
% create a 'cam' variable with your camera name
cam = webcam(char(mycamera))

%check if the camera is positioned in the right way, with the focus on the
%center of the eye. The "preview" command let you see what the camera see.
preview(cam)

%open arduino USB port
fopen(ar);

% send the pulse to the port number 2 of arduino
fprintf(ar,'%s',char(3));

% preallocate the matrix with the cooridnates data
coordinate = zeros(50,2);

for i = 1:50;

% take a snapshot
img = snapshot(cam);

% calculate the center of the image

filas=size(img,1);
columnas=size(img,2);
% Center
centro_fila=round(filas/2);
centro_columna=round(columnas/2);
figure(1);

% transform the image in a BW image
if size(img,3)==3
    la_imagen=rgb2gray(img);
end

 piel=~im2bw(la_imagen,0.1);
%     --
 piel=bwmorph(piel,'close');
 piel=bwmorph(piel,'open');
 piel=bwareaopen(piel,200);
 piel=imfill(piel,'holes');

% Tagged objects in BW image
L=bwlabel(piel);
% Get areas and tracking rectangle
out_a=regionprops(L);
% Count the number of objects
N=size(out_a,1);
while N < 1 || isempty(out_a) % Returns if no object in the image
    solo_cara=[ ];
    continue
end

% Select the area
areas=[out_a.Area];
[area_min pam_min]=min(areas);
[area_max pam_max]=max(areas);

% since there is a problem with the shades in the BW images (the algorithm detect the size of the black
% shades in th eimage), we have to create an if statement where we declare that if the algorithm
% detect a too big black area (threshold set on 10000), it has to consider the
% smallest detected area as the pupil.
% On the other hand, if the black area is below a treshold of
% 10000 it considers the biggest black area as the pupil.

if area_max > 10000;
    
% show the BW image
imagesc(la_imagen);
colormap gray
hold on
% draw the red area around the pupil
rectangle('Position',out_a(pam_min).BoundingBox,'EdgeColor',[1 0 0],...
    'Curvature', [1,1],'LineWidth',2)
centro=round(out_a(pam_min).Centroid);

% detect the X and Y coordinates
X=centro(1);
Y=centro(2);

% save X and Y coordinates in the coordinates matrix
coordinate(i,1) = X;
coordinate(i,2) = Y;

% draw the cross at the center of the pupil
plot(X,Y,'g+')
%
text(X+10,Y,['(',num2str(X),',',num2str(Y),')'],'Color',[1 1 1])
if X<centro_columna && Y<centro_fila
    title('Top left')
elseif X>centro_columna && Y<centro_fila
    title('Top right')
elseif X<centro_columna && Y>centro_fila
    title('Bottom left')
else
    title('Bottom right')
end

elseif area_max < 10000;
    
% show the BW image
imagesc(la_imagen);
colormap gray
hold on
% draw the red area around the pupil
rectangle('Position',out_a(pam_max).BoundingBox,'EdgeColor',[1 0 0],...
    'Curvature', [1,1],'LineWidth',2)
centro=round(out_a(pam_max).Centroid);

% detect the X and Y coordinates
X=centro(1);
Y=centro(2);

% save X and Y coordinates in the coordinates matrix
coordinate(i,1) = X;
coordinate(i,2) = Y;

% draw the cross at the center of the pupil
plot(X,Y,'g+')
%
text(X+10,Y,['(',num2str(X),',',num2str(Y),')'],'Color',[1 1 1])
if X<centro_columna && Y<centro_fila
    title('Top left')
elseif X>centro_columna && Y<centro_fila
    title('Top right')
elseif X<centro_columna && Y>centro_fila
    title('Bottom left')
else
    title('Bottom right')
end

end
    
%% save current figure in a folder. IMPORTANT !!! Set your directory in the following command
saveas(gcf,['name of your directory',sprintf('%03d', i),'.png']);

end

%close arduino port number 2 
fprintf(ar,'%s',char(4));
% close arduino USB port
fclose(ar);
