function [edges] = computeElement(nodes, delta)

[nv, ~] = size(nodes);

edges = zeros(3,2);
temp = 1;

for i = 1:nv
    n1 = nodes(i,:);
    for j = i+1:nv
        n2 = nodes(j,:);
          
        if ( abs(delta - norm(n1-n2)) < delta * 1e-2 )
            edges(temp,1) = i;
            edges(temp,2) = j;
            temp = temp + 1;
        end
    end
end

end