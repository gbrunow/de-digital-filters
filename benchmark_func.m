function [ output ] = benchmark_func(input, properties)    
    warning('off','all');
    % -- default options -- %
    a = 1;
    b = 100;
    d = 2;
    func = 'rosenbrock';
    plotting = false;
    
    if nargin > 1
        if isfield(properties,'a') > 0
            a = properties.a;
        end
        if isfield(properties,'b') > 0
            b = properties.b;
        end
        if isfield(properties,'dimensions') > 0
            d = properties.dimensions;
        else
           d =  size(input,1);
        end
        if isfield(properties,'function') > 0
            func = properties.function;
        end
        if isfield(properties,'plot') > 0
            plotting = properties.plot;
        end
    end
    
    switch func
        case 'rastrigin'
            if plotting == true && d == 2
                output = 10*d + (input(1:end/2,:).^2 - 10*cos(2*pi*input(1:end/2,:)));
                output = output + (input(end/2+1:end,:).^2 - 10*cos(2*pi*input(end/2+1:end,:)));
            else
                output = 10*d + sum(input.^2 - 10*cos(2*pi*input));
            end
        otherwise
            if d == 2
                x = input(1:end/2,:);
                y = input(end/2+1:end,:);
                output = (a - x).^2 + b*(y - x.^2).^2;
            else
                for i = 1:(size(input,1)-1)
                    output(i,:) = 100 * (input(i+1,:) - input(i,:).^2).^2 + (1 - input(i,:)).^2;
                end
                output = sum(output);
            end
    end
end

