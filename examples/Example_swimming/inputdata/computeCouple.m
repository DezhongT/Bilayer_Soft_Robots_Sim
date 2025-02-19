function [couple] = computeCouple(nodes)

[nv, ~] = size(nodes);

couple = zeros(3,2);
temp = 1;

for i = 1:nv
    n1 = nodes(i,1:2);
    h1 = nodes(i,3);
    for j = i+1:nv
        n2 = nodes(j,1:2);
        h2 = nodes(j,3);
        
        if ( abs(norm(n1-n2)) < 1e-4 && abs(abs(h1-h2)-1) < 1e-4 )
            couple(temp,1) = i;
            couple(temp,2) = j;
            temp = temp + 1;
        end
    end
end


[ne, ~] = size(couple);

for i = 1:ne
    index1 = couple(i,1);
    index2 = couple(i,2);
    
    n1 = nodes(index1,:);
    n2 = nodes(index2,:);
    
    plot3([n1(1) n2(1)], [n1(2) n2(2)],[n1(3) n2(3)], 'g-');
end

end