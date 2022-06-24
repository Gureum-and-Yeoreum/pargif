function [] = pargif(result,n_range,varname,dim,opt,delay,par)

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

    hold on
    mat_tmp = result(par).(varname(i));
    surf(mat_tmp(:,:,n_range(1)))
    view(dim(i))
    hold off
    aa = axis;
    drawnow
    title(append(varname(i),' at t = ',num2str(result(1).dt*n_range(1)*1e6,'%.2f'),' us'))

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
        title(append(varname(i),' at t = ',num2str(result(1).dt*j*1e6,'%.2f'),' us'))
        frame = getframe(figure_tmp);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        imwrite(imind,cm,append(opt.save,varname(i),' ',num2str(par),'.gif'),'gif','WriteMode','append','DelayTime',delay);
    end
end

end