clear all;
%close all;
clc;

figure
nv = 100;
radius = 0.1;

deltaTheta = 2.2 * pi / (nv - 1);
delta = radius * deltaTheta;

nodes_1 = zeros(3,2);
temp = 1;
for i = 1:nv
    radiusLocal = radius * (nv + i/10)/nv;
    nodes_1(temp,1) = radiusLocal * cos(deltaTheta * i - 0.5);
    %nodes_1(temp,2) = 0.0;
    nodes_1(temp,2) = radiusLocal * sin(deltaTheta * i - 0.5);
    temp = temp + 1;
end

thickness = 0.002;
nodes_2 = zeros(3,2);
temp = 1;

tangent = [0;0]';
for i = 2:nv-1
    
    node_m = nodes_1(i,:);
    
    if (i == 1)
        node_a = nodes_1(i+1,:);
        %norm(node_a - node_m)
        tangent = (node_a - node_m) / norm(node_a - node_m);
        normal(1) = -tangent(2);
        %normal(2) = 0.0;
        normal(2) = tangent(1);
        
        nodes_2(temp,:) = node_m + normal * thickness;
        temp = temp + 1;
    end
    
    if (i == nv)
        node_b = nodes_1(i-1,:);
        tangent = (node_m - node_b) / norm(node_m - node_b);
        normal(1) = -tangent(2);
        %normal(2) = 0.0;
        normal(2) = tangent(1);
        
        nodes_2(temp,:) = node_m + normal * thickness;
        temp = temp + 1;
    end
    
    if (i > 1 && i < nv)
        node_a = nodes_1(i+1,:);
        node_b = nodes_1(i-1,:);
        tangent = (node_a - node_b) / norm(node_a - node_b);
        normal(1) = -tangent(2);
        %normal(2) = 0.0;
        normal(2) = tangent(1);
        
        nodes_2(temp,:) = node_m + normal * thickness;
        temp = temp + 1;
    end
end



nodes = [nodes_1;nodes_2];

plot(nodes(:,1),nodes(:,2),'o')
hold on;

[nv,~] = size(nodes);

[edges] = computeElement(nodes, delta);
[bends] = computeBend(edges);
[coupleEdge] = computeCouple2d(nodes_1,nodes_2);

dlmwrite('nodesInput.txt',nodes,'delimiter',' ');
dlmwrite('edgeInput.txt',edges-1,'delimiter',' ');
dlmwrite('bendingInput.txt',bends-1,'delimiter',' ');
dlmwrite('coupleEdge.txt',coupleEdge-1,'delimiter',' ');
%dlmwrite('coupleBend.txt',coupleBend-1,'delimiter',' ');


