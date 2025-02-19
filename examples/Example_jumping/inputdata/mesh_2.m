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

theta = -pi/8;

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
    nodes_2(temp,3) = node_temp_1(3) + 0.1;
    temp = temp + 1;
end


%plot3(nodes_2(:,1),nodes_2(:,2),nodes_2(:,3),'o')
%axis equal;

nv_1 = size(nodes_1)
nodes_11(:,1) = nodes_1(:,1);
nodes_11(:,2) = nodes_1(:,3);

nodes_22(:,1) = nodes_2(:,1);
nodes_22(:,2) = nodes_2(:,3);



nodes = [nodes_11;nodes_22];



[nv,~] = size(nodes);

[edges] = computeElement(nodes, delta);
[bends] = computeBend(edges);
[coupleEdge] = computeCouple2d(nodes_11,nodes_22);

[ne, ~] = size(edges);




nodes(:,2) = nodes(:,2) - min(nodes(:,2)) + 0.002;

for i = nv_1+1:nv
    
    %if (nodes(i,2)> 0.08)
        nodes(i,2) = 0.0 + 0.004;
    %end
end


nodes(:,3) = nodes(:,1) * 0.0;


plot(nodes(:,1),nodes(:,2),'o')
hold on;
for i = 1:ne
    index1 = edges(i,1);
    index2 = edges(i,2);
    
    n1 = nodes(index1,:);
    n2 = nodes(index2,:);
    
    plot([n1(1) n2(1)], [n1(2) n2(2)], 'r-');
end

axis equal;

dlmwrite('nodesInput.txt',nodes,'delimiter',' ');
dlmwrite('edgeInput.txt',edges-1,'delimiter',' ');
dlmwrite('bendingInput.txt',bends-1,'delimiter',' ');
dlmwrite('coupleEdge.txt',coupleEdge-1,'delimiter',' ');

