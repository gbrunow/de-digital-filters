function [ output ] = plot_pop(pop, boundary, properties)
    
    if(isfield(properties,'plot') ~= 0)
        if properties.plot == false
           return; 
        end
    end
        
    x = -boundary:0.1:boundary;
    y = x;
    [X,Y] = meshgrid(x,y);
    z = benchmark_func([X;Y], properties);
    if(isfield(properties,'levels') == 0)
        properties.levels = 15;
    end
    if(isfield(properties,'fill') > 0)
        if properties.fill == false
            contour(X,Y,z, properties.levels);
        else
            contourf(X,Y,z, properties.levels);
        end
    else
        contourf(X,Y,z, properties.levels);
    end
    hold on;
    
    x = pop(1,:);
    y = pop(2,:);
    plot(x, y, 'g*');
    
    drawnow;
    hold off;

end

