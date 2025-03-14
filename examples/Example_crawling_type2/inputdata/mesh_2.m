clear all;
%close all;
clc;

figure 
scale = 3;

length_1 = 0.1;
length_2 = length_1 * scale;
bridgeDis = 0.25;

nv = 10;
delta = length_1 / (nv - 1);

theta = -pi/6;

nodes_1 = zeros(3,3);
temp = 1;
for i = 1:nv
    nodes_1(temp,1) = i * delta * cos(theta);
    nodes_1(temp,2) = 0.0;
    nodes_1(temp,3) = i * delta * sin(theta);
    temp = temp + 1;
end

node_temp_1 = nodes_1(temp-1,:);
for i = 1:nv*scale
    nodes_1(temp,1) = node_temp_1(1) + i * delta ;
    nodes_1(temp,2) = node_temp_1(2) ;
    nodes_1(temp,3) = node_temp_1(3) ;
    temp = temp + 1;
end


%plot3(nodes_1(:,1),nodes_1(:,2),nodes_1(:,3),'o')
%axis equal;
%hold on;

nodes_2 = zeros(3,3);
temp = 1;


for i = 3:nv*scale-2
    nodes_2(temp,1) = node_temp_1(1) + i * delta ;
    nodes_2(temp,2) = node_temp_1(2) ;
    nodes_2(temp,3) = node_temp_1(3) + 0.002;
    temp = temp + 1;
end


%plot3(nodes_2(:,1),nodes_2(:,2),nodes_2(:,3),'o')
%axis equal;


nodes_11(:,1) = nodes_1(:,1);
nodes_11(:,2) = nodes_1(:,3);

nodes_22(:,1) = nodes_2(:,1);
nodes_22(:,2) = nodes_2(:,3);



nodes = [nodes_11;nodes_22];

plot(nodes(:,1),nodes(:,2),'o')
hold on;

[nv,~] = size(nodes);

[edges] = computeElement(nodes, delta);
[bends] = computeBend(edges);
[coupleEdge] = computeCouple2d(nodes_11,nodes_22);

dlmwrite('nodesInput.txt',nodes,'delimiter',' ');
dlmwrite('edgeInput.txt',edges-1,'delimiter',' ');
dlmwrite('bendingInput.txt',bends-1,'delimiter',' ');
dlmwrite('coupleEdge.txt',coupleEdge-1,'delimiter',' ');

axis equal;
