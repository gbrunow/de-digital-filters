classdef DigitalFilter < handle 
    properties(GetAccess = public, SetAccess = private)
        samples = 512;
        w = linspace(0,pi,512);
        z = exp(-1j*linspace(0,pi,512));
        func = @(w) w;
    end
    
    properties
        gain = 1;
        type = 'IIR';
        cutoff
        order
        dw
        b
        a
        solver
        plotSamples = 2048;
    end
    
    methods
        function obj = DigitalFilter(cutoff, order, w)
            obj.cutoff = cutoff;
            obj.order = order;
            if(exist('w', 'var'))
                obj.w = w;
            end 
        end
        
        function obj = bandpass(obj)
            obj.func = @(w) (w >= obj.cutoff(1) & w <= obj.cutoff(2)) * obj.gain;
            obj.dw = obj.func(obj.w);
        end
        
        function obj = bandstop(obj)
            obj.func = @(w) (w <= obj.cutoff(1) & w >= obj.cutoff(2)) *obj.gain;
            obj.dw = obj.func(obj.w);
        end
        
        function obj = highpass(obj)
            obj.func = @(w) (w >= obj.cutoff) * obj.gain;
            obj.dw = obj.func(obj.w);
        end
        
        function obj = lowpass(obj)
            obj.func = @(w) (w <= obj.cutoff) * obj.gain;
            obj.dw = obj.func(obj.w);
        end
        
        function plot(obj)
            tempSamples = obj.samples;
            obj.setSamples(obj.plotSamples);
            hold off;
            plot(obj.w, obj.dw);
            xlabel('Frequency (rad/samples)');
            ylabel('Gain (db)');
            ax = gca;
            set(ax,'XTick',[0 0.25*pi 0.5*pi 0.75*pi pi])
            set(ax,'XTickLabel',{'0','\pi/4','\pi/2','3\pi/4','\pi'})
            xlim([0 pi]);
            if length(obj.b) > 0
                if length(obj.a) > 0
                    [ha,wa] = freqz(obj.b,obj.a,obj.w);
                else
                    [ha,wa] = freqz(obj.b,obj.w);
                end
                hold on;
                plot(wa,abs(ha));
                hold off;
                legend('D(\omega)', 'H(\omega)');
            end
            obj.setSamples(tempSamples);
        end 
        
        function eval = getEval(obj)
            if strcmp(obj.type, 'IIR')
                eval = @(c) evalIIR(obj, c);
            elseif strcmp(obj.type,'FIR')
                eval = @(c) evalFIR(obj, c);
            end 
        end
        
        function obj = setW(obj, w)
            obj.w = w;
            obj.samples = length(w);
            obj.z = exp(-1j*obj.w);
            obj.dw = obj.func(obj.w);
        end        
        
        function obj = setSamples(obj, samples)
            obj.samples = samples;
            obj.w = linspace(0, pi, samples);
            obj.z = exp(-1j*obj.w);
            obj.dw = obj.func(obj.w);
        end
    end    
end

