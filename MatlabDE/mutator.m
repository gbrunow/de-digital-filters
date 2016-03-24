function [x, mutation] = mutator( pop, A, archiveSize )
    [D, NP] = size(pop);
    PA = NP + archiveSize;
    
    crossing = zeros(3,NP);
    crossing(1,:) = randi(PA,1,NP);
    
    repeated = crossing(1,:) == 1:NP;
    while(~isempty(repeated(repeated == true)))
        newCrossing = randi(PA,1,NP);
        crossing(1,repeated) = newCrossing(repeated);
        repeated = crossing(1,:) == 1:NP;
    end
    
    crossing(2,:) = randi(PA,1,NP);
    repeated = crossing(2,:) == 1:NP;
    repeated = repeated | crossing(2,:) == crossing(1,:);
    while(~isempty(repeated(repeated == true)))
        newCrossing = randi(PA,1,NP);
        crossing(2,repeated) = newCrossing(repeated);
        repeated = crossing(2,:) == 1:NP;
        repeated = repeated | crossing(2,:) == crossing(1,:);
    end
    
    crossing(3,:) = randi(NP,1,NP);
    repeated = crossing(3,:) == 1:NP;
    repeated = repeated | crossing(3,:) == crossing(1,:);
    repeated = repeated | crossing(3,:) == crossing(2,:);
    while(~isempty(repeated(repeated == true)))
        newCrossing = randi(NP,1,NP);
        crossing(3,repeated) = newCrossing(repeated);
        repeated = crossing(3,:) == 1:NP;
        repeated = repeated | crossing(3,:) == crossing(1,:);
        repeated = repeated | crossing(3,:) == crossing(2,:);
    end
    
    if(archiveSize > 0)
       union = [pop A]; 
    else
        union = pop;
    end
    
    popA = union(:,crossing(1,:));
    popB = union(:,crossing(2,:));
    mutation = popA - popB;
    x = crossing(3,:);
end

