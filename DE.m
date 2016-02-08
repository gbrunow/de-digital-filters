function [ output_args ] = DE(D, NP, n, F, CR, minB, maxB, func, func_args)
    % DE(D, NP, n, minB, maxB, func, func_args*)
    %
    % D:            dimensions number
    % NP:           population size
    % n:            maximum number of generations
    % minB:         minumum boundary
    % maxB:         maximum boundary
    % func:         function to be minimized
    % func_args:    any extra arguments that 'func' may need
    % *:            optional arguments

    G = 0;                  %generation

    d = 0.1;
    alpha = 0.06;
    zeta = 1;

    pop = (maxB - minB) .* rand(D, NP) + minB;

    tic;
    
    progress_bar = '[                    ]';
    progress = 1;
    disp([progress_bar(1:end/2) '0.00%' progress_bar(end/2+1:end)]);

    pop_std = ones(D,1);
    
    score = inf * ones(NP,1);

    while G < n && ~isempty(pop_std(pop_std > 0))
        G = G + 1;
        pop_old = pop;

        [a, b, c] = randPop(NP,D);

        pop_a = pop(:,a);
        pop_b = pop(:,b);
        pop_c = pop(:,c);

        %-------- determine wether to cross or not --------%
        randJ = randi(D, [D NP]);       %random dimension matrix
        cross = zeros(size(randJ));
        for j = 1:D
            cross(j,:) = randJ(j,:) == j;
        end

        cross = rand([D NP]) < CR | cross;
        %--------------------------------------------------%

        pop = pop_a + F * (pop_b - pop_c) .* cross;
        pop(pop>maxB) = maxB;
        pop(pop<minB) = minB;

        pop_diff = abs(pop_old - pop);

        %------- population diversification -------%
        threshold = alpha*d*((n-G)/G)^zeta;

        less_than_threshold = pop_diff < threshold;
        skip_vector = sum(less_than_threshold) > 0;
        
        if ~isempty(pop(less_than_threshold))

            [a, b, c] = randPop(NP,D,skip_vector);

            pop_a = pop(:,a);
            pop_b = pop(:,b);
            pop_c = pop(:,c);

            pop(less_than_threshold) = pop_a(less_than_threshold) + F * (pop_b(less_than_threshold) - pop_c(less_than_threshold)) .* cross(less_than_threshold);

        end
        %------------------------------------------%

        old_score = score;
        score = func(pop, func_args);
        pop(:,score > old_score) = pop_old(:,score > old_score);

        pop_std = std(pop,1,2);
        
        percentage = G/n*100;
        if(mod(percentage,5) == 0)
            progress = progress + 1;
            progress_bar(progress) = '=';
            progress_bar(progress+1) = '>';
            tempArgs = func_args;
            tempArgs{end+1} = true;
            info = func(pop, tempArgs);
            out = plotBestFilter(info);
            drawnow;
            clc;
            disp([progress_bar(1:end/2) sprintf('%1.2f',percentage) '%' progress_bar(end/2+1:end)]);
            toc;
            disp(['Error ' num2str(out(1), 10) ' at generation ' num2str(G) '.']);
        end
    end

    toc;
    
    score = func(pop, func_args);
    [error, index] = min(score);
    output_args = pop(:,index);
    
end
