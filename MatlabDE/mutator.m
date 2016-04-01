function [x, mutation, restore] = mutator( g, pop, diversifier, A, archiveSize )
    [D, NP] = size(pop);
    if nargin > 4
        PA = NP + archiveSize;
    else
        PA = NP;
    end
    
    a = randi(PA,1,NP);
    
    repeated = a == 1:NP;
    while(~isempty(repeated(repeated == true)))
        newCrossing = randi(PA,1,NP);
        a(repeated) = newCrossing(repeated);
        repeated = a == 1:NP;
    end
    
    b = randi(PA,1,NP);
    repeated = b == 1:NP;
    repeated = repeated | b == a;
    while(~isempty(repeated(repeated == true)))
        newCrossing = randi(PA,1,NP);
        b(repeated) = newCrossing(repeated);
        repeated = b == 1:NP;
        repeated = repeated | b == a;
    end
    
    c = randi(NP,1,NP);
    repeated = c == 1:NP;
    repeated = repeated | c == a;
    repeated = repeated | c == b;
    while(~isempty(repeated(repeated == true)))
        newCrossing = randi(NP,1,NP);
        c(repeated) = newCrossing(repeated);
        repeated = c == 1:NP;
        repeated = repeated | c == a;
        repeated = repeated | c == b;
    end
    
    if(nargin > 4 && archiveSize > 0)
       union = [pop A]; 
    else
        union = pop;
    end
    
    popA = union(:,a);
    popB = union(:,b);
    mutation = popA - popB;
    
    if nargin > 2
        restore = diversifier(mutation,g);
    end
    
    x = c;
end

