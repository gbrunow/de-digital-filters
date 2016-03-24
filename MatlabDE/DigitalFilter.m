classdef DigitalFilter < handle 
    properties(GetAccess = public, SetAccess = private)
        samples = 512;
        w = linspace(0,pi,512);
        z = exp(-1j*linspace(0,pi,512));
    end
    
    properties
        gain = db2mag(1);
        type = 'IIR';
        cutoff
        order
        dw
        b
        a
        solver
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
            obj.dw = zeros(size(obj.w));
            obj.dw(obj.w >= obj.cutoff(1)) = obj.gain;
            obj.dw(obj.w > obj.cutoff(2)) = 0;
        end
        function obj = bandstop(obj)
            obj.dw = zeros(size(obj.w));
            obj.dw(obj.w < obj.cutoff(1)) = obj.gain;
            obj.dw(obj.w > obj.cutoff(2)) = obj.gain;
        end
        function obj = highpass(obj)
            obj.dw = zeros(size(obj.w));
            obj.dw(obj.w >= obj.cutoff) = obj.gain;
        end
        function obj = lowpass(obj)
            obj.dw = zeros(size(obj.w));
            obj.dw(obj.w < obj.cutoff) = obj.gain;
        end
        function plot(obj)
            hmag = mag2db(obj.dw);
            hmag(hmag < 0) = 0;
            plot(obj.w, hmag);
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
                legend('D(\omega)', 'H(\omega)');
            end
        end 
        function eval = getEval(obj)
            if strcmp(obj.type, 'IIR')
                eval = @(c) evalIIR(obj, c);
            elseif strcmp(obj.type,'FIR')
                eval = @(c) evalFIR(obj, c);
            end 
        end
%         function mse = evalIIR(obj, candidates)
%             half = obj.order + 1;
%             Bs = candidates(1:half,:);
%             As = candidates((half+1):end,:);
%             hw = zeros(size(Bs, 2), size(obj.w, 2));
%             for i=1:size(Bs,2)
%                 hw(i,:) = polyval(Bs(:,i), obj.z)./polyval(As(:,i), obj.z);
%             end
%             mse = obj.evalResponse(hw);
%         end
%         function mse = evalFIR(obj, candidates)
%             Bs = candidates;
%             hw = zeros(size(Bs, 2), size(obj.w, 2));
%             for i=1:size(Bs,2)
%                 hw(i,:) = polyval(Bs(:,i), obj.z);
%             end
%             mse = obj.evalResponse(hw);
%         end
%         function mse = evalResponse(obj, hw)
%             mse = zeros(1,size(hw,1));
%             for i=1:size(hw,1)
%                 ew = abs(obj.dw - hw(i,:));
%                 mse(i) = mean(ew.^2);
%             end
%         end
        function obj = setW(obj, w)
            obj.w = w;
            obj.samples = length(w);
            obj.z = exp(-1j*obj.w);
        end        
        function obj = setSamples(obj, samples)
            obj.samples = samples;
            obj.w = linspace(0, pi, samples);
            obj.z = exp(-1j*obj.w);
        end
    end    
end

