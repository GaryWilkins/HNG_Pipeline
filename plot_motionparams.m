function plot_motionparams(path)

addpath(path);
LS = textread('SPM_TEMP_FILE.txt','%s');

for i=1:size(LS,1)
    try
        parfile = LS{i};
        A = load(parfile);
        % get size of A (should be 6 columns of n values each)
        n = size(A,1);
        % generate x axis values
        x_axis = zeros(n,1);
        x_axis(1) = 1;
        for i=2:n
            x_axis(i)=x_axis(i-1)+1;
        end
        f = figure()
        ax1 = subplot(2,1,1);
        ax2 = subplot(2,1,2);
        %ax1 = subplot(3,1,1);
        %ax2 = subplot(3,1,2);
        %ax3 = subplot(3,1,3);
        legend('show')
        plot(ax1,x_axis,A(:,1),x_axis,A(:,2),x_axis,A(:,3))
        title(ax1,'4dRegister estimated translations (mm)')
        legend(ax1,'x','y','z')
        plot(ax2,x_axis,A(:,4),x_axis,A(:,5),x_axis,A(:,6))
        title(ax2,'4dRegister estimated rotations (radians)')
        legend(ax2,'roll','pitch','yaw')
        %plot(ax3,x_axis,mean(A(:,1:3)'),x_axis,mean(A(:,4:6)'))
        %title(ax3,'4dRegister estimated mean displacement)')
        %legend(ax3,'absolute','relative')
        
        %get filename from the parfile
        [fpath,name,~] = fileparts(parfile);
        suptitle(name)

        saveas(f, strcat(name,'.png'));
        %movefile(strcat(name,'.png'),fpath);
    catch
        disp('not an appropriate file')
    end
end