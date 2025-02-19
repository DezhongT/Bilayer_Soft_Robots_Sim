function [couple] = computeCouple2d(nodes_1, nodes_2)

[nv1, ~] = size(nodes_1);
[nv2, ~] = size(nodes_2);

couple = zeros(3,2);
temp = 1;

for i = 1:nv2
    n1 = nodes_2(i,1:2);
    
    minDis = 1000;
    mindIndex = 1;
    for j = 1:nv1
        n2 = nodes_1(j,1:2);
        if ( norm(n1-n2) < minDis )
            minDis = norm(n1-n2);
            mindIndex = j;
        end
    end
    
    couple(temp,1) = mindIndex;
    couple(temp,2) = i + nv1;
    temp = temp + 1;
end


[ne, ~] = size(couple);


for i = 1:ne
    index1 = couple(i,1);
    index2 = couple(i,2);
    
    n1 = nodes_1(index1,:);
    n2 = nodes_2(index2-nv1,:);
    
    plot([n1(1) n2(1)], [n1(2) n2(2)], 'g-');
end

end