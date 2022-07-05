function [] = pargif(result,n_range,varname,dim,opt,delay,par,userlabel,useraxis,usertitle)

persistent figure_tmp
nvars = size(varname,2);

if ~exist('delay','var')
    delay = 0.5;
end
if ~exist('par','var')
    par = 0;
end

for i = 1:nvars
    figure_tmp = figure;
    j = n_range(1);

    hold on
    mat_tmp = result(par).(varname(i));
    surf(mat_tmp(:,:,n_range(1)))
    view(dim(i))
    hold off

    if ~isempty(useraxis(i,:))
        axis(useraxis(i,:))
    end

    if ~isempty(userlabel(i,:))
        xlabel(userlabel(i,1))
        ylabel(userlabel(i,2))
        zlabel(userlabel(i,3))
        xl = xlabel;
        yl = ylabel;
        zl = zlabel;
    else
        xl = [];
        yl = [];
        zl = [];
    end

    aa = axis;
    drawnow
    
    try
        title_tmp = cell2mat(usertitle(i));
    catch
        try
            title_tmp = usertitle(i);
        catch
            title_tmp = [];
        end
    end
    
    if isa(title_tmp,'function_handle')
        title(title_tmp(i,j,varname,n_range,result))
    else
        title(title_tmp)
    end

    frame = getframe(figure_tmp);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,append(opt.save,varname(i),' ',num2str(par),'.gif'),'gif','Loopcount',inf,'DelayTime',delay);

    for j = n_range(1)+1:n_range(2)
        clf(figure_tmp)
        figure(figure_tmp)
        hold on
        mat_tmp = result(par).(varname(i));
        surf(mat_tmp(:,:,j))
        view(dim(i))
        axis(aa)
        hold off
        drawnow

        if isa(title_tmp,'function_handle')
            title(title_tmp(i,j,varname,n_range,result))
        else
            title(title_tmp)
        end

        xlabel(xl)
        ylabel(yl)
        zlabel(zl)

        frame = getframe(figure_tmp);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        imwrite(imind,cm,append(opt.save,varname(i),' ',num2str(par),'.gif'),'gif','WriteMode','append','DelayTime',delay);
    end
end

% Input
% n_range = [n_start, n_end], integar
% varname = fieldname
% dim = view dimension
% opt contains save directory
% maybe you need make folder first
% delay = gif delay time
% par = parallel index
% 
% Output
% gif
%
%
% BSD 3-Clause License
% 
% Copyright (c) 2022, Gureum-and-Yeoreum
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

end