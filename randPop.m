function [ a, b, c ] = randPop( NP, D, skip )

        if nargin < 3
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
end

