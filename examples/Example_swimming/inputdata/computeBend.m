function [bend] = computeBend(edges)

[ne, ~] = size(edges);

bend = zeros(3,2);
temp = 1;

for i = 1:ne
    index1 = edges(i,1);
    index2 = edges(i,2);
    for j = i+1:ne
        index3 = edges(j,1);
        index4 = edges(j,2);
        
        flag = 0;
        
        if (index1 == index3)
            flag = 1;
        end
        
        if (index1 == index4)
            flag = 1;
        end
       
        if (index2 == index3)
            flag = 1;
        end
        
        if (index2 == index4)
            flag = 1;
        end
        
        if (flag == 1)
            bend(temp,1) = i;
            bend(temp,2) = j;
            temp = temp + 1;
        end
    end
end



end