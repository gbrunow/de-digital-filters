function [x, mutation] = mutator( g, pop, A, archiveSize, diversifier )
    [D, NP] = size(pop);
    if nargin > 2
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
    
    if(nargin > 2 && archiveSize > 0)
       union = [pop A]; 
    else
        union = pop;
    end
    
    popA = union(:,a);
    popB = union(:,b);
    mutation = popA - popB;
    
    if nargin > 4
        mutation(diversifier(mutation,g)) = 0;
    end
    
    x = c;
end

