function [ a, b, c ] = randPop( NP, skip )

        if nargin < 2
            skip = ones(1,NP);
        end

        a = randi(NP, [1 NP]);

        b = randi(NP, [1 NP]);
        b_equals_a = (b == a) .* skip > 0; 
        while ~isempty(b(b_equals_a))
            new_b = randi(NP, [1 NP]);
            b(b_equals_a) = new_b(b_equals_a);
            b_equals_a = b == a;
        end

        c = randi(NP, [1 NP]);
        c_equals_a_or_b = (c == b | c == a) .* skip > 0;
        while ~isempty(c(c_equals_a_or_b))
            new_c = randi(NP, [1 NP]);
            c(c_equals_a_or_b) = new_c(c_equals_a_or_b);
            c_equals_a_or_b = c == b | c == a;
        end
        
        % fast but not as eficient
% function [ pops ] = randPop( NP, n )

%     if n > factorial(NP)
%         disp('Invalid arguments.');
%     end
%     pops = zeros(n, NP);
% 
%     rot = (0 : 1 : NP-1);
%     
%     ind = randperm(n-1);        % index pointer array
%     
%     pops(1,:) = randperm(NP);
%     
%     for i=2:(n)
%         popi = pops(i-1,:);
%         rt = rem(rot + ind(i-1), NP);
%         pops(i,:) = popi(rt + 1);
%     end
end

