function [coupleBend] = computeCoupleBend2(nodes,edges)

%[nv, ~] = size(nodes);
[ne, ~] = size(edges);

coupleBend = zeros(3,2);
temp = 1;

for i = 1:ne
    index1 = edges(i,1);
    index2 = edges(i,2);
    n1 = nodes(index1,1:2);
    h1 = nodes(index1,3);
    n2 = nodes(index2,1:2);
    h2 = nodes(index2,3);
    
    for j = i+1:ne
        index3 = edges(j,1);
        index4 = edges(j,2);
        n3 = nodes(index3,1:2);
        h3 = nodes(index3,3);
        n4 = nodes(index4,1:2);
        h4 = nodes(index4,3);
        
        flag = 0;
        if ( abs(norm(n1-n3)) < 1e-4 && abs(abs(h1-h3)-1) < 1e-4 && abs(norm(n2-n4)) < 1e-4 && abs(abs(h2-h4)-1) < 1e-4 )
            flag = 1;
        end
        if ( abs(norm(n1-n4)) < 1e-4 && abs(abs(h1-h4)-1) < 1e-4 && abs(norm(n2-n3)) < 1e-4 && abs(abs(h2-h3)-1) < 1e-4 )
            flag = 1;
        end
        
        if (flag == 1)
            coupleBend(temp,1) = i;
            coupleBend(temp,2) = j;
            temp = temp + 1;
        end
    end
end

end