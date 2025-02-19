clear all;
close all;
clc;

figure 
nv = 60;
radius = 0.1;

delta = 3/5 * pi / (nv - 1);

nodes_1 = zeros(3,2);
temp = 1;
for i = 1:nv
    radiusLocal = radius;
    nodes_1(temp,1) = radiusLocal * cos(delta * i + 6*pi/5);
    nodes_1(temp,2) = 0.0;
    nodes_1(temp,3) = radiusLocal * sin(delta * i + 6*pi/5);
    temp = temp + 1;
end

deltaTheta = 0.4;

[currentNv, ~] = size(nodes_1);
minD = 1000;
minIndex = 1;
ConnectNode(1) = radiusLocal * cos(deltaTheta + 6*pi/5);
ConnectNode(2) = 0.0;
ConnectNode(3) = radiusLocal * sin(deltaTheta + 6*pi/5);

for i = 1:currentNv
    nodeLocal = nodes_1(i,:);
    
    if ( abs( norm(ConnectNode - nodeLocal) ) < minD )
        minIndex = i;
        minD = norm(ConnectNode - nodeLocal);
    end
end


nv_2 = 10;
node_b = nodes_1(minIndex-1,:);
node_c = nodes_1(minIndex,:);
node_a = nodes_1(minIndex+1,:);
tangent = (node_a - node_b) / norm((node_a - node_b));
normal(1) = - tangent(3);
normal(2) = 0.0;
normal(3) = tangent(1);
normal(1) = normal(1) + 0.5;
normal = normal / norm(normal);
for i = 1:nv_2
    nodes_1(temp,:) = node_c - normal * i * delta * radius;
    temp = temp + 1;
end

node_s = nodes_1(temp-1,:);
tang = [-1 0 0.0];
tang = tang / norm(tang);
for i = 1:5
    nodes_1(temp,:) = node_s + tang * i * delta * radius;
    temp = temp + 1;
end

nv_2 = 10;
minIndex=nv;
node_b = nodes_1(minIndex-1,:);
node_c = nodes_1(minIndex,:);
node_a = nodes_1(minIndex,:);
tangent = (node_a - node_b) / norm((node_a - node_b));
normal(1) = - tangent(3);
normal(2) = 0.0;
normal(3) = tangent(1);
normal(1) = normal(1) - 0.5;
normal = normal / norm(normal);
for i = 1:nv_2+3
    nodes_1(temp,:) = node_c - normal * i * delta * radius;
    temp = temp + 1;
end

node_s = nodes_1(temp-1,:);
tang = [0.0 0 -1];
tang = tang / norm(tang);
for i = 1:nv_2
    nodes_1(temp,:) = node_s + tang * i * delta * radius;
    temp = temp + 1;
end

plot(nodes_1(:,1),nodes_1(:,3),'o')
hold on;
axis equal


size(nodes_1)

thickness = 0.002;
nodes_2 = zeros(3,3);
temp = 1;

tangent = [0;0;0]';
for i = 2:nv-1
    
    node_m = nodes_1(i,:);
    
    if (i == 1)
        node_a = nodes_1(i+1,:);
        %norm(node_a - node_m)
        tangent = (node_a - node_m) / norm(node_a - node_m);
        normal(1) = -tangent(3);
        normal(2) = 0.0;
        normal(3) = tangent(1);
        
        nodes_2(temp,:) = node_m + normal * thickness;
        temp = temp + 1;
    end
    
    if (i == nv)
        node_b = nodes_1(i-1,:);
        tangent = (node_m - node_b) / norm(node_m - node_b);
        normal(1) = -tangent(3);
        normal(2) = 0.0;
        normal(3) = tangent(1);
        
        nodes_2(temp,:) = node_m + normal * thickness;
        temp = temp + 1;
    end
    
    if (i > 1 && i < nv)
        node_a = nodes_1(i+1,:);
        node_b = nodes_1(i-1,:);
        tangent = (node_a - node_b) / norm(node_a - node_b);
        normal(1) = -tangent(3);
        normal(2) = 0.0;
        normal(3) = tangent(1);
        
        nodes_2(temp,:) = node_m + normal * thickness;
        temp = temp + 1;
    end
end

%plot(nodes_2(:,1),nodes_2(:,3),'s');

nv_1 = size(nodes_1)
nodes_11(:,1) = nodes_1(:,1);
nodes_11(:,2) = nodes_1(:,3);

nodes_22(:,1) = nodes_2(:,1);
nodes_22(:,2) = nodes_2(:,3);



nodes = [nodes_11;nodes_22];

plot(nodes(:,1),nodes(:,2),'o')
hold on;

[nv,~] = size(nodes);

[edges] = computeElement(nodes, delta*radius);
[bends] = computeBend(edges);
[coupleEdge] = computeCouple2d(nodes_11,nodes_22);

[ne, ~] = size(edges);

for i = 1:ne
    index1 = edges(i,1);
    index2 = edges(i,2);
    
    n1 = nodes(index1,:);
    n2 = nodes(index2,:);
    
    plot([n1(1) n2(1)], [n1(2) n2(2)], 'r-');
end

plot(nodes(13:48,1),nodes(13:48,2),'gs')
nodes(:,2) = nodes(:,2) - min(nodes(:,2)) + 0.002;

nodes(:,3) = nodes(:,1) * 0.0;
dlmwrite('nodesInput.txt',nodes,'delimiter',' ');
dlmwrite('edgeInput.txt',edges-1,'delimiter',' ');
dlmwrite('bendingInput.txt',bends-1,'delimiter',' ');
dlmwrite('coupleEdge.txt',coupleEdge-1,'delimiter',' ');