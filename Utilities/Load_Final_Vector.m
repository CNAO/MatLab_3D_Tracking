function [xf,xm]= Load_Final_Vector()

format long
fileName='PTC_track0.txtone';
nHeader = 0;
readFormat = '%f %f %f %f %f %f %f %f %f %f';
monitor = {'start';'S0';'SEND';'end'} ;



fileID = fopen(fileName,'r');
temp = textscan(fileID,'%f %f %f %f %s',1,'CommentStyle',{'@ NAME  ',  '#segment'});
N_particles = temp{3};
fclose(fileID);
%% Lettura file con riempimento array
% Create storage table
Table.x  = cell(1,length(monitor));
Table.y  = cell(1,length(monitor));
Table.px = cell(1,length(monitor));
Table.py = cell(1,length(monitor));

for i=1:length(monitor)
    Comments_String = {'@ NAME  ',  monitor{i}}; 
    fileID = fopen(fileName,'r');
    table_loss = textscan(fileID,readFormat,N_particles,'CommentStyle',Comments_String, 'HeaderLines', nHeader);
    Table.x{i}=table_loss{3};
    Table.px{i} = table_loss{4}; 
    Table.y{i} = table_loss{5};
    Table.py{i} = table_loss{6};
    fclose(fileID);
end
%% Ricavo Vettore Finale
xm=[Table.x{2} Table.px{2} Table.y{2} Table.py{2}];
xf=[Table.x{length(monitor)} Table.px{length(monitor)} Table.y{length(monitor)} Table.py{length(monitor)}];

