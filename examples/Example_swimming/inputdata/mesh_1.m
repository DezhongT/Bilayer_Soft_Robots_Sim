clear all;
close all;
clc;

figure

length = 0.1;
nv = 20;
delta = length / (nv - 1);

nodes_1 = zeros(3,3);

limb = 8;
alpha = 2 * pi / limb;

temp = 1;
nodes_1(temp,1) = 0.0;
nodes_1(temp,2) = 0.0;
nodes_1(temp,3) = 0.0;
temp = temp + 1;

for i = 1:limb
    for j = 1:nv
        tangent = zeros(3,1);
        
        tangent(1) = cos( (i-1)  * alpha );
        tangent(2) = sin( (i-1)  * alpha );
        
        nodes_1(temp,1) = tangent(1) * j * delta;
        nodes_1(temp,2) = tangent(2) * j * delta;
        nodes_1(temp,3) = 0.0;
        temp = temp + 1;
    end
end

[nv1,~] = size(nodes_1);
startPoint = zeros(limb,1);
temp2 = 1;
temp = 1;
nodes_2 = zeros(3,3);
for i = 1:limb
    
    startPoint(temp2) = temp + nv1;
    temp2 = temp2 + 1;
    
    for j = 2:nv-1
        tangent = zeros(3,1);
        
        tangent(1) = cos( (i-1)  * alpha );
        tangent(2) = sin( (i-1)  * alpha );
        
        nodes_2(temp,1) = tangent(1) * j * delta;
        nodes_2(temp,2) = tangent(2) * j * delta;
        nodes_2(temp,3) = 1.0;
        temp = temp + 1;
    end
end

nodes = [nodes_1;nodes_2];

plot3(nodes(:,1),nodes(:,2),nodes(:,3),'o')
[nv,~] = size(nodes);

hold on;
plot3(nodes(startPoint,1),nodes(startPoint,2),nodes(startPoint,3),'s')

[edges] = computeElement(nodes, delta);
[coupleEdge] = computeCouple(nodes);
[coupleBend] = computeCoupleBend(nodes,edges);

[ne_c,~] = size(coupleEdge);

[ne,~] = size(edges);
temp = ne + 1;
for i = 1:limb
    index = startPoint(i);
    
    for j = 1:ne_c
        
        index1 = coupleEdge(j,1);
        index2 = coupleEdge(j,2);
        
        flag = 0;
        
        if (index1 == index && index2 <= nv1)
            flag = 1;
        end
        
        if (index2 == index && index1 <= nv1)
            flag = 1;
        end
        
        if (flag == 1)
            edges(temp,1) = index1 - 1;
            edges(temp,2) = index;
            temp = temp + 1;
        end
        
    end
    
end


[ne, ~] = size(edges);

for i = 1:ne
    index1 = edges(i,1);
    index2 = edges(i,2);
    
    n1 = nodes(index1,:);
    n2 = nodes(index2,:);
    
    plot3([n1(1) n2(1)], [n1(2) n2(2)],[n1(3) n2(3)], 'r-');
end



[bends] = computeBend(edges);

[nv, ~] = size(nodes);
for i = 1:nv
    height = nodes(i,3);
    
    if (height > 0.5)
        nodes(i,3) = 0.005;
    end
end
figure(2)
plot3(nodes(:,1),nodes(:,2),nodes(:,3),'o')
hold on;

axis equal;

dlmwrite('nodesInput.txt',nodes,'delimiter',' ');
dlmwrite('edgeInput.txt',edges-1,'delimiter',' ');
dlmwrite('bendingInput.txt',bends-1,'delimiter',' ');
dlmwrite('coupleEdge.txt',coupleEdge-1,'delimiter',' ');
dlmwrite('coupleBend.txt',coupleBend-1,'delimiter',' ');




